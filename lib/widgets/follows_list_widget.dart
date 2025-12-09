
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/widgets/ripple_button.dart';
import 'package:provider/provider.dart';
import '../common/app_color.dart';
import '../common/utils.dart';
import '../common/widgets.dart';
import '../models/user_model.dart';
import '../pages/profile.dart';
import '../states/user_state.dart';
import 'Keep_alive_wrapper.dart';

/**
 * 关注/粉丝 列表封装
 */
class FollowsListWidget extends StatefulWidget {
  const FollowsListWidget({
    Key? key,
    required this.uid,
    required String this.type,
    required int this.page
  }) : super(key: key);

  final int uid;
  final String type;
  final int page;

  @override
  State<StatefulWidget> createState() => _FollowsListWidget();
}

class _FollowsListWidget extends State<FollowsListWidget> {

  late EasyRefreshController _easyRefreshController;
  late int _nowPage;
  late List<UserModel> _listFollows;
  late UserState userState;

  @override
  void initState() {

    super.initState();
    _easyRefreshController = EasyRefreshController(
        controlFinishRefresh: true,
        controlFinishLoad: true
    );
    userState = Provider.of<UserState>(context, listen: false);
    _nowPage = widget.page;
    _listFollows = [];
    _onReFresh();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  void _onReFresh() async {
    _nowPage = 1;
    List<UserModel> listFollows = await userState.listFollows(widget.uid, widget.type, _nowPage) ?? [];
    this.setState(() {
      if( _nowPage == 1 ) {
        _listFollows = listFollows;
      } else {
        _listFollows += listFollows;
      }
    });
    int size = listFollows.length;
    _easyRefreshController.finishRefresh();
    _easyRefreshController.resetFooter();
    if( size < 10 ) {
      _easyRefreshController.finishLoad( IndicatorResult.noMore );
    }
  }

  void _onLoad() async {
    await Future.delayed(const Duration(seconds: 1));
    _nowPage ++;
    List<UserModel> listFollows = await userState.listFollows(widget.uid, widget.type, _nowPage) ?? [];
    this.setState(() {
      if( _nowPage == 1 ) {
        _listFollows = listFollows;
      } else {
        _listFollows = listFollows;
      }
    });
    int size = listFollows.length;
    _easyRefreshController.finishLoad( size < 10 ? IndicatorResult.noMore : IndicatorResult.success );
  }

  void remove(int index) {
    setState(() {
      _listFollows.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveWrapper(
        child: SafeArea(
            child: EasyRefresh(
              controller: _easyRefreshController,
              header: const ClassicHeader(),
              footer: const ClassicFooter(),
              onRefresh: () async {
                if (!mounted) {
                  return;
                }
                _onReFresh();
              },
              onLoad: () async {
                if (!mounted) {
                  return;
                }
                _onLoad();
              },
              child: ListView.builder(
                padding: EdgeInsets.only(top:5.0),
                itemBuilder: (context, index) {
                  return followsItem(_listFollows[index]);
                },
                itemCount: _listFollows.length,
              ),
            )
        )
    );
  }

  Widget followsItem(UserModel user) {
    return Consumer<UserState>(
            builder: (ctx, state, child) {
              bool isFollowing = Utils.isFollowing( user!.uid! );
              print(isFollowing);
              return Column(
                  children: [
                    ListTile(
                      leading:Container(
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => Profile(profileUid: user!.uid!),
                              ),
                            );
                          },
                          child: Cw.customImage(context, user!.profileImageUrl),
                        ),
                      ),
                      title: Text(user!.screenName!),
                      subtitle: Text("@" + ( user!.username ?? "") ),
                      trailing: RippleButton(
                          onPressed: () async {
                            if( isFollowing ) {
                              await userState.follow(user!.uid!, "unfollow");
                            } else {
                              await userState.follow(user!.uid!, "follow");
                            }
                          },
                          splashColor: LatterColor.primary.withAlpha(100),
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isFollowing ? 15 : 20,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isFollowing
                                  ? LatterColor.primary
                                  : LatterColor.white,
                              border:
                              Border.all(color: LatterColor.primary, width: 1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              isFollowing ? '关注中' : '关注',
                              style: TextStyle(
                                color: isFollowing ? LatterColor.white : LatterColor.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left:20),
                        child: Text("没有简介")
                    )
                  ]
              );
            }
    );
  }

}