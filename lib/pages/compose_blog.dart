
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:com.xiaoyoushijie.app/common/app_color.dart';
import 'package:com.xiaoyoushijie.app/common/current_user.dart';
import 'package:com.xiaoyoushijie.app/pages/profile.dart';
import 'package:com.xiaoyoushijie.app/widgets/PickMethod.dart';
import 'package:video_compress_v2/video_compress_v2.dart';
import '../common/app_icons.dart';
import '../common/dio_wrapper.dart';
import '../common/enum.dart';
import '../common/utils.dart';
import '../common/utils/time_utils.dart';
import '../models/blog_model.dart';
import '../widgets/dialog_widgets.dart';
import '../widgets/quote_widget.dart';
import '../widgets/text_styles.dart';
import '../widgets/title_text.dart';
import '/common/widgets.dart';
import '/widgets/CircularImage.dart';
import '/widgets/SelectedAssetsListView.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart' show AssetEntity, AssetPicker, AssetPickerViewer;
import 'package:dio/dio.dart';

/**
 * 发布，引用，评论
 * v1.0.0版本暂时先隐藏视频
 */
class ComposeBlog extends StatefulWidget {
  const ComposeBlog({
    Key? key,
    required this.model,
    required this.blogId,
    required this.composeType
  }): super(key: key);

  final BlogModel? model;
  final int? blogId;
  final BlogType? composeType;

  @override
  State<StatefulWidget> createState() => _ComposeBlog();
}

class _ComposeBlog extends State<ComposeBlog> {

