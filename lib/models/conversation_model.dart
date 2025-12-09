
import 'package:com.xiaoyoushijie.app/models/user_model.dart';

class ConversationModel {
  final int id;
  final int user1Id;
  final int user2Id;
  final String lastMessage;
  final int lastTimestamp;
  final int unreadCountUser1;
  final int unreadCountUser2;
  final DateTime lastTime;
  final UserModel user;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.lastMessage,
    required this.lastTimestamp,
    required this.unreadCountUser1,
    required this.unreadCountUser2,
    required this.lastTime,
    required this.user,
    required this.unreadCount,
  });

  /// 从 JSON 构造
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      user1Id: json['user1Id'],
      user2Id: json['user2Id'],
      lastMessage: json['lastMessage'] ?? '',
      lastTimestamp: json['lastTimestamp'],
      unreadCountUser1: json['unreadCountUser1'],
      unreadCountUser2: json['unreadCountUser2'],
      lastTime: DateTime.fromMillisecondsSinceEpoch(json['lastTimestamp']),
      user: UserModel.fromJson(json['user']),
      unreadCount: json['unreadCount'],
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'lastMessage': lastMessage,
      'lastTimestamp': lastTimestamp,
      'unreadCountUser1': unreadCountUser1,
      'unreadCountUser2': unreadCountUser2,
    };
  }
}

