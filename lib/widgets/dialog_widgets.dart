
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/utils/time_utils.dart';

/**
 * 简单alert
 */
Future<void> DialogAlert(BuildContext context, String content) async {
  await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('提示信息'),
          content: Text(content),
          actions: <Widget>[
            CupertinoButton(
              child: Text("确定"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

/**
 * 带确认和取消的alert
 */
Future<bool> DialogConfirm(BuildContext context, String content) async {
  bool result = true;
  await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('提示信息'),
          content: Text(content),
          actions: <Widget>[
            CupertinoButton(
              child: Text("取消"),
              onPressed: () {
                result = false;
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
              child: Text("确定"),
              onPressed: () {
                result = true;
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
  return result;
}

/*
 * 权限申请对话框
 */
Future<bool> DialogPermission(BuildContext context) async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  bool? permissionStatus = prefs!.getBool("permissionStatus");
  if( permissionStatus != null && permissionStatus ) {
    return true;
  }
  bool result = true;
  await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('权限申请'),
          content: Text("啦特需要向您申请打开媒体文件存取权限，以便您使用[分享照片/视频]和[设置头像]等功能。"),
          actions: <Widget>[
            CupertinoButton(
              child: Text("以后再说"),
              onPressed: () {
                result = false;
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
              child: Text("允许"),
              onPressed: () {
                prefs!.setBool("permissionStatus", true);
                result = true;
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
  return result;
}

/**
 * loading
 */
void showLoading(context, String text) {
  text = text ?? "Loading...";
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.0),
                boxShadow: [
                  //阴影
                  BoxShadow(
                    color: Colors.black12,
                    //offset: Offset(2.0,2.0),
                    blurRadius: 10.0,
                  )
                ]),
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            constraints: BoxConstraints(minHeight: 120, minWidth: 180),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

/**
 * app upgrade Dialog
 */
Future<bool> DialogUpgrade(BuildContext context) async {
  SharedPreferences? sp = await SharedPreferences.getInstance();
  int? lastPromptTime = sp!.getInt("upgradeLastPromptTime");
  // 每24小时提示一次
  if( lastPromptTime != null && TimeUtils.getTimestampNow() - lastPromptTime < 24 * 3600  ) {
    print("Less 24 Hours, do not prompt.");
    return false;
  }
  bool result = true;
  await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('检测到更新'),
          content: Column(children: [
            SizedBox(height: 20),
            Text("升级版本，获取更好的使用体验吧！")
          ],),
          actions: <Widget>[
            CupertinoButton(
              child: Text("以后再说"),
              onPressed: () {
                sp!.setInt("upgradeLastPromptTime", TimeUtils.getTimestampNow());
                result = false;
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
              child: Text("立即升级"),
              onPressed: () {
                result = true;
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
  return result;
}