import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:com.xiaoyoushijie.app/common/enum.dart';
import 'package:com.xiaoyoushijie.app/pages/compose_blog.dart';
import 'package:provider/provider.dart';
import '../common/app_icons.dart';
import '../common/current_user.dart';
import '../common/utils.dart';
import '../common/widgets.dart';
import '../generated/l10n.dart';
import '../models/blog_model.dart';
import '../states/feed_state.dart';
import 'custom_widgets.dart';

/**
 * 评论，转发，点赞 栏
 */
class BlogActionsBar extends StatelessWidget {
  BlogActionsBar(
      { Key? key,
        required this.model,
        required this.blogId,
        required this.iconColor,
        required this.index,
        this.isBlogDetail = false,
        this.marginLeft = 0
      }) : super(key: key);

      final BlogModel model;
      final int? blogId;
      final Color iconColor;
      final bool isBlogDetail;
      final double marginLeft;
      final int? index;

      @override
      Widget build(BuildContext context) {
        return isBlogDetail
            ? _detailTail(context)
            : Padding(
              padding: EdgeInsets.only(left: marginLeft),
              child: _likeCommentsIcons(context, model, blogId, index)
            );
      }

      /**
       * 详情页的actions bar
       */
      Widget _detailTail(context) {
              return Container(
                child: Column (
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width:20),
                      Text(DateFormat("yyyy-MM-dd HH:mm - ", Locale('zh').toString()).format(model.createdAt!)),
                      Text(" ${model.viewCount} 次查看"),
                    ],
                  ),
                  Utils.shortDivider(20, 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width:20),
                      Text("${model.repostCount} 个转贴 - ${model.quoteCount} 引用 - ${model.likeCount} 喜欢"),
                    ],
                  ),
                  Utils.shortDivider(20, 0.5),
                  Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: _likeCommentsIcons(context, model, blogId, index),
                  )
                ]
              ));
            }

        Widget _likeCommentsIcons(BuildContext context, BlogModel model, int? blogId, int? index) {
          int? parentId = model.id;
          if( blogId != model.id ) {
            model = model.quoteModel!;
          }
          var blogState = Provider.of<FeedState>(context, listen: false);
          return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(bottom: 0, top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                /**
                 * 朗读
                 */
                Consumer<FeedState>(
                  builder: (context, state, _) {
                    return _iconWidget(
                            context,
                            text: '',
                            icon: state.playingIndex == index && state.isPlaying
                                ? LatterIcon.soundFill // 播放中
                                : LatterIcon.sound, // 静止
                            iconColor: state.playingIndex == index && state.isPlaying ? Colors.blue : iconColor,
                            size: 20,
                            onPressed: () => state.speak(model.fullText, index)
                      );
                    }),

                /**
                 *  评论
                 */
                _iconWidget(
                  context,
                  text: isBlogDetail ? '' : model.replyCount.toString(),
                  icon: LatterIcon.comment,
                  iconColor: iconColor,
                  size: 20,
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => ComposeBlog(model: model, blogId: blogId, composeType: BlogType.REPLY),
                      ),
                    );
                  },
                ),
                /**
                 * 转发（快转） & 引用
                 */
                _iconWidget(context,
                    text: isBlogDetail ? '' : model.repostCount.toString(),
                    icon: LatterIcon.repost,
                    iconColor: iconColor,
                    size: 20,
                    onPressed: () {

                      // 是否已快转
                      bool isRepostedBlog = model.listRepostUsers!.any((userId) => userId == CurrentUser.instance.user!.uid!.toString());

                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder : (context) {
                            return Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    color: Colors.white
                                ),
                                height: Cw.fullHeight(context) * .22,
                                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                child: Column(
                                  children: [
                                    // 快转
                                    modalBottomSheetRow(context,
                                        LatterIcon.repost2,
                                        text: isRepostedBlog ? S.of(context).undo_repost : S.of(context).repost,
                                        iconColor: isRepostedBlog ? Color(0xFFf91880) : Colors.black87,
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          isRepostedBlog ? blogState.unRepostBlog(model, parentId) : blogState.repostBlog(model, blogId);
                                        }
                                    ),
                                    // 引用
                                    modalBottomSheetRow(context,
                                        LatterIcon.quote2,
                                        text: S.of(context).quote,
                                        iconColor: Colors.black87,
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ComposeBlog(model: model,  blogId: blogId, composeType: BlogType.QUOTE);
                                            }),
                                         );
                                    })
                                  ],
                                )
                            );
                          }
                      );
                    }),
                /**
                 * 点赞
                 */
              Consumer<FeedState>(
                  builder: (context, state, _) {
                    return _iconWidget(
                      context,
                      text: isBlogDetail ? '' : model.likeCount.toString(),
                      icon: model.listLikeUsers!.any((userId) => userId == CurrentUser.instance.user!.uid!.toString())
                          ? LatterIcon.likeFill
                          : LatterIcon.like,
                      onPressed: () {
                        state.like(model, blogId, CurrentUser.instance.user!.uid!.toString());
                      },
                      iconColor: iconColor,
                      size: 20,
                    );
                  }),
              ],
            ),
          );
        }

        Widget _iconWidget(
            BuildContext context,
            {required String text,
              IconData? icon,
              Function? onPressed,
              required Color iconColor,
              double size = 20}
            ) {;
          if (icon == null) assert(icon != null);
          return Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    if (onPressed != null) onPressed();
                  },
                  icon: customIcon(
                          context,
                          size: size,
                          icon: icon!,
                          istwitterIcon: true,
                          iconColor: iconColor,
                        ),
                ),
                customText(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                    fontSize: size - 5,
                  ),
                  context: context,
                ),
              ],
            ),
          );
        }

}