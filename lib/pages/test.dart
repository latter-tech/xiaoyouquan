// 请实现一个hello,world的flutter页面
import 'package:flutter/material.dart';

// 添加一个main方法 作为程序入口
void main() {
  runApp(TestPage());
}

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World Page'),
      ),
      body: Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
