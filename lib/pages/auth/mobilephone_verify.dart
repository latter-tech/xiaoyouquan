
import 'package:flutter/material.dart';
import '../../common/app_color.dart';
import '../../widgets/component/form_fields.dart';

/**
 * 手机号验证
 */
class MobilephoneVerify extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MobilephoneVerify();
}

class _MobilephoneVerify extends State<MobilephoneVerify> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController? _emailController, _captchaController;

  @override
  void initState() {
    _emailController = TextEditingController();
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
                          child:Text("输入你的登录邮件地址并发送验证码，以便更改你的密码。",
                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black54),
                              textAlign: TextAlign.center
                          )
                      ),
                      FormFields.entryFeild('邮箱', controller: _emailController!),
                      FormFields.captchaFeild('邮箱验证码', 'forget', controller: _captchaController!, mobilephoneController: _emailController),
                      _submitButton(context),
                    ]
                )
            )
        )
    );

  }

  void _submit(){
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (context) => ResetPassword(
    //       email: _emailController!.text,
    //       captcha: _captchaController!.text,
    //     )));
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