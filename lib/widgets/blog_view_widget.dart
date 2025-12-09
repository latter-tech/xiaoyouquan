import 'package:com.xiaoyoushijie.app/common/enum.dart';
import 'package:com.xiaoyoushijie.app/widgets/quote_widget.dart';
import 'package:com.xiaoyoushijie.app/widgets/text_styles.dart';
import 'package:com.xiaoyoushijie.app/widgets/title_text.dart';
import 'package:com.xiaoyoushijie.app/widgets/blog_actions_bar.dart';
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/common/widgets.dart';
import 'package:com.xiaoyoushijie.app/widgets/blog_option_menu.dart';
import '../common/app_icons.dart';
import '../common/utils.dart';
import '../common/utils/time_utils.dart';
import '../generated/l10n.dart';
import '../models/blog_model.dart';
import '../pages/profile.dart';

/**
 * 啦文展示组件
 */
class BlogViewWidget extends StatelessWidget {
  const BlogViewWidget({
    Key? key,
    required this.isDetail,
    required this.model,
    this.index,
    this.remove
  }) : super(key: key);

  final BlogModel model;
  final bool isDetail;
  final int? index;
  final Function? remove;

  @override
  Widget build(BuildContext context) {

    var stack = new Stack();

    switch(model.type) {
      case BlogType.BLOG: // 普通啦文
        stack = Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Utils.naviToDetail(context, model, isDetail, 0);
                  },
                  child: Column (
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>
                      [
                        Container(
                            child: _BlogBody(model: model, index: index, remove: remove)
                        ),
                        // 图片或视频
                        Padding(
                            padding: EdgeInsets.only(top:5, left: 60),
                            child: Utils.viewAsset(model, model.id, false)
                        ),
                        BlogActionsBar(  // 点赞、评论、转发 图标
                          blogId: model.id,
                          model: model,
                          isBlogDetail: isDetail,
                          iconColor: Colors.black54,
                          index: index,
                          marginLeft: 60
                        ),
                      ]
                  )
              )

            ]
        );
        break;
      case BlogType.QUOTE: // 引用
        stack = Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Utils.naviToDetail(context, model, isDetail, 0);
                  },
                  child: Column (
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>
                      [
                        Container(
                            child: _BlogBody(model: model, index: index, remove: remove)
                        ),
                        // 图片或视频
                        Padding(
                            padding: EdgeInsets.only(top:5, left: 50),
                            child: Utils.viewAsset(model, model.id, true)
                        ),
                        // 引用
                        GestureDetector(
                          onTap: () {
                            Utils.naviToDetail(context, model, isDetail, model.quoteModel!.id!);
                          },
                          child: QuoteWidget(model: model.quoteModel, isCompose: false, quoteId: model.quoteId, marginLeft: 60),
                        ),
                        BlogActionsBar(  // 点赞、评论、转发 图标
                          model: model,
                          blogId: model.id,
                          isBlogDetail: isDetail,
                          iconColor: Colors.black54,
                          index: index,
                          marginLeft: 60,
                        ),
                      ]
                  )
              )

            ]
        );
        break;
      case BlogType.REPOST: // 快转
        stack = Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Utils.naviToDetail(context, model, isDetail, 0);
                  },
                  child: Column (
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>
                      [
                        Row( // 快转
                          children: [
                            SizedBox(width: 35),
                            Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Icon(LatterIcon.repost2, size: 20)
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${model.user?.screenName} ${S.of(context).reposted}",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                            child: _BlogBody(model: model.quoteModel, index: index, remove: remove)
                        ),
                        // 图片或视频
                        Padding(
                            padding: EdgeInsets.only(top:5, left: 50),
                            child: Utils.viewAsset(model, model.quoteModel!.id, false)
                        ),
                        model.quoteModel!.quoteModel != null
                            ? QuoteWidget(model: model.quoteModel!.quoteModel!, isCompose: false, quoteId: model.quoteId, marginLeft: 70)
                            : SizedBox(height: 0),
                        BlogActionsBar(  // 点赞、评论、转发 图标
                          model: model,
                          blogId: model.quoteModel?.id,
                          isBlogDetail: isDetail,
                          iconColor: Colors.black54,
                          index: index,
                          marginLeft: 60,
                        )
                      ]
                  )
              )
            ]
        );
        break;
      case BlogType.REPLY: // 评论
        stack = Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Column (
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>
                  [
                    GestureDetector(
                        onTap: () {
                          Utils.naviToDetail(context, model.quoteModel!, isDetail, 0);
                        },
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: <Widget>[
                            // 左侧竖线和内容，不含头像那一行
                            Container(
                              padding: const EdgeInsets.only(left: 28.5),
                              margin: const EdgeInsets.only(left: 30, top: 20, bottom: 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1.0,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(left: 0, right: 12),
                                      child: Cw.customText( model.quoteModel!.fullText )
                                  ),
                                  // 图片或视频
                                  Padding(
                                      padding: EdgeInsets.only(top:5, left: 0),
                                      child: Utils.viewAsset(model, model.quoteModel!.id, true)
                                  ),

                                  // 有引用就显示引用
                                  model.quoteModel!.quoteModel != null
                                      ? QuoteWidget(model: model.quoteModel!.quoteModel!, isCompose: false, quoteId: model.quoteId, marginLeft: 10,)
                                      : SizedBox(),
                                  BlogActionsBar(  // 点赞、评论、转发
                                      model: model,
                                      blogId: model.quoteModel?.id,
                                      isBlogDetail: false,
                                      iconColor: Colors.black54,
                                      index: index,
                                      marginLeft: 0,
                                  ),
                                ],
                              ),
                            ),
                            // 被评论Blog的头部信息
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(width: 10),
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) => Profile(profileUid: model.quoteModel!.uid ?? 0),
                                        ),
                                      );
                                    },
                                    child: Cw.customImage(context, model.quoteModel!.user!.profileImageUrl),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: Cw.fullWidth(context) - 60,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          ConstrainedBox(
                                            constraints: BoxConstraints(minWidth: 0, maxWidth: Cw.fullWidth(context) * .5),
                                            child: TitleText(model.quoteModel!.user!.screenName!,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                          SizedBox(width: 3),
                                          Expanded(
                                            child: Cw.customText(
                                              '@${model!.quoteModel!.user!.username}',
                                              style: TextStyles.userNameStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          TimeUtils.timeConvert(context, model!.quoteModel!.createdAt! ),
                                          Container(
                                              alignment: Alignment.centerRight,
                                              child: BlogOptionMenu(model: model.quoteModel!, index: index, remove: remove)
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ]
                      )
                    ),
                    // reply块
                    GestureDetector(
                      onTap: () {
                        Utils.naviToDetail(context, model, isDetail, 0);
                      },
                      child: Column(children: [
                        _BlogBody(model: model, index: index, remove: remove),
                        BlogActionsBar(
                          model: model,
                          blogId: model.id,
                          isBlogDetail: isDetail,
                          iconColor: Colors.black54,
                          index: index,
                          marginLeft: 60,
                        )
                      ]),
                    )
                  ]
              )
            ]
        );
      break;
      case BlogType.LIKE: // 点赞
        stack = Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Utils.naviToDetail(context, model, isDetail, 0);
                  },
                  child: Column (
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>
                      [
                        Row(
                          children: [
                            SizedBox(width: 35),
                            Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Icon(LatterIcon.likeFill, size: 20)
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${model.user!.screenName} liked",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                            child: _BlogBody(model: model.quoteModel, index: index, remove: remove)
                        ),
                        // 图片或视频
                        Padding(
                            padding: EdgeInsets.only(top:5, left: 50),
                            child: Utils.viewAsset(model, model.quoteModel!.id, false)
                        ),
                        BlogActionsBar(  // 点赞、评论、转发 图标
                          model: model,
                          blogId: model.id,
                          isBlogDetail: isDetail,
                          iconColor: Colors.black54,
                          index: index,
                        )
                      ]
                  )
              )

            ]
        );
        break;
    }
    return stack;
  }

}

