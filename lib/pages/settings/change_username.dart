import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.xiaoyoushijie.app/common/current_user.dart';
import 'package:com.xiaoyoushijie.app/states/user_state.dart';
import 'package:provider/provider.dart';
import '../../common/app_color.dart';
import '../../common/widgets.dart';
import '../../generated/l10n.dart';

/**
 * 修改用户名
 */
class ChangeUsernamePage extends StatelessWidget {

  TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    UserState userState = Provider.of<UserState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('更新用户名'),
        actions: <Widget>[
          InkWell(
            onTap: () async {
              String newUsername = editController.text;
              if( newUsername != "" ) {
                String result = await userState.changeUsername(newUsername);
                if(result == "OK") {
                  CurrentUser.instance.user!.username = newUsername;
                  Cw.showSnackBarV2(context, "更新成功");
                } else {
                  Cw.showSnackBarV2(context, result);
                }
              } else {
                Cw.showSnackBarV2(context, "请输入用户名");
              }
            },
            child: Center(
              child: Text(
                S.of(context).save,
                style: TextStyle(
                  color: LatterColor.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              Cw.customText(
                "当前",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: LatterColor.textOnLight,
                ),
              ),
              const SizedBox(height: 10.0),
              Cw.customText(
                "${CurrentUser.instance.user!.username}",
                style: TextStyle(
                  fontSize: 16,
                  color: LatterColor.textOnLight,
                ),
              ),
              const SizedBox(height: 10.0),
              Cw.customText(
                "新",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: LatterColor.textOnLight,
                ),
              ),
              const SizedBox(height: 5.0),
              TextField(
                enabled: true,
                controller: editController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "用户名",
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
              )
            ],
        ),
      ),
    );
  }

}