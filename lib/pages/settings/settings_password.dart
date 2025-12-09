
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../common/app_color.dart';
import '../../common/current_user.dart';
import '../../common/dio_wrapper.dart';
import '../../common/widgets.dart';
import '../../generated/l10n.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/settings_appbar.dart';

/**
 * 修改密码
 */
class SettingsPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPassword();
}

class _SettingsPassword extends State<SettingsPassword> {

  late TextEditingController _oldPasswordController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _oldPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:SettingsAppBar(
        title: S.of(context).update_password,
        subtitle: "@${CurrentUser.instance.user!.username!}",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _entry(S.of(context).current_password, controller: _oldPasswordController),
            _entry(S.of(context).new_password, controller: _passwordController),
            _entry(S.of(context).confirm_password, controller: _confirmPasswordController),
            Center(child: ElevatedButton(
              child: Text(S.of(context).update_password, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14),
              ),
              onPressed: () async{
                FormData formData = new FormData.fromMap({
                  "oldPassword": _oldPasswordController.text,
                  "password" : _passwordController.text
                });

                var response = await DioWrapper().dio.post("/api/user/update_password", data: formData);
                Map<String, dynamic> result = response.data;
                if(result["code"] == 0) {
                  Cw.showSnackBarV2(context, result["msg"]);
                } else {
                  Cw.showSnackBarV2(context, result["msg"]);
                }
              },
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  backgroundColor: WidgetStateProperty.all(LatterColor.primary)
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _entry(String title, {
    required TextEditingController controller,
    String? hitText
    } ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: const TextStyle(color: Colors.black54)),
          TextField(
            enabled: true,
            controller: controller,
            obscureText: true,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hitText,
              hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              )
            ),
          )
        ],
      ),
    );
  }

}