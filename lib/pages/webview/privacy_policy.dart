import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/**
 * 隐私政策
 */
class PrivacyPolicy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(Uri.parse("https://latter.cn/policy/privacy_policy.html"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('隐私政策'),
      ),
      body: SafeArea(
        child: Container(
            child: WebViewWidget(controller: controller)
        ),
      ),
    );
  }

}