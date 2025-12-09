
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// 自定义9宫格图片显示
class PhotoViewHelper extends StatefulWidget {
  const PhotoViewHelper({
    Key? key,
    required this.galleryItems,
  }) : super(key: key);

  final List<GalleryItemEntity> galleryItems;

  @override
  State<StatefulWidget> createState() => _PhotoViewHelper();

}

class _PhotoViewHelper extends State<PhotoViewHelper> {

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
        shrinkWrap:true,
        physics:NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: 1
        ),
        itemCount: widget.galleryItems.length,
        itemBuilder: (BuildContext context,int index) {
          return AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ViewFullScreen(
                    galleryItem: widget.galleryItems[index],
                    onTap: () {
                      open(context, index);
                    },
                  ),)
              ],
            ),
          );
        }
    );

    /*
    if( widget.galleryItems.length > 1 ) {

    } else { // 单图
      return GestureDetector(
        child: Hero(
          tag: '',
          child: Image.asset(
            widget.galleryItems[0].resource,
          ),
        ),
        onTap: () {
          open(context, 0);
        },
      );
    }
    */

  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: widget.galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: false ? Axis.vertical : Axis.horizontal,
        ),
      ),
    );
  }

}

// 显示大图
class ViewFullScreen extends StatelessWidget {

  final GalleryItemEntity galleryItem;
  final GestureTapCallback onTap;

  const ViewFullScreen({
    Key? key,
    required this.galleryItem,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: "full_screen_" + galleryItem.id,
          child: Image.network(galleryItem.large),
        ),
      ),
    );
  }

}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {

  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Image ${currentIndex + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryItemEntity item = widget.galleryItems[index];
    return item.isSvg
        ? PhotoViewGalleryPageOptions.customChild(
      child: Container(
        width: 300,
        height: 300,
        child: Image.network(
          item.large,
        ),
      ),
      childSize: const Size(300, 300),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    ) : PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.large),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }

}

// 实体类
class GalleryItemEntity {
  GalleryItemEntity({
    required this.id,
    required this.small,
    required this.large,
    this.isSvg = false,
  });

  final String id;
  final String small;
  final String large;
  final bool isSvg;
}