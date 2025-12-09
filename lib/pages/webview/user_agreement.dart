
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/**
 * 用户协议
 */
class UserAgreement extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserAgreementState();
}

class _UserAgreementState extends State<UserAgreement> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(Uri.parse("https://latter.cn/policy/user_agreement.html"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户协议'),
      ),
      body: SafeArea(
        child: Container(
            child: WebViewWidget(controller: controller)
        ),
      ),
    );
  }

}