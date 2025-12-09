
import 'package:flutter/material.dart';
import '../widgets/follows_list_widget.dart';

/**
 * 关注 和 粉丝列表
 * following 正在关注
 * followers 关注者
 */
class FollowsPage extends StatefulWidget {
  FollowsPage({
    Key? key,
    required this.uid,
    required this.type,
    required this.screenName
  }) : super(key: key);

  final int uid;
  final String type;
  final String screenName;

  _FollowsPage createState() => _FollowsPage();
}

class _FollowsPage extends State<FollowsPage> with SingleTickerProviderStateMixin  {

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.type == 'following' ? 1 : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
            alignment: Alignment.center,
            child: Text(widget.screenName),
          )
      ),
      body: Column(
        children: [
          Container(
            height: 50.0,
            child: TabBar(
              indicator: null,
              controller: _tabController,
              tabs: [
                // 粉丝
                Tab(text: "关注者", iconMargin: EdgeInsets.only(bottom: 0.0)),
                // 关注
                Tab(text: "正在关注",),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FollowsListWidget(uid: widget.uid, type: "followers", page: 1),
                FollowsListWidget(uid: widget.uid, type: "following", page: 1),
              ],
            ),
          )
        ],
      )
    );
  }

}