
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.xiaoyoushijie.app/common/utils/image_utils.dart';
import 'constants.dart';
import 'current_user.dart';

/*
 * 自定义组件 custom widgets
 */
class Cw {

  static const Color snackBarBackgroundColor = Color(0xfffcf8e3);

  static void showSnackBarV2(
    BuildContext context,
    String msg,
    {double height = 35, Color backgroundColor = snackBarBackgroundColor}
    ) {
    const Color snackBarTextColor = Color(0xff8a6d3b);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        msg,
        style: TextStyle(
          color: snackBarTextColor,
        ),
      ),
    ) );
  }

  static Widget customIcon(
      BuildContext context, {
        int? icon,
        bool isEnable = false,
        double size = 18,
        bool istwitterIcon = true,
        bool isFontAwesomeRegular = false,
        bool isFontAwesomeSolid = false,
        Color? iconColor,
        double paddingIcon = 10,
      }) {
    iconColor = iconColor ?? Theme.of(context).textTheme.bodySmall!.color;
    return Padding(
      padding: EdgeInsets.only(bottom: istwitterIcon ? paddingIcon : 0),
      child: Icon(
        IconData(icon!,
            fontFamily: istwitterIcon
                ? 'TwitterIcon'
                : isFontAwesomeRegular
                ? 'AwesomeRegular'
                : isFontAwesomeSolid ? 'AwesomeSolid' : 'Fontello'),
        size: size,
        color: isEnable ? Theme.of(context).primaryColor : iconColor,
      ),
    );
  }

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Widget customImage(
      BuildContext context,
      String? path, {
        double height = 50,
        bool isBorder = false,
      }) {
    final avatarUrl = path ?? Constants.dummyProfileAvatar;

    return Container(
      width: height,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade100,
          width: isBorder ? 2 : 0,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: CachedNetworkImage(
        imageUrl: avatarUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: Center(child: Icon(Icons.person, size: height * 0.5, color: Colors.grey)),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          child: Center(child: Icon(Icons.error, size: height * 0.5, color: Colors.red)),
        ),
      ),
    );
  }

  static Widget customTitleText(String? title, {BuildContext? context}) {
    return Text(
      title ?? '',
      style: TextStyle(
        color: Colors.black87,
        fontFamily: 'HelveticaNeue',
        fontWeight: FontWeight.w900,
        fontSize: 20,
      ),
    );
  }

  static Widget customInkWell(
      {Widget? child,
        BuildContext? context,
        Function(bool, int)? function1,
        Function? onPressed,
        bool isEnable = false,
        int no = 0,
        Color color = Colors.transparent,
        Color? splashColor,
        BorderRadius? radius}) {
    if (splashColor == null) {
      splashColor = Theme.of(context!).primaryColorLight;
    }
    if (radius == null) {
      radius = BorderRadius.circular(0);
    }
    return Material(
      color: color,
      child: InkWell(
        borderRadius: radius,
        onTap: () {
          if (function1 != null) {
            function1(isEnable, no);
          } else if (onPressed != null) {
            onPressed();
          }
        },
        splashColor: splashColor,
        child: child,
      ),
    );
  }

  static TextStyle onPrimaryTitleText() {
    return TextStyle(color: Colors.white,fontWeight: FontWeight.w600);
  }

  static dynamic customAdvanceNetworkImage(String? path) {
    if (path == null) {
      path = Constants.dummyProfileAvatar;
    }
    return CachedNetworkImageProvider(
      path,
    );
  }

  static Widget customText(String? msg,
      {Key? key,
        TextStyle? style,
        TextAlign textAlign = TextAlign.justify,
        TextOverflow overflow = TextOverflow.visible,
        BuildContext? context,
        bool softwrap = true}) {
    if (msg == null) {
      return SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      if (context != null && style != null) {
        var fontSize = style.fontSize ?? 13;
        style = style.copyWith(
          fontSize: fontSize - (fullWidth(context) <= 375 ? 2 : 0),
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

  static GestureDetector appBarLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: Padding(
          padding: EdgeInsets.all(13.0),
          child: ClipOval(
              child: ImagesUtils.profileImage(CurrentUser.instance.user!.profileImageUrl ?? "")
          )
        )
    );
  }

}