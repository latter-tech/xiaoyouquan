import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../pages/webview/privacy_policy.dart';
import '../../pages/webview/user_agreement.dart';

class PrivacyDialog {
  static Future<void> show(BuildContext context) async {

    SharedPreferences? sp = await SharedPreferences.getInstance();
    int? privacyDialogOk = sp!.getInt("privacyDialogOk");
    if( privacyDialogOk == 1 ) {
      return;
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 40),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '个人信息保护提示',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                    children: [
                      TextSpan(text: '我们将通过'),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => UserAgreement()),
                            );
                          },
                          child: Text(
                            '《用户协议》',
                            style: TextStyle(
                              color: Color(0xFF46a1e8),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(text: '和'),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => PrivacyPolicy()),
                            );
                          },
                          child: Text(
                            '《隐私政策》',
                            style: TextStyle(
                              color: Color(0xFF46a1e8),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text:
                        '，帮助您了解我们为您提供的服务、我们如何处理个人信息以及您享有的权利。我们会严格按照相关法律法规要求，采取各种安全措施来保护您的个人信息。',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        exit(0); // 退出APP
                      },
                      child: Text(
                        '不同意',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        sp!.setInt("privacyDialogOk",1);
                        Navigator.of(context).pop(); // 关闭对话框
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF80819),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('同意')
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
