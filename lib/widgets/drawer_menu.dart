
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:com.xiaoyoushijie.app/pages/webview/privacy_policy.dart';
import 'package:com.xiaoyoushijie.app/pages/webview/user_agreement.dart';
import '../common/app_color.dart';
import '../common/app_icons.dart';
import '../common/current_user.dart';
import '../generated/l10n.dart';
import '../pages/about.dart';
import '../pages/follows_page.dart';
import '../pages/profile.dart';
import '../pages/settings.dart';
import '../states/user_state.dart';
import '/common/widgets.dart';
import '/widgets/custom_widgets.dart';

/**
 * 抽屉菜单
 */
class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;

  _DrawerMenu createState() => _DrawerMenu();
}

class _DrawerMenu extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {

    var userState = Provider.of<UserState>(context, listen: false);

    return Drawer(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: _menuHeader(context, userState),
                  ),
                  Divider(height:30.0, thickness:0.8, indent:20, endIndent:20),
                  _menuListRowButton(S.of(context).profile,
                      icon: Icons.person, isEnable: true, onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Profile(profileUid: CurrentUser.instance.user!.uid!),
                          ),
                        );
                      }),
                  _menuListRowButton(S.of(context).settings,
                      icon: Icons.settings, isEnable: true, onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => Settings(),
                          ),
                        );
                      }),
                  Divider(height:30.0, thickness:0.8, indent:20, endIndent:20),
                  _menuListRowButton(S.of(context).user_agreement, icon: LatterIcon.agreement, onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => UserAgreement(),
                      ),
                    );
                  }, isEnable: true),
                  _menuListRowButton(S.of(context).privacy_policy, icon: LatterIcon.privacy, onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicy(),
                      ),
                    );
                  }, isEnable: true),
                  _menuListRowButton(S.of(context).about,
                      icon: LatterIcon.about,
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => About(),
                          ),
                        );
                      }, isEnable: true)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _menuHeader(BuildContext context, UserState userState) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 56,
            width: 56,
            margin: EdgeInsets.only(left: 20, top: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(28),
              image: DecorationImage(
                image: Cw.customAdvanceNetworkImage(
                    CurrentUser.instance.user!.profileImageUrl
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Cw.customText(
                CurrentUser.instance.user!.screenName!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              )
            )
          ),
          Container(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                  child: Cw.customText(
                    '@' + CurrentUser.instance.user!.username!,
                    style: TextStyle(fontSize: 15),
                  )
              )
          ),
          Container(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    children: <Widget>[
                      _tappbleText(context, '${CurrentUser.instance.user!.fansCount}', S.of(context).followers, 'followers'),
                      SizedBox(width: 10),
                      _tappbleText(context, '${CurrentUser.instance.user!.followsCount}', S.of(context).following, 'following'),
                    ],
                  )
              )
          )
        ],
      ),
    );
  }

  Widget _tappbleText(
        BuildContext context,
        String count,
        String text,
        String type) {
        return InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => FollowsPage(type: type, uid: CurrentUser.instance.user!.uid!, screenName: CurrentUser.instance.user!.screenName!),
              ),
            );
          },
          child: Row(
            children: <Widget>[
              Cw.customText(
                '$count ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: LatterColor.primary),
              ),
              Cw.customText(
                '$text',
                style: TextStyle(color: LatterColor.textOnLight, fontSize: 16),
              ),
            ],
          ),
        );
  }

  ListTile _menuListRowButton(String title, {Function? onPressed, IconData? icon, bool isEnable = false}) {
    return ListTile(
      dense: true, // dense 稠密的
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      leading: icon == null
          ? null
          : Padding(
        padding: EdgeInsets.only(top: 12),
        child: customIcon(
          context,
          icon: icon,
          size: 22,
          iconColor: isEnable ? LatterColor.textOnLight : LatterColor.textOnLight,
        ),
      ),
      title: Cw.customText(
        title,
        style: TextStyle(
          fontSize: 15,
          color: isEnable ? LatterColor.textOnLight : LatterColor.textOnLight,
        ),
      ),
    );
  }

}