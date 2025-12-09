
import 'package:flutter/material.dart';
import '../common/app_color.dart';
import '../common/current_user.dart';
import '../common/widgets.dart';
import '../generated/l10n.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/title_text.dart';
import '../widgets/blog_list_widget.dart';

/**
 * 上拉刷新还需要优化，EasyReFresh需要花点时间研究下 Locator 指示器
 * 需要考虑空列表的情况
 */
class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedPage();
}

class _FeedPage extends State<FeedPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    uid = CurrentUser.instance.uid;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        floatingActionButton: floatingActionButton(context),
        appBar: AppBar(
            leading: Cw.appBarLeading(context),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/logo_32x32.png", width: 32, height:32),
                SizedBox(width: 60)
              ],
            )
        ),
        body: Column(
          children: [
            Container(
              height: 50.0,
              child: TabBar(
                indicator: null,
                //labelPadding: EdgeInsets.only(bottom: 0.0, top:0.0),
                controller: _tabController,
                tabs: [
                  Tab(text: S.of(context).for_you, iconMargin: EdgeInsets.only(bottom: 0.0),),
                  Tab(text: S.of(context).my_follow),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  BlogListWidget(uid: uid, types: "BLOG,QUOTE", queryType: "suggest", page: 1),
                  BlogListWidget(uid: uid, types: "BLOG,REPLY,REPOST,QUOTE", queryType: "follow", page: 1)
                ],
              ),
            )
          ],
        )
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

}

class EmptyList extends StatelessWidget {
  EmptyList(this.title, {this.subTitle});

  final String? subTitle;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Cw.fullHeight(context) - 135,
        color: LatterColor.primary,
        child: NotifyText(title: title!, subTitle: subTitle!,)
    );
  }
}

class NotifyText extends StatelessWidget {
  final String? subTitle;
  final String? title;
  const NotifyText({Key? key, this.subTitle, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleText(title!, fontSize: 20, textAlign: TextAlign.center),
        SizedBox(
          height: 20,
        ),
        TitleText(
          subTitle!,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: LatterColor.textOnLight,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}