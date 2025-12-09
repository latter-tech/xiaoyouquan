
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/pages/auth/signin.dart';
import 'package:provider/provider.dart';
import '../../common/widgets.dart';
import '../../states/user_state.dart';
import '../../widgets/component/form_fields.dart';

/**
 * 重置密码
 */
class ResetPassword extends StatefulWidget {
  const ResetPassword({
    Key? key,
    required this.mobilephone,
    required this.captcha
  }) : super(key: key);

  final String mobilephone;
  final String captcha;

  @override
  State<StatefulWidget> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {

  TextEditingController? _passwordController, _confirmController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
  }

  Future<void> _submit() async {
    String password = _passwordController!.text;
    String confirmPassword = _confirmController!.text;

    if( password == "" ) {
      Cw.showSnackBarV2(context, "请输入新密码");
      return;
    }

    if( password != confirmPassword ) {
      Cw.showSnackBarV2(context, "两次输入的密码不一致");
      return;
    }

    var userState = Provider.of<UserState>(context, listen: false);

    String msg = await userState.resetPassword(widget.mobilephone, widget.captcha, password);

    if( msg == "OK" ) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Signin() ));
    } else {
      Cw.showSnackBarV2(context, msg);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.blue),
            backgroundColor: Colors.white,
            title: Text("重置密码",style: TextStyle(color: Colors.black, fontSize: 20)),
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
                      Text("重置密码", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child:Text("密码长度为6-16个字符，必须同时包含字母和数字",
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w100,color: Colors.black54),
                              textAlign: TextAlign.center
                          )
                      ),
                      FormFields.entryFeild('新密码', controller: _passwordController!, isPassword: true),
                      FormFields.entryFeild('确认新密码', controller: _confirmController!, isPassword: true),
                      FormFields.submitButton(context, '重置密码', _submit),
                    ]
                )
            )
        )

    );
  }

}