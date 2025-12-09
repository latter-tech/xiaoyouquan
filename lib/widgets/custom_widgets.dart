import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/common/widgets.dart';
import '../common/app_icons.dart';
import '../common/enum.dart';
import '../pages/compose_blog.dart';

Widget customText(String? msg,
    {Key? key,
      TextStyle? style,
      TextAlign textAlign = TextAlign.justify,
      TextOverflow overflow = TextOverflow.visible,
      BuildContext? context,
      bool softwrap = true}) {
  if (msg == null) {
    return const SizedBox(
      height: 0,
      width: 0,
    );
  } else {
    if (context != null && style != null) {
      var fontSize =
          style.fontSize ?? Theme.of(context).textTheme.bodyLarge!.fontSize;
      style = style.copyWith(
        fontSize: fontSize! - (Cw.fullWidth(context)  <= 375 ? 2 : 0),
      );
    }
    return Text(
      msg,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softwrap,
      key: key,
    );
  }
}

Widget customIcon(
    BuildContext context, {
      required IconData icon,
      bool isEnable = false,
      double size = 18,
      bool istwitterIcon = true,
      bool isFontAwesomeSolid = false,
      Color? iconColor,
      double paddingIcon = 10,
    }) {
  iconColor = iconColor ?? Theme.of(context).textTheme.bodySmall!.color;
  return Padding(
    padding: EdgeInsets.only(bottom: istwitterIcon ? paddingIcon : 0),
    child: Icon(
      icon,
      size: size,
      color: isEnable ? Theme.of(context).primaryColor : iconColor,
    ),
  );
}

Widget modalBottomSheetRow(
    BuildContext context,
    IconData icon,
    {
      required String text,
      required Color iconColor,
      Function? onPressed
    }
    ) {
    return Expanded(
      child: InkWell(
          splashColor: Colors.black26,
          onTap: () {
            if (onPressed != null) {
              onPressed();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                customIcon(
                    context,
                    icon: icon,
                    istwitterIcon: true,
                    size: 26,
                    paddingIcon: 8,
                    iconColor: iconColor
                ),
                const SizedBox(
                  width: 10,
                ),
                customText(
                  text,
                  context: context,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          )
      ),
    );
}

Widget floatingActionButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => ComposeBlog(model: null, blogId: 0, composeType: BlogType.BLOG),
        ),
      );
    },
    child: customIcon(
      context,
      icon: LatterIcon.edit3,
      iconColor: Theme.of(context).colorScheme.onPrimary,
      size: 30,
    ),
  );
}