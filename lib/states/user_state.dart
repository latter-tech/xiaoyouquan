
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:com.xiaoyoushijie.app/pages/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/current_user.dart';
import '../common/dio_wrapper.dart';
import '../common/global.dart';
import '../models/user_model.dart';
import 'app_state.dart';

class UserState extends AppState {

  bool isbusy = false;

  /**
   * 记住登录状态
   */
  static Future<void> remember(String accessToken, int _uid) async {
    SharedPreferences? _prefs = await SharedPreferences.getInstance();
    _prefs!.setString("accessToken", accessToken);
    _prefs!.setInt("uid", _uid);
    CurrentUser.instance.setAccessToken(accessToken);
    DioWrapper.update = true;
  }

  /**
   * 退出登录
   */
  static Future<void> logout(BuildContext context) async {
    SharedPreferences? _prefs = await SharedPreferences.getInstance();
    _prefs.remove('accessToken');
    CurrentUser.instance.clear();
    NavigatorState navigatorState = Global.navigatorKey.currentState!;
    if (navigatorState != null) {
      navigatorState.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Welcome()),
              (route) => route == null
      );
    }
  }

  /**
   * 获取用户信息
   */
  Future<UserModel> getUserInfo(int uid) async {
    //await Future.delayed(Duration(milliseconds: 3000), () { print("延时1秒执行"); });
    UserModel userModel = new UserModel();
    FormData formData = new FormData.fromMap({
      "uid": uid,
    });
    var response = await DioWrapper().dio.post("/api/user/get_user_info", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"]==0) {
      userModel = UserModel.fromJson(result["data"]["user"]);
    }
    return userModel;
  }

  /**
   * 获取当前登录用户
   */
  Future<void> getCurrentUser(Function callback) async {
    try {
      SharedPreferences? _prefs = await SharedPreferences.getInstance();
      if ( !_prefs.containsKey('accessToken') ) {
        return callback(false, null);
      }
      CurrentUser.instance.setAccessToken(_prefs.getString('accessToken'));
      FormData formData = new FormData.fromMap({});
      var response = await DioWrapper().dio.post("/api/user/get_user_info", data: {});
      Map<String, dynamic> result = response.data;
      if(result["code"] == 0) {
        UserModel? user = UserModel.fromJson(result["data"]["user"]);
        CurrentUser.instance.setUser(user);
        return callback(true, user.lang);
      }
      return callback(false, null);
    } catch (error) {
      print('getCurrentUser error');
      return callback(false, null);
    }
  }

/**
 * 发送验证码
 */
  Future<String> sendCaptcha(BuildContext context, String type, String mobilephone, String captchaVerification) async {
    FormData formData = new FormData.fromMap({
      "type" : type,
      "mobilephone": mobilephone,
      "captchaVerification" : captchaVerification
    });
    var response = await DioWrapper().dio.post("/api/user/send_captcha", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"] != 0) {
      return result["msg"];
    }
    return "OK";
  }

/**
 * 关注 / 取消关注
 */
  Future<void> follow(int followedId, String type) async {
    FormData formData = new FormData.fromMap({
      "followedId": followedId,
      "type" : type
    });
    var response = await DioWrapper().dio.post("/api/user/follow", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"]==0) {
      if( type == "unfollow" ) {
        if (CurrentUser.instance.user!.listFollows != null && CurrentUser.instance.user!.listFollows!.any((id) => id == followedId)) {
          print(CurrentUser.instance.user!.listFollows!);
          CurrentUser.instance.user!.listFollows!.removeWhere((e) => e == followedId);
          print(CurrentUser.instance.user!.listFollows!);
          CurrentUser.instance.user!.followsCount = CurrentUser.instance.user!.followsCount! - 1;
        }
      } else {
        CurrentUser.instance.user!.listFollows ??= [];
        CurrentUser.instance.user!.listFollows!.add(followedId);
        CurrentUser.instance.user!.followsCount = CurrentUser.instance.user!.followsCount! + 1;
      }
      notifyListeners();
    }
  }

/**
 * 关注列表/粉丝列表
 */
  Future<List<UserModel>?> listFollows(int uid, String type, int page) async {
    FormData formData = new FormData.fromMap({
      "uid": uid,
      "type" : type,
      "page" : page
    });
    var response = await DioWrapper().dio.post("/api/user/list_follows", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"]==0) {
      var data = json.decode(response.toString());
      List<UserModel>? listUser = (data['data'] as List<dynamic>)
          .map((e) => UserModel.fromJson((e as Map<String, dynamic>)))
          .toList();
      return listUser;
    }
    return null;
  }

/**
 *  更新用户名
 */
  Future<String> changeUsername(String username) async {
    FormData formData = new FormData.fromMap({
      "username": username
    });
    var response = await DioWrapper().dio.post("/api/user/update_username", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"] == 0) {
      return "OK";
    } else {
      return result["msg"];
    }
  }

  /**
   *  找回密码 校验验证码
   */
  Future<String> verifyCaptcha(String mobilephone, String captcha) async {
    FormData formData = new FormData.fromMap({
      "mobilephone": mobilephone,
      "captcha" : captcha
    });
    var response = await DioWrapper().dio.post("/api/user/verify_captcha", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"] == 0) {
      return "OK";
    } else {
      return result["msg"];
    }
  }

  /**
   *  找回密码 重置密码
   */
  Future<String> resetPassword(String mobilephone, String captcha, String password) async {
    FormData formData = new FormData.fromMap({
      "mobilephone": mobilephone,
      "captcha" : captcha,
      "password" : password
    });
    var response = await DioWrapper().dio.post("/api/user/reset_password", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"] == 0) {
      return "OK";
    } else {
      return result["msg"];
    }
  }

/**
 * 注销账户
 */
  Future<String> deleteAccount(String password) async {
    FormData formData = new FormData.fromMap({
      "password" : password
    });
    var response = await DioWrapper().dio.post("/api/user/delete_account", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"] == 0) {
      return "OK";
    } else {
      return result["msg"];
    }
  }

}