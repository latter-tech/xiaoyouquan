
import '../common/current_user.dart';
import '../common/utils/sqlite_helper.dart';
import '../models/notification_model.dart';
import 'app_state.dart';

/**
 * 通知
 */
class NotificationState extends AppState {

  final _pageSize = 20;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<NotificationModel> _items = [];
  List<NotificationModel> get items => _items;
  int _page = 1;

  // 下拉刷新 会话
  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();
    _page = 1;
    _items = await getNotifications(_page);
    _isLoading = false;
    notifyListeners();
  }

  // 上拉加载更多  会话
  Future<void> loadMoreData() async {
    _isLoading = true;
    notifyListeners();
    _items.addAll(await getNotifications(_page++));
    _isLoading = false;
    notifyListeners();
  }

  Future<List<NotificationModel>> getNotifications(int page) async {
    final db = await SQLiteHelper().database;

    int offset = (page - 1) * _pageSize;
    final result = await db.query(
      'notification',
      where: 'sourceUid = ?',
      whereArgs: [CurrentUser.instance.uid],
      orderBy: 'id DESC',
      limit: _pageSize,
      offset: offset,
    );

    return result.map((map) => NotificationModel.fromMap(map)).toList();
  }

  // 未读通知 计数
  int get totalUnreadNotificationsCount =>
      _items.where((c) => c.isRead == 0).length;

  // 设置全部通知为已读
  Future<void> markAllNotificationsAsRead() async {

    await Future.delayed(const Duration(seconds: 3));

    final db = await SQLiteHelper().database;
    await db.update(
      'notification',
      {'isRead': 1},
      where: 'sourceUid = ? AND isRead = 0',
      whereArgs: [CurrentUser.instance.uid]
    );

    refreshData();

  }

}