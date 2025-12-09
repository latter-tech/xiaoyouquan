
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/common/utils/app_upgrade.dart';
import 'package:com.xiaoyoushijie.app/pages/search.dart';
import 'package:provider/provider.dart';
import '../states/message_state.dart';
import 'package:com.xiaoyoushijie.app/pages/conversations_page.dart';
import '../common/app_icons.dart';
import '../states/notification_state.dart';
import '../widgets/drawer_menu.dart';
import 'feed_page.dart';
import 'notifications.dart';
import 'package:badges/badges.dart' as badges;

/**
 * 主界面
 */
class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _tabController = new TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() { });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Provider.of<MessageState>(context, listen: false).startPolling(context);
      final messageState = context.read<MessageState>();
      final notificationState = context.read<NotificationState>();
      messageState.startPolling(notificationState);
    });

    Future.delayed(Duration(seconds: 5), () {
      AppUpgrade().check(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Provider.of<MessageState>(context, listen: false).stopPolling();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final provider = Provider.of<MessageState>(context, listen: false);
    if (state == AppLifecycleState.resumed) {
      final notificationState = context.read<NotificationState>();
      provider.startPolling(notificationState);
    } else if (state == AppLifecycleState.paused) {
      provider.stopPolling();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              FeedPage(),
              SearchPage(),
              ConversationsPage(),
              NotificationsPage()
            ],
          )
      ),
      bottomNavigationBar: Container(
          height: 50,
          child: TabBar(
              indicator: const BoxDecoration( color: Colors.transparent),// 不显示下划线
              //splashBorderRadius: BorderRadius.circular(1.0),
              controller: _tabController,
              tabs:[
                Tab(
                  icon: _tabController.index == 0 ? Icon(LatterIcon.homeFill) : Icon(LatterIcon.home),
                ),
                Tab(
                  icon: _tabController.index == 1 ? Icon(LatterIcon.searchFill) : Icon(LatterIcon.search),
                ),
                Tab(
                  icon: Consumer<MessageState>(
                    builder: (context, state, _) {
                      return badges.Badge(
                        showBadge: state.totalUnreadConversationsCount > 0,
                        position: badges.BadgePosition.topEnd(top: -8, end: -8),
                        badgeStyle: const badges.BadgeStyle(
                          padding: EdgeInsets.all(6),
                          badgeColor: Colors.red,
                        ),
                        badgeContent: Text(
                          state.totalUnreadConversationsCount > 9
                              ? '9+'
                              : '${state.totalUnreadConversationsCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        child: Icon(
                          _tabController.index == 2
                              ? LatterIcon.messageFill
                              : LatterIcon.message,
                        ),
                      );
                    },
                  ),
                ),
                Tab(
                  icon: Consumer<NotificationState>(
                    builder: (context, state, _) {
                      return badges.Badge(
                        showBadge: state.totalUnreadNotificationsCount > 0,
                        position: badges.BadgePosition.topEnd(top: -8, end: -8),
                        badgeStyle: const badges.BadgeStyle(
                          padding: EdgeInsets.all(6),
                          badgeColor: Colors.red,
                        ),
                        badgeContent: Text(
                          state.totalUnreadNotificationsCount > 9
                              ? '9+'
                              : '${state.totalUnreadNotificationsCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        child: Icon(
                            _tabController.index == 3
                                ? LatterIcon.notificationFill
                                : LatterIcon.notification
                        ),
                      );
                    },
                  ),
                )
              ]
          )
      ),
    );
  }

}