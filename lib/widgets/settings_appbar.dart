
import 'package:flutter/material.dart';
import '../common/app_color.dart';
import '../common/widgets.dart';
import '../generated/l10n.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({Key? key, required this.title, this.subtitle, this.onTab })
      : super(key: key);
  final String? subtitle;
  final String title;
  final void Function()? onTab;
  final Size appBarHeight = const Size.fromHeight(60.0);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 5),
          Cw.customTitleText(
            title,
          ),
          Text(
            subtitle ?? '',
            style: TextStyle(color: LatterColor.textOnLight, fontSize: 16),
          )
        ],
      ),
      iconTheme: const IconThemeData(color: LatterColor.primary),
      backgroundColor: Colors.white,
      actions: [
        onTab != null ? InkWell(
        onTap: onTab,
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
      ) : Container(),
      const SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => appBarHeight;
}