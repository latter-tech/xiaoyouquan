import 'dart:math';
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/widgets/photo_view_helper.dart';
import '../models/blog_asset_model.dart';
import '../models/blog_model.dart';
import 'nine_grid_view.dart';

/**
 * 图片显示组件
 */
class BlogImageWidget extends StatefulWidget {
  BlogImageWidget({
    Key? key,
    required this.model,
    required this.isQuote
  }) : super(key: key);

  final BlogModel model;
  final bool isQuote;

  @override
  State<StatefulWidget> createState() => _BlogImageWidget();
}

class _BlogImageWidget extends State<BlogImageWidget> {

  List<GalleryItemEntity> galleryViewItems = <GalleryItemEntity>[];

  @override
  Widget build(BuildContext context) {

    List<BlogAssetModel> listBlogAsset = widget.model.assets! as List<BlogAssetModel>;
    galleryViewItems = [];
    for(BlogAssetModel item in listBlogAsset) {
      // 防止 Hero widget tag 重复
      String tagId = 'Tag_${item.id}_' +  (new Random()).nextInt(9999999).toString();
      galleryViewItems.add( GalleryItemEntity(id: tagId,  small: '${item.small}', large: '${item.large}') );
    }

    return ConstrainedBox(
        constraints: BoxConstraints(
            //minWidth: MediaQuery.of(context).size.width - 70,
            maxHeight: MediaQuery.of(context).size.width
        ),
        child: NineGridView(
          isRepostBlogImage: widget.isQuote,
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(5),
          space: 0.5,
          width: MediaQuery.of(context).size.width-70,
          itemCount: galleryViewItems.length,
          alignment: Alignment.topLeft,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 0.5),
              child: GestureDetector(
                onTap: () { open(this.context, index); },
                child: Hero(
                  tag: galleryViewItems[index].id,  // 同一个页面中，这个tag不能重名
                  child: Image.network(
                      galleryViewItems[index].small
                  ),
                ),
              ),
            );
          },
        ));
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryViewItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

}