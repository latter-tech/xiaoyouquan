
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../common/widgets.dart';
import '../states/user_state.dart';
import 'block_puzzle_captcha.dart';
import 'dialog_widgets.dart';

/**
 * 倒计时按钮
 */
class CountdownButton extends StatefulWidget {
  const CountdownButton({
    Key? key,
    required this.controller,
    required this.type
  }) : super(key: key);

  final TextEditingController? controller;
  final String type;

  @override
  _CountdownButtonState createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<CountdownButton> {
  int _remainingTime = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _cancelTimer() {
    if( _timer != null ) {
      _timer!.cancel();
    }
  }

  void _startCountDown(String _mobilephone, String _captchaVerification) async {
    UserState state = Provider.of<UserState>(context, listen: false);
    String msg = await state.sendCaptcha(context, widget.type, _mobilephone, _captchaVerification);
    if( msg != "OK" ) {
      Cw.showSnackBarV2(context, msg);
      return;
    }
    Cw.showSnackBarV2(context, "验证码已发送，请查收");

    _remainingTime = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _cancelTimer();
        // Perform action after countdown finishes (optional)
      }
    });
  }

  Future<void> _onPressed() async
  {
    String _mobilephone = widget.controller!.text.trim();
    if(_mobilephone.isEmpty) {
      DialogAlert(context, "请填写手机号码");
      return;
    }

    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BlockPuzzleCaptchaPage(
          onSuccess: (v) {
            _startCountDown(_mobilephone, v);
            print("success");
            print(v.toString());
          },
          onFail: (){
            print("fail");
          },
        );
      },
    );



  }

  /**
   * 当 onPressed 为 null 的时候，button 背景色会自动变成灰色 ？？
   */
  @override
  Widget build(BuildContext context) {
    String buttonText = _remainingTime > 0 ? "$_remainingTime s" : "获取验证码";
    return SizedBox(
        width: 120,
        child: ElevatedButton(
          onPressed: _remainingTime > 0 ? null : _onPressed,
          child: Text(buttonText, style: TextStyle(
            color: Colors.white,
          )),
      ));
  }
}