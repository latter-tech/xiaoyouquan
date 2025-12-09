import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/feed_state.dart';

/// 显示投诉对话框
///
/// [context]: 构建上下文
/// [options]: 投诉选项映射，显示文本为键，返回值为值
///           默认为 {'非法内容': 'ILLEGAL', '攻击谩骂': 'ATTACK',
///                 '虚假信息': 'FAKE', '政治内容':'POLITICS'}
/// [title]: 对话框标题，默认为 '请选择投诉原因'
/// [submitText]: 提交按钮文字，默认为 '提交'
/// [cancelText]: 取消按钮文字，默认为 '取消'
///
/// 返回: Future<String?> 用户选择的投诉类型代码，如果取消则为null
Future<String?> showComplaintDialog({
  required BuildContext context,
  required int blogId,
  required int blogUid,
}) async {
  String? selectedValue;

  final Map<String, String> options = const {
    '非法内容': 'ILLEGAL',
    '攻击谩骂': 'ATTACK',
    '虚假信息': 'FAKE',
    '政治内容': 'POLITICS'
  };

  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('请选择投诉原因'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.entries.map((entry) {
                  return RadioListTile<String>(
                    title: Text(entry.key), // 显示键(文本)
                    value: entry.value,     // 返回值(代码)
                    groupValue: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('提交'),
                onPressed: () {
                  if (selectedValue != null) {
                    var blogState = Provider.of<FeedState>(context, listen: false);
                    blogState.complaint(blogId, blogUid, selectedValue!);
                    Navigator.of(context).pop(selectedValue);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('请选择投诉类型')),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );

}