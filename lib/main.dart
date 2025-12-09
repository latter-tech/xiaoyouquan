import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:com.xiaoyoushijie.app/pages/splash.dart';
import 'package:com.xiaoyoushijie.app/states/app_state.dart';
import 'package:com.xiaoyoushijie.app/states/feed_state.dart';
import 'package:com.xiaoyoushijie.app/states/locale_state.dart';
import 'package:com.xiaoyoushijie.app/states/message_state.dart';
import 'package:com.xiaoyoushijie.app/states/notification_state.dart';
import 'package:com.xiaoyoushijie.app/states/profile_state.dart';
import 'package:com.xiaoyoushijie.app/states/user_state.dart';
import 'common/global.dart';
import 'generated/l10n.dart';
import 'package:com.xiaoyoushijie.app/pages/auth/forget_password.dart';
import 'package:com.xiaoyoushijie.app/pages/auth/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'common/theme.dart';
import 'pages/auth/signin.dart';
import 'pages/home.dart';

/**
 * MultiProvider 放到 MyApp 的上级是为了解决
 * Error: Could not find the correct Provider<UserState> above this MyApp Widget
 * This happens because you used a `BuildContext` th
 */
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppState>(create: (_) => AppState()),
      ChangeNotifierProvider<UserState>(create: (_) => UserState()),
      ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
      ChangeNotifierProvider<ProfileState>(create: (_) => ProfileState()),
      ChangeNotifierProvider<LocaleState>(create: (_) => LocaleState()),
      ChangeNotifierProvider<MessageState>(create: (_) => MessageState()),
      ChangeNotifierProvider<NotificationState>(create: (_) => NotificationState()),
    ],
    child: MyApp()
  )));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleState>(
        builder: (context, localeState, child) { // 这里的context上上面的 context有点迷糊
          return MaterialApp(
            title: '啦特',
            navigatorKey: Global.navigatorKey,
            routes: {
              "/splash" : (context) => Splash(),
              "/signin" : (context) => Signin(),
              "/signup" : (context) => Signup(),
              "/forget" : (context) => ForgetPassword(),
              "/home" : (context) => Home(),
            },
            initialRoute: "/splash", // 启动页
            theme: AppTheme.appTheme.copyWith(
              textTheme: GoogleFonts.mulishTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            //supportedLocales: S.delegate.supportedLocales,
            supportedLocales: [
              Locale('zh', 'CN'),
              Locale('en', '')
            ],
            //locale: Provider.of<LocaleState>(context, listen: false).getLocale(),
            debugShowCheckedModeBanner: false // 隐藏模拟器 Debug图标
          );
        }
    );
  }
}