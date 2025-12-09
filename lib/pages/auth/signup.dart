
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/common/dio_wrapper.dart';
import 'package:com.xiaoyoushijie.app/common/widgets.dart';
import 'package:dio/dio.dart';
import '../../common/app_color.dart';
import '../../widgets/component/form_fields.dart';
import '../../widgets/dialog_widgets.dart';
import '../webview/privacy_policy.dart';
import '../webview/user_agreement.dart';

/**
 * 新用户注册
 */
class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Signup();
}

class _Signup extends State<Signup> {

  TextEditingController? _mobilephoneController, _passwordController, _nicknameController, _confirmController, _captchaController;

  bool checked = false;

  @override
  void initState() {
    _mobilephoneController = TextEditingController();
    _captchaController = TextEditingController();
    _passwordController = TextEditingController();
    _nicknameController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
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
            title: Text("注册新用户",style: TextStyle(color: Colors.black, fontSize: 20)),
            centerTitle: true
        ),
      body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height-90,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FormFields.entryFeild('手机号码', controller: _mobilephoneController!),
                      FormFields.captchaFeild('验证码', 'signup', controller: _captchaController!, mobilephoneController: _mobilephoneController),
                      FormFields.entryFeild('昵称', controller: _nicknameController!),
                      FormFields.entryFeild('密码', controller: _passwordController!, isPassword: true),
                      FormFields.entryFeild('确认密码', controller: _confirmController!, isPassword: true),
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
                      _signupButton(context),
                    ]
                )
            )
        )
    );
  }

  Widget _signupButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () => _post(context),
        child: Text('提交注册', style: TextStyle(
          color: Colors.white,
        )),
      ),
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

    if( _captchaController!.text.isEmpty ) {
      Cw.showSnackBarV2(context, "请输入验证码");
      return;
    }

    if(_nicknameController!.text.isEmpty) {
      Cw.showSnackBarV2(context, "请输入昵称");
      return;
    }

    if(_passwordController!.text.isEmpty) {
      Cw.showSnackBarV2(context, "请输入密码");
      return;
    }

    if(_passwordController!.text != _confirmController!.text) {
      Cw.showSnackBarV2(context, "两次输入的密码不一致");
      return;
    }

    FormData formData = new FormData.fromMap({
      "mobilephone": _mobilephoneController!.text,
      "captcha": _captchaController!.text,
      "screenName": _nicknameController!.text,
      "password": _passwordController!.text,
    });

    var response = await DioWrapper().dio.post("/api/user/signup", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"]==0) {
      await DialogAlert(context, "注册成功！");
      Navigator.pushNamed(context, "/signin");
    } else {
      Cw.showSnackBarV2(context, result["msg"]);
    }
  }

}