  ScrollController scrollcontroller = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);
  // 已选择的资源类型 1图片，2视频
  final ValueNotifier<int> _selectedAssetTypeId = ValueNotifier<int>(0);
  // 文字内容是否为空
  final ValueNotifier<bool> _isNullOfFullText = ValueNotifier<bool>(true);

  List<AssetEntity> assets = <AssetEntity>[];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    BlogModel? model = widget.model;
    if( model != null && model.id != widget.blogId ) {
      model = model.quoteModel!;
    }

    var stack = new Stack();

    switch( widget.composeType ) {

      case BlogType.BLOG: // 普通 Blog
      case BlogType.QUOTE: // 引用

        stack = Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: scrollcontroller,
              child: Container(
                height: Cw.fullHeight(context),
                padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox.shrink(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircularImage(path: CurrentUser.instance.user!.profileImageUrl, height: 40),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(
                            //     RegExp(r"[a-zA-Z\d\s!""\"#\$%&'()*+,-\./:;<=>?@[\\\]^_`{|}~]{1,200}")
                            //   )
                            // ],
                            onChanged: (text) {
                              if( text.isNotEmpty ) {
                                _isNullOfFullText.value = false;
                              } else {
                                _isNullOfFullText.value = true;
                              }
                            },
                            maxLines: null,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '有啥新鲜事？(中文会自动翻译成英文哦)',
                                hintStyle: TextStyle(fontSize: 15, color: Colors.black26)
                            ),
                          ),
                        )
                      ],
                    ),
                    model != null ? QuoteWidget(model: model, isCompose: true, quoteId: model.quoteId, marginLeft: 50) : Container(),
                    if (assets.isNotEmpty)
                      SizedBox( height: 10.0 ),
                    SelectedAssetsListView( // 显示已选中的 Assets
                      assets: assets,
                      isDisplayingDetail: isDisplayingDetail,
                      onResult: onResult,
                      onRemoveAsset: removeAsset,
                    ),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: Cw.fullWidth(context),
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
                      color: LatterColor.white
                  ),
                  child: ValueListenableBuilder<int>(
                    builder: buildSelectButtons,
                    valueListenable: _selectedAssetTypeId,
                  ),
                )
            ),
          ],
        );

        break;

      case BlogType.REPLY: // 评论

        stack = Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: scrollcontroller,
              child: Container(
                height: Cw.fullHeight(context),
                //padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox.shrink(),
                    Stack(
                        alignment: Alignment.topLeft,
                        children: <Widget>[
                          // 左侧竖线和内容
                          Container(
                            padding: const EdgeInsets.only(left: 30),
                            margin: const EdgeInsets.only(left: 30, top: 20, bottom: 3),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  width: 1.0,
                                  //color: Colors.grey.shade400,
                                  color: Colors.grey.shade300
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    child: Cw.customText( model!.fullText )
                                ),
                                // 图片或视频
                                Padding(
                                    padding: EdgeInsets.only(top:5, left: 10),
                                    child: Utils.viewAsset(model, model.id, true)
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:30, left: 10),
                                  child: Cw.customText("回复给 @${model.user!.username}")
                                )
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
                                        builder: (context) => Profile(profileUid: model!.user!.uid!),
                                      ),
                                    );
                                  },
                                  child: Cw.customImage(context, model.user!.profileImageUrl),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                width: Cw.fullWidth(context) - 90,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minWidth: 0, maxWidth: Cw.fullWidth(context) * .5),
                                                child: TitleText("${model.user!.screenName}",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                              SizedBox(width: 3),
                                              Flexible(
                                                child: Cw.customText(
                                                  '@${model.user!.username}',
                                                  style: TextStyles.userNameStyle,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Cw.customText(TimeUtils.format( context, model.createdAt! )),
                                            ],
                                          ),
                                        ),
                                        Container(child: SizedBox()),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          )
                        ]
                    ),
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
                                  builder: (context) => Profile(profileUid: CurrentUser.instance.user!.uid!),
                                ),
                              );
                            },
                            child: Cw.customImage(context, CurrentUser.instance.user!.profileImageUrl),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(
                            //       RegExp(r"[a-zA-Z\d\s!""\"#\$%&'()*+,-\./:;<=>?@[\\\]^_`{|}~]{1,200}")
                            //   )
                            // ],
                            onChanged: (text) {
                              if( text.isNotEmpty ) {
                                _isNullOfFullText.value = false;
                              } else {
                                _isNullOfFullText.value = true;
                              }
                            },
                            maxLines: null,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '回复啦文(中文会自动翻译成英文哦)',
                                hintStyle: TextStyle(fontSize: 15, color: Colors.black26)
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: Cw.fullWidth(context),
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
                      color: LatterColor.white
                  ),
                  child: ValueListenableBuilder<int>(
                    builder: buildSelectButtons,
                    valueListenable: _selectedAssetTypeId,
                  ),
                )
            ),
          ],
        );

        break;

    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: LatterColor.primary),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("取消"),
          actions: _getActions(context),
          bottom: PreferredSize(
            child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
            ),
            preferredSize: Size.fromHeight(0.0),
          ),
        ),
        backgroundColor: LatterColor.white,
        body: Container(
          child: stack,
        ),
    );

  }

  // 表单提交
  Future<void> _post(BuildContext context) async {

    String fullText = _controller!.text;

    showLoading(context, "发布中...");

    var listAssets = [];
    if( assets.isNotEmpty ) {
      for( int i=0; i < assets.length; i++ ) {
        Future<File?> futureFile = assets[i].file;
        await futureFile.then((value) async {
          //listAssets.add( await MultipartFile.fromFile(value!.path) );
          // 解决 flutter: DioError [DioErrorType.DEFAULT]: HttpException: Content size exceeds specified contentLength.
          if( value?.path != null ) {

            String assetPath = value?.path ?? "";

            if( Utils.getExt(assetPath) == "mp4" || Utils.getExt(assetPath) == "mov") {
              // 不少人反映这个问题
              // https://github.com/jonataslaw/VideoCompress/issues/193
              MediaInfo? mediaInfo = await VideoCompressV2.compressVideo(
                  assetPath,
                  deleteOrigin: false,
                  includeAudio: false, // 不知道是啥意思，不加会报错
                  quality: VideoQuality.DefaultQuality
              );
              listAssets.add( MultipartFile.fromBytes(mediaInfo!.file!.readAsBytesSync(), filename: mediaInfo.path!.split("/").last));
            } else {

              // 照片压缩
              var result = await FlutterImageCompress.compressWithFile(
                assetPath,
                minWidth: 1080,
                quality: 65
              );
              listAssets.add( MultipartFile.fromBytes(result as List<int>, filename: assetPath.split("/").last));

              // listAssets.add( MultipartFile.fromBytes(File(assetPath).readAsBytesSync(), filename: assetPath.split("/").last));

            }

          }
        });
      }
    }

    int quoteId = 0;
    int quoteUid = 0;

    if( widget.model != null ) {
      quoteId = widget.model!.id!;
      quoteUid = widget.model!.uid!;
    }

    /**
     * widget.composeType 没有name属性，这里只好重新赋值给新的一个枚举对象
     */
    BlogType? type = widget.composeType ?? BlogType.BLOG;

    FormData formData = new FormData.fromMap({
      "fullText": fullText,
      "type" : type.name,
      "quoteId" : quoteId,
      "quoteUid" : quoteUid,
      "assets": listAssets,
    });
    var response = await DioWrapper().dio.post("/api/statuses/update", data: formData);

    // 关闭 Loading
    Navigator.pop(context);

    Map<String, dynamic> result = response.data;
    if(result["code"]==0) {
      // 关闭发布页
      Navigator.pop(context);

      Cw.showSnackBarV2(context, result["msg"]);

    } else {
      Cw.showSnackBarV2(context, result["msg"]);
    }

  }

  List<Widget> _getActions(BuildContext context) {
    return <Widget>[
      Padding(
        padding: EdgeInsets.all(10),
        child: ValueListenableBuilder<bool>(
          builder: _buildActionButtons,
          valueListenable: _isNullOfFullText,
        ),
      )
    ];
  }

  // Submit按钮区域
  Widget _buildActionButtons(BuildContext context, bool isNull, Widget? child) {
    return ElevatedButton(
      child: Text('发布', style: TextStyle(color: Colors.white)),
      onPressed: isNull ? null : () { _post(context); },
    );
  }

  // 图片和视频选择按钮
  Widget buildSelectButtons(BuildContext context, int assetTypeId, Widget? child) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(LatterIcon.photo),
          iconSize: 30,
          color: LatterColor.primary,
          onPressed: () async {
            if( assetTypeId==0 || assetTypeId==1 ) {
              bool result = await DialogPermission(context);
              if( result ) {
                selectAssets(PickMethod.image(9));
              }
            }
          },
        ),
        // IconButton(
        //   icon: const Icon(Icons.video_collection_outlined),
        //   color: ( assetTypeId==0 || assetTypeId==2 ) ? Colors.blue : Colors.grey,
        //   onPressed: () {
        //     if( assetTypeId==0 || assetTypeId==2 ) {
        //       selectAssets(PickMethod.video(1));
        //     }
        //   },
        // )
      ],
    );
  }

  void removeAsset(int index) {
    assets.removeAt(index);
    if (assets.isEmpty) {
      _selectedAssetTypeId.value = 0;
      // isDisplayingDetail.value = false;
    } else {
      AssetEntity entity = assets.elementAt(0);
      _selectedAssetTypeId.value = entity.typeInt; // 资源类型 1图片，2视频
    }
     setState(() {});
  }

  void onResult(List<AssetEntity>? result) {
    if (result != null && result != assets) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void>  selectAssets(PickMethod pickMethod) async {
    final List<AssetEntity>? result = await pickMethod.method(context, assets);
    if (result != null) {
      assets = List<AssetEntity>.from(result);
      AssetEntity entity = assets.elementAt(0);
      _selectedAssetTypeId.value = entity.typeInt;
      if (mounted) {
        setState(() {});
      }
    }
  }

}