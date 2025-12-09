
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../pages/auth/signin.dart';
import 'current_user.dart';
import 'global.dart';

class TokenInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["access_token"] = CurrentUser.instance.accessToken ?? '';
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    Map<String, dynamic> result = response.data;
    print("TokenInterceptor response code:" + result["code"].toString());
    if( result["code"] == 401 ) {
      NavigatorState? navigatorState = Global.navigatorKey.currentState;
      if (navigatorState != null) {
        navigatorState.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Signin()),
            (route) => route == null
        );
      }
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return super.onError(err, handler);
  }

}