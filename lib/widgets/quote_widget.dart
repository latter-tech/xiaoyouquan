import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/common/widgets.dart';
import 'package:com.xiaoyoushijie.app/widgets/text_styles.dart';
import 'package:com.xiaoyoushijie.app/widgets/title_text.dart';
import 'package:com.xiaoyoushijie.app/widgets/url_text.dart';
import '../common/app_color.dart';
import '../common/utils.dart';
import '../common/utils/time_utils.dart';
import '../models/blog_model.dart';
import 'CircularImage.dart';
import 'custom_widgets.dart';

/**
 * 引用内容，分3种情况：
 * 1，发布Blog，显示的是父model内容
 * 2，显示Blog，显示的子model内容
 * 3, 被引用Blog被删除
 */
class QuoteWidget extends StatelessWidget {
  const QuoteWidget({
    Key? key,
    required this.model,
    required this.isCompose,
    required this.marginLeft,
    required this.quoteId
  }) : super(key: key);

  final BlogModel? model;
  final bool isCompose;
  final int? quoteId;
  final double marginLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left:  marginLeft,
          right: 10,
          top: 5),
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black38,
              width: 1.0,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: model == 0 ? Container(child: Text("内容不可见")) : _blog(context, model),
        ),
      ),
    );
  }

  Widget _blog(BuildContext context, BlogModel? model) {
    return model == null
    ? Container(child: Text("啦文不可见"))
    : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: Cw.fullWidth(context) - 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                width: 20,
                height: 20,
                child: CircularImage(
                    path: model!.user!.profileImageUrl
                )
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints:
                BoxConstraints(
                    minWidth: 0, maxWidth: Cw.fullWidth(context) * .5),
                child: TitleText(
                  isCompose ? model!.user!.screenName! : model!.user!.screenName!,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 3),
              Flexible(
                child: customText(
                  '@${model.user!.username}',
                  style: TextStyles.userNameStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              customText(TimeUtils.format(context, isCompose? model.createdAt! : model.createdAt!),
                  style: TextStyles.userNameStyle),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: UrlText(
            text: isCompose ? model.fullText! : model.fullText!,
            style: const TextStyle(
              color: LatterColor.textHint,
              fontSize: 13
            ),
            urlStyle: const TextStyle(
                color: LatterColor.primary, fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(height: model.assets == null ? 8 : 0),
        Utils.viewAsset(model, model.id, true)
      ],
    );
  }

}