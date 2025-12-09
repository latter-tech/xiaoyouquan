
import 'dart:ui';

class Constants {

  static String getServer() {
    String serverUri = "";
    switch( Constants.profile ) {
      case "prod":
        serverUri = "https://app.latter.cn";
        break;
      case "dev":
        serverUri = "http://192.168.3.3:81";
        break;
      case "mac":
        serverUri = "http://192.168.3.50:81";
        break;
    }
    return serverUri;
  }

  // dev / mac / prod
  static String profile = "prod";

  // 服务器
  static String server = Constants.getServer();

  // 虚设头像
  static String dummyProfileAvatar = 'https://latter.cn/images/pub/avatar.png';

  // 虚设banner

  // 默认语言
  static Locale defaultLocale = Locale( 'zh', 'CN' );



}