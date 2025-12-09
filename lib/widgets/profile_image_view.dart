
import 'package:flutter/material.dart';
import '../common/app_color.dart';
import 'CircularImage.dart';

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({
    Key? key,
    required this.avatar,
    required this.screenName
  }) : super(key: key);

  final String avatar;
  final String screenName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(screenName)),
      backgroundColor: LatterColor.white,
      body: Center(
        child: InteractiveViewer(
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: customAdvanceNetworkImage(avatar),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}