import 'package:flutter/material.dart';
import '../common/app_color.dart';
import '../widgets/component/privacy_dialog.dart';
import '../widgets/title_text.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PrivacyDialog.show(context);
    });
  }

  Widget _signupButton(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 35),
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, "/signup"),
          child: Text('创建账号', style: TextStyle(
            color: Colors.white,
          )),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                height: 40,
                child: Image.asset('assets/images/logo_64x64.png'),
              ),
              const Spacer(),
              const TitleText(
                '啦特，用英文记录美好时光',
                fontSize: 25,
              ),
              const SizedBox(
                height: 20,
              ),
              _signupButton(context),
              const Spacer(),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  const TitleText(
                    '已有账号？ ',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/signin");
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                      child: TitleText(
                        '登录',
                        fontSize: 14,
                        color: LatterColor.primary,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      )
    );
  }
}