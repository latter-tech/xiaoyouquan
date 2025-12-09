
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:com.xiaoyoushijie.app/pages/settings/change_username.dart';
import '../../common/app_color.dart';
import '../../common/current_user.dart';
import '../../common/widgets.dart';
import '../../generated/l10n.dart';
import '../../widgets/settings_appbar.dart';
import '../auth/delete_account.dart';

/**
 * 账户设置
 */
class SettingsAccount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsAccount();
}

class _SettingsAccount extends State<SettingsAccount> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: LatterColor.white,
      appBar: SettingsAppBar(
        title: S.of(context).your_account,
        subtitle: "@${CurrentUser.instance.user!.username!}",
      ),
      body: ListView(
        children: <Widget>[
          _listTile(S.of(context).username, CurrentUser.instance.user!.username!, true, () {
            Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => ChangeUsernamePage()
              ),
            );
          }),
          _listTile(S.of(context).cell_phone_number, CurrentUser.instance.user!.mobilephone!, false, (){}),
          _listTile(S.of(context).signup_date, DateFormat("yyyy/MM/dd").format(CurrentUser.instance.user!.createdAt!), false, (){}),
          _listTile(S.of(context).deactivate_your_account, S.of(context).deactivate_your_account, true, () {
            Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => DeleteAccountPage()
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _userName() {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 18),
        onTap: () {
          Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => ChangeUsernamePage()
            ),
          );
        },
        title: Cw.customText(
          S.of(context).username,
          style: TextStyle(
            fontSize: 16,
            color: LatterColor.textOnLight,
          ),
        ),
        subtitle: Cw.customText(
          '@${CurrentUser.instance.user!.username!}',
          style: TextStyle(
            fontSize: 14,
            color: LatterColor.textOnLight,
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right)

    );
  }

  Widget _listTile(String title, String subtitle, bool isTrailing, Function? onTap) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 18),
        onTap: () {
          if( onTap != null ) {
            onTap();
          }
        },
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
            color: LatterColor.textHint,
          ),
        ),
        trailing: isTrailing ? Icon(Icons.keyboard_arrow_right) : null
    );
  }

}