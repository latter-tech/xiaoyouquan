
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:com.xiaoyoushijie.app/pages/welcome.dart';
import '../common/app_color.dart';
import '../generated/l10n.dart';
import '../states/user_state.dart';
import 'home.dart';

// 启动页
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      var state = Provider.of<UserState>(context, listen:false);
      state.getCurrentUser(_callback);
    });
  }

  void _callback(bool isSignined, String? _locale) {
    if( isSignined == true ) {
      if( _locale != null && _locale != "" ) {
        var arrLocale = _locale.split("_");
        S.load(Locale(arrLocale[0], arrLocale[1]));
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Welcome()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LatterColor.primary,
      body: Center(
        child: Image.asset('assets/images/logo_64x64_fff.png'),
      ),
    );
  }

}