// 评论(reply)显示组件
class BlogReplyWidget extends StatelessWidget {
  const BlogReplyWidget({
    Key? key,
    required this.isDetail,
    required this.model,
    this.index,
    this.remove
  }) : super(key: key);

  final BlogModel model;
  final bool isDetail;
  final int? index;
  final Function? remove;

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[

          InkWell(
              onTap: () {
                Utils.naviToDetail(context, model, isDetail, 0);
              },
              child: Column (
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>
                  [
                    Container(
                        child: _BlogBody(model: model, index: index, remove: remove)
                    ),
                    // 图片或视频
                    Padding(
                        padding: EdgeInsets.only(top:5, left: 50),
                        child: Utils.viewAsset(model, model.id, false)
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: BlogActionsBar(  // 点赞、评论、转发 图标
                        blogId: model.id,
                        model: model,
                        isBlogDetail: isDetail,
                        iconColor: Colors.black54,
                        index: index,
                      ),
                    ),
                    Divider(height: 5,thickness: 0.1)
                  ]
              )
          )

        ]
    );
  }

}

class _BlogBody extends StatelessWidget {
  _BlogBody({
    Key? key,
    required this.model,
    this.index,
    this.remove
  });

  final BlogModel? model;
  final int? index;
  final Function? remove;

  @override
  Widget build(BuildContext context) {

    int _uid = model!.uid ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10),
        Container(
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => Profile(profileUid: _uid),
                ),
              );
            },
            child: Cw.customImage(context, model!.user!.profileImageUrl),
          ),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: Cw.fullWidth(context) - 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: Cw.fullWidth(context) * .5),
                    child: TitleText(model!.user!.screenName!,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(width: 2),
                  Expanded(
                    child: Cw.customText(
                      '@${model!.user!.username}',
                      style: TextStyles.userNameStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4),
                  //Cw.customText( TimeUtils.format( context, model!.createdAt! ) ),
                  TimeUtils.timeConvert(context, model!.createdAt! ),
                  Container(
                      alignment: Alignment.centerRight,
                      child: BlogOptionMenu(model: model, index: index, remove: remove)
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Cw.customText( model!.fullText )
              )
            ],
          )
        ),
        //SizedBox(width: 10),
      ],
    );
  }

}