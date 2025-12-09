
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:com.xiaoyoushijie.app/pages/edit_profile.dart';
import 'package:provider/provider.dart';
import '../common/app_color.dart';
import '../common/app_icons.dart';
import '../common/current_user.dart';
import '../common/utils.dart';
import '../common/widgets.dart';
import '../generated/l10n.dart';
import '../models/user_model.dart';
import '../states/user_state.dart';
import '../widgets/CircularImage.dart';
import '../widgets/cache_image.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/profile_image_view.dart';
import '../widgets/ripple_button.dart';
import '../widgets/tab_indicator.dart';
import '../widgets/text_styles.dart';
import '../widgets/blog_list_widget.dart';
import '../widgets/url_text.dart';
import 'follows_page.dart';
import 'messages_page.dart';

/**
 * 个人资料 (个人主页)
 */
class Profile extends StatefulWidget {
  const Profile({
    Key? key,
    required this.profileUid
  }) : super(key: key);

  final int profileUid;

  @override
  State<StatefulWidget> createState()  => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isMyProfile = false;
  int pageIndex = 0;

  late UserModel profileUser;
  late TabController _tabController;

  @override
  void initState() {
    isMyProfile = CurrentUser.instance.user!.uid! == widget.profileUid ? true : false;
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  build(BuildContext context) {

    var userState = Provider.of<UserState>(context, listen: false);

    return FutureBuilder(
      future: userState.getUserInfo(widget.profileUid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if( snapshot.connectionState == ConnectionState.done ) {
          profileUser = snapshot.data;
          return PopScope(
            child: Scaffold(
              key: scaffoldKey,
              floatingActionButton: !isMyProfile ? null : floatingActionButton(context),
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                  return <Widget>[
                    BannerAndAvatarRow(),
                    SliverToBoxAdapter(
                      child: Container(
                          color: Colors.white,
                          child: MiddlePart()
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            color: LatterColor.white,
                            child: TabBar(
                              indicator: TabIndicator(), // ??
                              controller: _tabController,
                              tabs: <Widget>[
                                Text(S.of(context).blogs),
                                Text(S.of(context).blogs_and_replies),
                                Text(S.of(context).likes)
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    BlogListWidget(uid: widget.profileUid, types: "BLOG,REPOST,QUOTE", queryType: "", page: 1),
                    BlogListWidget(uid: widget.profileUid, types: "BLOG,REPOST,QUOTE,REPLY", queryType: "", page: 1),
                    BlogListWidget(uid: widget.profileUid, types: "LIKE", queryType: "", page: 1),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
              body: Container(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.lightBlue),
                  )
              )
          );
        }
      },
    );
  }

  SliverAppBar BannerAndAvatarRow() {
    return SliverAppBar(
      forceElevated: false,
      expandedHeight: 200,
      elevation: 0,
      stretch: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      actions: <Widget>[],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        // 上拉隐藏区域
        background:
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SizedBox.expand(
              child: Container(
                padding: const EdgeInsets.only(top: 50),
                height: 30,
                color: Colors.white,
              ),
            ),

            /// Banner image
            Container(
              height: 180,
              padding: const EdgeInsets.only(top: 28),
              child: CacheImage( // profile banner
                path: profileUser.profileBannerUrl,
                fit: BoxFit.fill,
              ),
            ),

            Container(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  AnimatedContainer( // 头像
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5),
                        shape: BoxShape.circle),
                    child: RippleButton(
                      child: CircularImage(
                        path: profileUser.profileImageUrl,
                        height: 80,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      onPressed: () {
                        // 放大头像显示
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ProfileImageView(avatar: profileUser!.profileImageUrl!,screenName: profileUser!.screenName!,)
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 90, right: 30),
                    child: followButtonBlock()
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Row followButtonBlock() {
    var userState = Provider.of<UserState>(context, listen: false);
    return isMyProfile
        ? Row(
            children: <Widget>[
              // 编辑个人资料 按钮
              RippleButton(
                splashColor: LatterColor.primary.withAlpha(100),
                borderRadius: const BorderRadius.all(Radius.circular(60)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfile(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: LatterColor.white,
                    border: Border.all(
                        color: Colors.black87.withAlpha(180),
                        width: 1
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    S.of(context).edit_profile,
                    style: TextStyle(
                      color: Colors.black87.withAlpha(180),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              ),
            ]
          )
        : Row(
          children: <Widget>[
            // 私信 按钮
            RippleButton(
              splashColor: LatterColor.lightBackground.withAlpha(100),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => MessagesPage(peerUser: profileUser, conversationId: 0)
                  ),
                );
              },
              child: Container(
                height: 35,
                width: 35,
                padding: const EdgeInsets.only(top: 0, right: 0, bottom: 5, left: 0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: LatterColor.primary,
                        width: 1
                    ),
                    shape: BoxShape.circle
                ),
                child: const Icon(
                  LatterIcon.message,
                  color: LatterColor.primary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 关注 & 取消关注 按钮
            Consumer<UserState>(
                builder: (ctx, state, child) {
                  bool isFollowing = Utils.isFollowing( widget.profileUid );
                  return RippleButton(
                    splashColor: LatterColor.lightBackground.withAlpha(100),
                    borderRadius: const BorderRadius.all(Radius.circular(60)),
                    onPressed: () async {
                      if( isFollowing ) {
                        await userState.follow(widget.profileUid, "unfollow");
                      } else {
                        await userState.follow(widget.profileUid, "follow");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: LatterColor.primary,
                        border: Border.all(
                            color: LatterColor.primary,
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isFollowing ? S.of(context).followed : S.of(context).following,
                        style: TextStyle(
                          color: LatterColor.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
          ]
      );

  }

  /**
   * 个人信息部分
   */
  Widget MiddlePart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: <Widget>[
              UrlText(
                text: profileUser!.screenName!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                width: 3,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: customText(
            '@' + profileUser!.username!,
            style: TextStyles.subtitleStyle.copyWith(fontSize: 13),
          ),
        ),
        profileUser!.description!.isEmpty
            ? SizedBox()
            :Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: customText(
                  profileUser!.description
              ),
            ),
        profileUser!.location!.isEmpty
          ? SizedBox()
          : Padding (
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  customIcon(context,
                      icon: Icons.location_city_outlined,
                      size: 14,
                      paddingIcon: 5,
                      iconColor: LatterColor.textOnLight),
                  const SizedBox(width: 10),
                  Expanded(
                    child: customText(
                        profileUser!.location
                    ),
                  )
                ],
              )
            ),
        // 注册日期
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              customIcon(context,
                  icon: Icons.calendar_month,
                  size: 14,
                  paddingIcon: 5,
                  iconColor: LatterColor.textOnLight),
              const SizedBox(width: 10),
              customText(
                  '${DateFormat("yyyy-MM").format(profileUser!.createdAt!)} ${S.of(context).joined}'
              ),
            ],
          ),
        ),
        // 关注/粉丝数
        Container(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
                height: 30,
              ),
              _tappbleText(context, '${profileUser!.followsCount}', S.of(context).following, 'following'),
              const SizedBox(width: 30),
              _tappbleText(context, '${profileUser!.fansCount}', S.of(context).followers, 'followers'),
            ]
          ),
        ),
      ],
    );
  }

  Widget _tappbleText(
      BuildContext context,
      String count,
      String text,
      String type) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => FollowsPage(type: type, uid: CurrentUser.instance.user!.uid!, screenName: CurrentUser.instance.user!.screenName!),
          ),
        );
      },
      child: Row(
        children: <Widget>[
          Cw.customText(
            '$count ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: LatterColor.primary),
          ),
          Cw.customText(
            '$text',
            style: TextStyle(color: LatterColor.textOnLight, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

}