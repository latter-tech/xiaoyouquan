
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/pages/auth/reset_password.dart';
import 'package:provider/provider.dart';
import '../../common/app_color.dart';
import '../../common/widgets.dart';
import '../../states/user_state.dart';
import '../../widgets/component/form_fields.dart';

/**
 * 忘记密码
 */
class ForgetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Forget();
}

class _Forget extends State<ForgetPassword> {

  TextEditingController? _mobilephoneController, _captchaController;

  @override
  void initState() {
    _mobilephoneController = TextEditingController();
    _captchaController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: LatterColor.primary),
            backgroundColor: Colors.white,
            title: Text("忘记密码",style: TextStyle(color: Colors.black, fontSize: 20)),
            centerTitle: true
        ),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("忘记密码", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:Text("输入你的登录手机号码并发送验证码，以便更改你的密码。",
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black54),
                            textAlign: TextAlign.center
                        )
                      ),
                      FormFields.entryFeild('手机号码', controller: _mobilephoneController!),
                      FormFields.captchaFeild('手机验证码', 'forget', controller: _captchaController!, mobilephoneController: _mobilephoneController),
                      _submitButton(context),
                    ]
                )
            )
        )
    );

  }

  Future<void> _submit() async {

    String mobilephone = _mobilephoneController!.text;
    String captcha = _captchaController!.text;

    if( mobilephone == "" ) {
      Cw.showSnackBarV2(context, "请输入手机号码");
      return;
    }

    if( captcha == "" ) {
      Cw.showSnackBarV2(context, "请输入验证码");
      return;
    }

    var userState = Provider.of<UserState>(context, listen: false);

    String msg = await userState.verifyCaptcha(mobilephone, captcha);

    if( msg == "OK" ) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ResetPassword(
            mobilephone: mobilephone,
            captcha: captcha,
          )));
    } else {
      Cw.showSnackBarV2(context, "验证码错误");
    }

  }

  Widget _submitButton(BuildContext context){
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: _submit,
          child: Text('下一步',style:TextStyle(color: Colors.white)),
        )
    );
  }

}