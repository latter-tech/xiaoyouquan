
import '../models/user_model.dart';

class CurrentUser {

  String? accessToken;

  UserModel? user;

  int uid = 0;

  // 私有构造函数
  CurrentUser._internal();

  // 单例实例
  static final CurrentUser _instance = CurrentUser._internal();

  // 获取单例实例
  static CurrentUser get instance => _instance;

  void setUser(UserModel? user) {
    this.user = user;
    if( user != null ) {
      uid = user.uid!;
    }
  }

  void setAccessToken(String? token) {
    accessToken = token;
  }

  void clear() {
    user = null;
    accessToken = null;
    uid = 0;
  }

}