import 'dart:convert';
import 'package:dio/dio.dart';
import '../common/dio_wrapper.dart';
import '../common/utils/tts_player.dart';
import '../models/blog_model.dart';
import 'app_state.dart';

class FeedState extends AppState {

  int update = 0;

  int? _playingIndex;
  bool _isPlaying = false;

  int? get playingIndex => _playingIndex;
  bool get isPlaying => _isPlaying;

  late final TtsPlayer tts;

  FeedState() {
    tts = new TtsPlayer();
    tts.setCompletionHandler(stop);
  }

  /// 播放文本
  Future<void> speak(String? text, int? index) async {
    if( text == null || text.isEmpty ) {
      return;
    }
    if (_isPlaying && _playingIndex == index) {
      // 如果正在播放当前项，则停止
      await stop();
    } else {
      // 停止当前播放（如果有）
      await stop();
      // 开始播放新的文本
      _isPlaying = true;
      _playingIndex = index;
      await tts.speak(text);
    }
    notifyListeners();
  }

  /// 停止播放
  Future<void> stop() async {
    await tts.stop();
    _isPlaying = false;
    _playingIndex = null;
    notifyListeners();
  }

  /**
   * 获取啦文详情
   */
  Future<BlogModel> getBlog(int? blogId) async {
    var response  = await DioWrapper().dio.post(
        "/api/statuses/show",
        queryParameters: {
          "blogId" : blogId,
        },
        options: Options(responseType: ResponseType.json)
        );
    var data = json.decode(response.toString());
    return BlogModel.fromJson(data['data']);
  }

  /*
   * UserTimeline
   */
  Future<List<BlogModel>?> userTimeline(int uid, String types, int page, String queryType, int parentId, {String keyword = ""}) async {
    var response  = await DioWrapper().dio.post(
        "/api/statuses/user_timeline",
        queryParameters: {
          "uid" : uid,
          "types" : types,
          "queryType" : queryType,
          "parentId" : parentId,
          "page": page,
          "keyword" : keyword
        },
        options: Options(responseType: ResponseType.json)
    );
    var data = json.decode(response.toString());
    List<BlogModel>? listBlog = (data['data'] as List<dynamic>)
        .map((e) => BlogModel.fromJson((e as Map<String, dynamic>)))
        .toList();
    return listBlog;
  }

  /**
   * 点赞  和取消点赞
   */
  void like(BlogModel model, int? blogId, String loginUid) async {

    if( blogId != model.id ) {
      model = model.quoteModel!;
    }

    FormData formData = new FormData.fromMap({
      "blogId" : model.id,
      "blogUid" : model.uid,
    });

    var response = await DioWrapper().dio.post("/api/statuses/like", data: formData);
    Map<String, dynamic> result = response.data;
    if (result["code"] == 0) {
      if (model.listLikeUsers != null && model.listLikeUsers!.any((id) => id == loginUid)) {
        model.listLikeUsers!.removeWhere((id) => id == loginUid);
        model.likeCount = model.likeCount! - 1;
      } else {
        model.listLikeUsers ??= [];
        model.listLikeUsers!.add(loginUid);
        model.likeCount = model.likeCount! + 1;
      }
      notifyListeners();
    }

  }

  /**
   * 转发(快转)
   */
  void repostBlog(BlogModel model, int? blogId) async {
    if( blogId != model.id ) {
      model = model.quoteModel!;
    }
    FormData formData = new FormData.fromMap({
      "quoteId" : model.id,
      "quoteUid" : model.uid
    });
    var response = await DioWrapper().dio.post("/api/statuses/repost", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"]==0) {
      print("repostBlog ok");
    }
  }

  /**
   * 取消转发（快转）
   */
  void unRepostBlog(BlogModel model, int? parentId) async {
    int? quoteId = model.id;
    FormData formData = new FormData.fromMap({
      "blogId" : parentId,
      "quoteId" : quoteId,
    });
    var response = await DioWrapper().dio.post("/api/statuses/unrepost", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"]==0) {
      print("unRepostBlog ok");
    }
  }

  /**
   * 删除
   */
  void destroy(int? blogId) async {
    FormData formData = new FormData.fromMap({
      "blogId": blogId,
    });
    var response = await DioWrapper().dio.post("/api/statuses/destroy", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"]==0) {
      print("deleted");
    }
  }

/**
 * 投诉
 */
  void complaint(int blogId, int blogUid, String cType) async {
    FormData formData = new FormData.fromMap({
      "blogId": blogId,
      "blogUid": blogUid,
      "cType": cType,
    });
    var response = await DioWrapper().dio.post("/api/statuses/complaint", data: formData);
    Map<String, dynamic> result = response.data;
    if(result["code"]==0) {
      print("complainted");
    }
  }

}