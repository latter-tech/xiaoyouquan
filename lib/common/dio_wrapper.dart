
import 'package:dio/dio.dart';
import 'package:com.xiaoyoushijie.app/common/constants.dart';
import 'package:com.xiaoyoushijie.app/common/token_interceptor.dart';

class DioWrapper {

  late Dio dio;

  static bool update = false;

  static final DioWrapper _instance = DioWrapper._internal();

  DioWrapper._internal() {
    dio = Dio(BaseOptions(
        baseUrl: Constants.server
    ));
    dio.interceptors.add(TokenInterceptor());
  }

  factory DioWrapper() {
    return _instance;
  }

}