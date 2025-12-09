
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/common/dio_wrapper.dart';
import 'package:com.xiaoyoushijie.app/common/utils/math_utils.dart';
import 'package:provider/provider.dart';
import '../common/current_user.dart';
import '../common/utils/sqlite_helper.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import 'app_state.dart';
import 'notification_state.dart';

class MessageState extends AppState {

  Timer? _timer;

  // conversation 会话
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<ConversationModel> _items = [];
  List<ConversationModel> get items => _items;
  int _page = 1;

  // message 消息
  bool _isLoadingMessage = false;
  bool get isLoadingMessage => _isLoadingMessage;
  List<MessageModel> _items4Message= [];
  List<MessageModel> get items4Message => _items4Message;
  int _page4Message = 1;

  // 用于Polling拉取消息
  int currentConversationId = 0;

  // 未读会话 计数
  int get totalUnreadConversationsCount =>
      _items.where((c) => c.unreadCount > 0).length;

  // 下拉刷新 消息
  Future<void> refreshData4Message({int conversationId = 0, int peerUid = 0}) async {
    currentConversationId = conversationId;
    _items4Message = [];
    _isLoadingMessage = true;
    notifyListeners();
    _page4Message = 1;
    _items4Message = await getMessages(conversationId: conversationId, peerUid: peerUid, page: _page4Message);
    _isLoadingMessage = false;
    notifyListeners();
  }

  // 上拉加载更多 消息
  Future<void> loadMoreData4Message({int conversationId = 0, int peerUid = 0}) async {
    _isLoadingMessage = true;
    notifyListeners();
    _page4Message++;
    _items4Message.addAll(await getMessages(conversationId: conversationId, peerUid: 0, page: _page4Message));
    _isLoadingMessage = false;
    notifyListeners();
  }

