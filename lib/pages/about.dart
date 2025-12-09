
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/app_color.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_64x64.png'),
            SizedBox(height: 15.0),
            Text(
              '啦特 - 用英文记录美好时光',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 15.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '版本: ',
                  ),
                  FutureBuilder<String>(
                    future: getVersionInfo(),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!);
                      } else {
                        return Text("");
                      }
                    },
                  )
                ],
            ),
            SizedBox(height: 15.0),
            GestureDetector(
              child:  Text(
                  "latter.cn",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: LatterColor.primary
                  )
              ),
              onTap: () async {
                await launchUrlString('https://latter.cn');
              },
            ),
            SizedBox(height: 15.0),
            GestureDetector(
              child:  Text(
                "沪ICP备2024081887号-2A",
                style: TextStyle(
                    fontSize: 15.0,
                    color: LatterColor.primary
                )
              ),
              onTap: () async {
                await launchUrlString('https://beian.miit.gov.cn/');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }

}