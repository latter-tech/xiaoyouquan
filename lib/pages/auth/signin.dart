
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/common/widgets.dart';
import 'package:dio/dio.dart';
import '../../common/app_color.dart';
import '../../common/current_user.dart';
import '../../common/dio_wrapper.dart';
import '../../models/user_model.dart';
import '../../states/user_state.dart';
import '../../widgets/component/form_fields.dart';
import '../webview/privacy_policy.dart';
import '../webview/user_agreement.dart';

/**
 * 用户登录
 */
class Signin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Signin();
}

class _Signin extends State<Signin> {

  TextEditingController? _mobilephoneController, _passwordController;
  bool checked = false;

  @override
  void initState() {
    super.initState();
    _mobilephoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _mobilephoneController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: LatterColor.primary),
          backgroundColor: Colors.white,
          title: Text("登录",style: TextStyle(color: Colors.black, fontSize: 20)),
          centerTitle: true
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 100),
                    FormFields.entryFeild('手机号码', controller: _mobilephoneController),
                    FormFields.entryFeild('密码', controller: _passwordController, isPassword: true),
                    Row(children: [
                      Checkbox(
                        value: checked,
                        onChanged: (bool? value) {
                          checked = value!;
                          setState(() {});
                        },
                        activeColor: Colors.black38,
                        side: BorderSide(color: Colors.black38)
                      ),
                      Text("我已阅读并同意"),
                      TextButton(
                        onPressed: () => {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => UserAgreement(),
                            ),
                          )
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          "用户协议",
                          style: TextStyle(color: LatterColor.primary),
                        ),
                      ),
                      Text("和"),
                      TextButton(
                        onPressed: () => {
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => PrivacyPolicy(),
                              ),
                            )
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          "隐私政策",
                          style: TextStyle(color: LatterColor.primary),
                        ),
                      ),
                    ]),
                    _loginButton(context),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, "/forget"),
                      child: Text(
                        "忘记密码？",
                        style: TextStyle(
                            color: LatterColor.primary, fontWeight: FontWeight.bold),
                      ),
                    )
                  ]
              )
          )
      )

    );

  }

  Widget _loginButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () => _post(context),
        child: Text('登录', style: TextStyle(
            color: Colors.white,
        )),
      )
    );
  }

  Future<void> _post(BuildContext context) async {

    if( !checked ) {
      Cw.showSnackBarV2(context, "请勾选 [我已阅读并同意用户协议和隐私政策]");
      return;
    }

    if(_mobilephoneController!.text.isEmpty) {
      Cw.showSnackBarV2(context, "请输入手机号码");
      return;
    }

    if(_passwordController!.text.isEmpty) {
      Cw.showSnackBarV2(context, "请输入密码");
      return;
    }

    FormData formData = new FormData.fromMap({
      "mobilephone": _mobilephoneController!.text,
      "password": _passwordController!.text,
    });

    var response = await DioWrapper().dio.post("/api/user/signin", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"]==0) {

      // 保存到UserState
      UserModel? user = UserModel.fromJson(result["data"]["user"]);
      CurrentUser.instance.setUser(user);

      // 保存Token & uid 到本地
      await UserState.remember(result["data"]["access_token"], user!.uid!);
      Navigator.pushNamed(context, "/home");

    } else {
      Cw.showSnackBarV2(context, result["msg"]);
    }
  }

}
