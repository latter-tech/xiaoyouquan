
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/app_color.dart';
import '../../common/current_user.dart';
import '../../common/dio_wrapper.dart';
import '../../common/widgets.dart';
import '../../generated/l10n.dart';
import '../../models/user_model.dart';
import '../../states/locale_state.dart';
import '../../widgets/settings_appbar.dart';

/**
 * 语言设置
 */
class SettingsLocale extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsLocale();
}

class _SettingsLocale extends State<SettingsLocale> {

  String groupValue = "";

  @override
  void initState() {
    super.initState();
    if( CurrentUser.instance.user!.lang != null ) {
      groupValue = CurrentUser.instance.user!.lang!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LatterColor.white,
      appBar: SettingsAppBar(
        title: S.of(context).select_language,
        subtitle: S.of(context).chinese_and_english_only,
        onTab: _save,
      ),
      body: ListView(
        children: <Widget>[
          _listTile("系统跟随", ""),
          _listTile("简体中文", "zh_CN"),
          _listTile("English", "en_US"),
        ],
      ),
    );
  }

  ListTile _listTile(String title, String locale) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 18),
        leading: Radio (
          value: locale,
          groupValue: groupValue,
          onChanged: (value) {
            setState(() {
              groupValue = locale;
            });
          },
        ),
        title: Cw.customText(
          title,
          style: TextStyle(
            fontSize: 16,
            color: LatterColor.textOnLight,
          ),
        )
    );
  }

  void _save() async{

    FormData formData = new FormData.fromMap({
      "lang": groupValue,
    });
    var response = await DioWrapper().dio.post("/api/user/update_lang", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"] == 0) {
      // 保存到UserState
      UserModel? user = UserModel.fromJson(result["data"]["user"]);
      CurrentUser.instance.setUser(user);
      Cw.showSnackBarV2(context, result["msg"]);
    } else {
      Cw.showSnackBarV2(context, result["msg"]);
    }

    Locale locale;
    if( "" == groupValue ) {
      locale = Localizations.localeOf(context);
    } else {
      var listLocale = groupValue.split("_");
      locale = Locale(listLocale[0], listLocale[1]);
    }

    S.load(locale);

    Provider.of<LocaleState>(context, listen: false).setLocale( locale );

  }

}