  // 下拉刷新 会话
  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();
    _page = 1;
    _items = await getConversations(_page);
    _isLoading = false;
    notifyListeners();
  }

  // 上拉加载更多  会话
  Future<void> loadMoreData() async {
    _isLoading = true;
    notifyListeners();
    _items.addAll(await getConversations(_page++));
    _isLoading = false;
    notifyListeners();
  }

  // void startPolling(BuildContext context) {
  //   if (_timer != null) return;
  //   _timer = Timer.periodic(Duration(seconds: 30), (_) => _fetchMessages(context));
  // }

  // 由传递 BuildContext 换成
  void startPolling(NotificationState notificationState) {
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 30), (_) {
      _fetchMessages(notificationState: notificationState);
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetchMessages({required NotificationState notificationState}) async {

    print("start _fetchMessages");
    if( CurrentUser.instance.uid == 0 ) {
      print("CurrentUser is null, stop fetchMessages");
      return;
    }

    final db = SQLiteHelper();

    // 获取本地 conversation 表中最新 last_timestamp
    final conversationTimestampRow = await db.rawQuery(
      '''
        SELECT MAX(lastTimestamp) as max_timestamp FROM conversation 
        WHERE user1Id = ? OR user2Id = ?
      ''',
      [CurrentUser.instance.uid, CurrentUser.instance.uid]
    );
    final lastConversationTimestamp = (conversationTimestampRow.isNotEmpty &&
        conversationTimestampRow.first['max_timestamp'] != null)
        ? (conversationTimestampRow.first['max_timestamp'] as int)
        : 0;

    // 获取本地 message 表最大 ID
    final messageIdRow = await db.rawQuery(
      '''
      SELECT MAX(id) as max_id FROM message 
      WHERE senderUid = ? OR receiverUid = ?
      ''',
      [CurrentUser.instance.uid, CurrentUser.instance.uid],
    );
    final lastMessageId = (messageIdRow.isNotEmpty &&
        messageIdRow.first['max_id'] != null)
        ? messageIdRow.first['max_id'] as int
        : 0;

    // 获取本地 notification 表最大 ID
    final notificationRow = await db.rawQuery(
      '''
      SELECT MAX(id) as max_id FROM notification WHERE sourceUid = ?
      ''',
      [CurrentUser.instance.uid],
    );
    final lastNotificationId = (notificationRow.isNotEmpty && notificationRow.first['max_id'] != null)
        ? notificationRow.first['max_id'] as int
        : 0;

    // 向服务器发送请求
    FormData formData = new FormData.fromMap({
      "lastConversationTimestamp": lastConversationTimestamp,
      "lastMessageId": lastMessageId,
      "lastNotificationId" : lastNotificationId
    });

    var response = await DioWrapper().dio.post("/api/chat/fetchMessages", data: formData);
    Map<String, dynamic> result = response.data;
    if (result["code"] == 0) {

      final conversations = (result["data"]['conversations'] as List?) ?? [];
      final messages = (result["data"]['messages'] as List?) ?? [];
      final users = (result["data"]['users'] as List?) ?? [];
      final notifications = (result["data"]['notifications'] as List?) ?? [];

      // 插入用户
      for (final u in users) {
        await db.insert('user', Map<String, dynamic>.from(u));
      }

      // 插入会话
      for (final c in conversations) {
        await db.insert('conversation', Map<String, dynamic>.from(c));
      }

      // 插入消息
      for (final m in messages) {
        await db.insert('message', Map<String, dynamic>.from(m));
      }

      // 插入通知
      for (final n in notifications) {
        await db.insert('notification', Map<String, dynamic>.from(n));
      }

      // 刷新会话列表页
      if ( conversations.length > 0 ) {
        refreshData();
      }

      // 刷新当前message页
      if( currentConversationId != 0 ) {
        refreshData4Message(conversationId: currentConversationId);
      }

      // 刷新通知页
      if( notifications.length > 0 ) {
        // context.read<NotificationState>().refreshData();
        await notificationState.refreshData();
      }

    }

  }

  void disposeProvider() {
    stopPolling();
  }

  Future<int> getConversationId(int uid1, int uid2) async {
    final user1Id = MathUtils.min(uid1, uid2);
    final user2Id = MathUtils.max(uid1, uid2);

    final rows = await SQLiteHelper().rawQuery('''
    SELECT id FROM conversation
    WHERE user1Id = ? AND user2Id = ?
    LIMIT 1;
  ''', [user1Id, user2Id]);

    if (rows.isNotEmpty) {
      return rows.first['id'] as int;
    }
    return 0;
  }

  Future<List<MessageModel>> getMessages({
    required int conversationId,
    required int peerUid,
    required int page,
    int pageSize = 20,
  }) async {
    if( conversationId == 0 ) {
      conversationId = await getConversationId(peerUid, CurrentUser.instance.uid);
    }
    if (conversationId == 0) return [];

    final offset = (page - 1) * pageSize;

    final rows = await SQLiteHelper().rawQuery('''
    SELECT * FROM message
    WHERE conversationId = ?
      AND deleted = 0
    ORDER BY createdTimestamp DESC
    LIMIT ? OFFSET ?;
  ''', [conversationId, pageSize, offset]);

    return rows.map((row) => MessageModel.fromMap(row)).toList();
  }

  // 取全部会话，暂无分页
  Future<List<ConversationModel>> getConversations(int page) async {
    int currentUid = CurrentUser.instance.uid;
    final List<Map<String, dynamic>> rows = await SQLiteHelper().rawQuery('''
    SELECT
      c.id AS conversationId,
      c.user1Id,
      c.user2Id,
      c.lastMessage,
      c.lastTimestamp,
      u.uid,
      u.username,
      u.screenName,
      u.profileImageUrl,
      (SELECT COUNT(*) 
        FROM message m 
        WHERE m.conversationId = c.id 
        AND m.isRead = 0 
        AND m.receiverUid = ? ) as unreadCount
    FROM conversation c
    JOIN user u
      ON u.uid = CASE
                   WHEN c.user1Id = ? THEN c.user2Id
                   ELSE c.user1Id
                 END
    WHERE c.user1Id = ? OR c.user2Id = ?
    ORDER BY c.lastTimestamp DESC;
  ''', [currentUid, currentUid, currentUid, currentUid]);

    return rows.map((row) {
      return ConversationModel(
        id: row['conversationId'] as int,
        user1Id: row['user1Id'] as int,
        user2Id: row['user2Id'] as int,
        lastMessage: row['lastMessage'] ?? '',
        lastTimestamp: row['lastTimestamp'] as int,
        unreadCountUser1: 0,
        unreadCountUser2: 0,
        lastTime: DateTime.fromMillisecondsSinceEpoch(row['lastTimestamp'] as int),
        unreadCount: row['unreadCount'] as int,
        user: UserModel(
          uid: row['uid'] as int,
          username: row['username'] ?? '',
          screenName: row['screenName'] ?? '',
          profileImageUrl: row['profileImageUrl'] ?? '',
        )
      );
    }).toList();
  }

// 发消息
  Future<void> sendMessage(int receiverUid, String content) async {

    FormData formData = new FormData.fromMap({
      "receiverUid" : receiverUid,
      "content" : content
    });
    var response = await DioWrapper().dio.post("/api/chat/send", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"] == 0) {

      await SQLiteHelper().insert('message', result['data']['message']);
      await SQLiteHelper().insert('conversation', result['data']['conversation']);
      await SQLiteHelper().insert('user', result['data']['user']);

      refreshData4Message(conversationId: result['data']['conversation']['id'] as int);
    }

  }

  // 设置消息已读
  Future<void> markConversationAsRead(int conversationId) async {

    await SQLiteHelper().update(
      'message',
      {'isRead': 1},
      'conversationId = ? AND isRead = 0',
      [conversationId],
    );

    _items = await getConversations(1);
    notifyListeners();

  }

}