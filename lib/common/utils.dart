import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/blog_model.dart';
import '../pages/blog_detail.dart';
import '../states/feed_state.dart';
import '../widgets/blog_image_widget.dart';
import '../widgets/blog_video_widget.dart';
import 'current_user.dart';

class Utils {

  static String getExt(String fileName) {
    return fileName.substring( fileName.lastIndexOf(".") + 1 ).toLowerCase();
  }

  /**
   * 时间格式化
   */
  static String timeFormat(DateTime dateTime) {
    Duration diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  static Widget viewAsset(BlogModel model, int? blogId, bool isQuote) {
    if( blogId != model.id ) {
      model = model.quoteModel!;
    }
    if( model.assetType == 1 ) {
      return BlogImageWidget(model: model, isQuote: isQuote);
    } else if( model.assetType == 2 ) {
      return BlogVideoWidget(model: model, isQuote: isQuote);
    } else {
      return Container();
    }
  }

  static Future<void> gotoBlogDetail(BuildContext context, int? blogId) async {
    FeedState blogState = Provider.of<FeedState>(context, listen: false);
    BlogModel? model = await blogState.getBlog(blogId);
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => BlogDetail(model: model),
      ),
    );
  }

  static void naviToDetail(BuildContext context, BlogModel model, bool isDetail, int fromQuoteId) async {
    if( isDetail ) {
      return;
    }
    if( fromQuoteId > 0 ) {
      FeedState blogState = Provider.of<FeedState>(context, listen: false);
      model = await blogState.getBlog(fromQuoteId);
    }
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => BlogDetail(model: model),
      ),
    );
  }

  static Widget shortDivider(double height, double thickness) {
    return Padding(
      padding: EdgeInsets.only(left:20, right: 20),
      child: Divider(
          height: height,
          thickness: thickness,
          color: Colors.black26
      )
    );
  }

  /**
   * 是否已关注
   */
  static bool isFollowing(int followedId) {
    if ( CurrentUser.instance.user!.listFollows != null ) {
      return CurrentUser.instance.user!.listFollows!.any((x) => x == followedId );
    }
    return false;
  }

}