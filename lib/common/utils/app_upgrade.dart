
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../widgets/dialog_widgets.dart';
import '../dio_wrapper.dart';

class AppUpgrade {

  static AppUpgrade _instance = AppUpgrade._internal();
  AppUpgrade._internal();

  factory AppUpgrade() {
    return _instance;
  }

  Future check(BuildContext context) async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String _os = Platform.isAndroid ? "Android" : "IOS";

    FormData formData = new FormData.fromMap({
      "versionCode": packageInfo.buildNumber,
      "versionName": packageInfo.version,
      "os": _os,
      "model": 4,
    });

    var response = await DioWrapper().dio.post("/api/app/upgrade", data: formData);
    Map<String, dynamic> result = response.data;
    if (result["code"] == 0) {
      bool choice = await DialogUpgrade(context);
      if( choice ) {
        downloadApkAndInstall("https://latter.cn/download/apk/latter_v1.0.1.158.apk");
      }
    } else {
      print("no update.");
    }

  }

  Future downloadApkAndInstall(String fileUrl) async {

    Directory? esd = await getExternalStorageDirectory();
    String fileApk = esd!.path + "/install_new.apk";
    await Dio().download(fileUrl, fileApk);
    InstallPlugin.installApk(fileApk, appId: "com.xiaoyoushijie.app");

  }

}