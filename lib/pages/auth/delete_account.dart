import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/app_color.dart';
import '../../common/current_user.dart';
import '../../common/widgets.dart';
import '../../generated/l10n.dart';
import '../../states/user_state.dart';
import '../../widgets/settings_appbar.dart';

class DeleteAccountPage extends StatelessWidget {

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LatterColor.white,
      appBar: SettingsAppBar(
        title: S.of(context).deactivate_your_account,
        subtitle: "@${CurrentUser.instance.user!.username!}",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.of(context).deactivate_warning,
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => _showConfirmationDialog(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: Text(S.of(context).deactivate_confirm),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).deactivate_confirm, style: TextStyle(color: Colors.black87)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).deactivate_cannot_be_undone,
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.of(context).enter_your_password,
                  labelStyle: TextStyle(
                    color: Colors.grey[500], // 使用淡灰色
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 关闭对话框
              },
              child: Text(S.of(context).cancel, style: TextStyle(color: Color(0xFF46a1e8))),
            ),
            ElevatedButton(
              onPressed: () async {
                //Navigator.pop(context); // 关闭对话框
                await _deleteAccount(context); // 执行注销逻辑
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: Text(S.of(context).confirm),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    String msg = await Provider.of<UserState>(context, listen: false).deleteAccount(passwordController.text!);
    if( msg == "OK" ) {
      SharedPreferences? _prefs = await SharedPreferences.getInstance();
      _prefs.remove('accessToken');
      CurrentUser.instance.clear();
      Cw.showSnackBarV2(context, "账号已成功注销。");
      // 返回到登录页面或退出应用
      Navigator.of(context).pushNamedAndRemoveUntil('/signin', (Route<dynamic> route) => false);
    } else {
      Cw.showSnackBarV2(context, msg);
    }
  }

}