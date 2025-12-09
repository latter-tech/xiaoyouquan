
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/pages/settings/settings_locale.dart';
import 'package:com.xiaoyoushijie.app/pages/settings/settings_account.dart';
import 'package:com.xiaoyoushijie.app/pages/settings/settings_password.dart';
import '../common/app_color.dart';
import '../common/current_user.dart';
import '../common/widgets.dart';
import '../generated/l10n.dart';
import '../states/user_state.dart';
import '../widgets/dialog_widgets.dart';
import '../widgets/settings_appbar.dart';

/**
 * 设置
 */
class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: LatterColor.white,
      appBar: SettingsAppBar(
        title: S.of(context).settings,
        subtitle: "@${CurrentUser.instance.user!.username!}",
      ),
      body: ListView(
        children: <Widget>[
          _listTile(S.of(context).your_account, S.of(context).see_information_about_your_account, Icons.account_circle_outlined, true, () {
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => SettingsAccount(),
              ),
            );
          }),
          _listTile(S.of(context).update_password, S.of(context).update_password, Icons.password, true, () {
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => SettingsPassword(),
              ),
            );
          }),
          _listTile(S.of(context).select_language, S.of(context).chinese_and_english_only, Icons.language, true, () {
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => SettingsLocale(),
              ),
            );
          }),
          _listTile(S.of(context).log_out, S.of(context).log_out, Icons.logout, false, () async {
            bool result = await DialogConfirm(context, "确定退出？");
            if( result ) {
              UserState.logout(context);
            }
          }),
        ],
      ),
    );

  }

  Widget _listTile(String title, String subtitle, IconData icon, bool isTrailing, Function? onTap) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 18),
        onTap: () {
          if( onTap != null ) {
            onTap();
          }
        },
        leading: Icon(icon),
        title: title == null
            ? null
            : Cw.customText(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: LatterColor.textOnLight,
                ),
              ),
        subtitle: subtitle == null
            ? null
            : Cw.customText(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: LatterColor.textOnLight,
              ),
            ),
        trailing: isTrailing ? Icon(Icons.keyboard_arrow_right) : null
    );
  }

}