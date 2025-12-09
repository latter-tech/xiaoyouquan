
import 'package:com.xiaoyoushijie.app/models/blog_asset_model.dart';
import 'package:com.xiaoyoushijie.app/models/user_model.dart';
import '../common/enum.dart';

class BlogModel {
  int? id;
  int? uid;
  BlogType? type;
  int? pid;
  int? topId;
  int? topUid;
  int? replyCount;
  int? repostCount;
  int? likeCount;
  int? quoteCount;
  int? viewCount;
  String? fullText;
  List<String>? listLikeUsers;
  List<String>? listRepostUsers;
  DateTime? createdAt;
  List<BlogAssetModel>? assets;
  UserModel? user;
  int? assetType;
  int? quoteId;
  int? quoteUid;
  BlogModel? quoteModel;

  BlogModel (
      { this.id,
        this.uid,
        this.type,
        this.pid,
        this.topId,
        this.topUid,
        this.replyCount,
        this.repostCount,
        this.likeCount,
        this.quoteCount,
        this.viewCount,
        this.fullText,
        this.listRepostUsers,
        this.listLikeUsers,
        this.createdAt,
        this.assets,
        this.user,
        this.assetType,
        this.quoteId,
        this.quoteUid,
        this.quoteModel
      });

  static BlogType? _getBlogType(String type) {
    for( BlogType tt in BlogType.values ) {
      if( tt.name == type ) {
        return tt;
      }
    }
    return null;
  }

  BlogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    type = _getBlogType(json['type']);
    pid = json['pid'];
    topId = json['topId'];
    topUid = json['topUid'];
    replyCount = json['replyCount'];
    repostCount = json['repostCount'];
    likeCount = json['likeCount'];
    quoteCount = json['quoteCount'];
    viewCount = json['viewCount'];
    fullText = json['fullText'];
    listLikeUsers = <String>[];
    if( json['listLikeUsers'] != null ) {
      json['listLikeUsers'].forEach((value) {
        listLikeUsers?.add(value);
      });
    }
    listRepostUsers = <String>[];
    if( json['listRepostUsers'] != null ) {
      json['listRepostUsers'].forEach((value) {
        listRepostUsers?.add(value);
      });
    }
    createdAt = DateTime.parse(json['createdAt']);
    if (json['assets'] != null) {
      assets = <BlogAssetModel>[];
      json['assets'].forEach((v) {
        assets?.add(new BlogAssetModel.fromJson(v));
      });
    }
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    assetType = json['assetType'];
    quoteId = json['quoteId'];
    quoteUid = json['quoteUid'];
    quoteModel = json['quote'] != null ? new BlogModel.fromJson(json['quote']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['type'] = this.type;
    data['pid'] = this.pid;
    data['topId'] = this.topId;
    data['topUid'] = this.topUid;
    data['replyCount'] = this.replyCount;
    data['repostCount'] = this.repostCount;
    data['likeCount'] = this.likeCount;
    data['quoteCount'] = this.quoteCount;
    data['viewCount'] = this.viewCount;
    data['fullText'] = this.fullText;
    data['listLikeUsers'] = this.listLikeUsers;
    data['createdAt'] = this.createdAt;
    data['assets'] = this.assets;
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    data['assetType'] = this.assetType;
    data['quoteId'] = this.quoteId;
    data['quoteUid'] = this.quoteUid;
    if (this.quoteModel != null) {
      data['quote'] = this.quoteModel?.toJson();
    }
    return data;
  }
}