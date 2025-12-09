
import 'package:flutter/widgets.dart';
import 'package:com.xiaoyoushijie.app/widgets/photo_view_helper.dart';

class GalleryView extends StatelessWidget {

  const GalleryView({
    Key? key,
    required this.galleryViewItem,
    required this.onTap,
  }) : super(key: key);

  final GalleryItemEntity galleryViewItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryViewItem.id,
          child: Image.network(galleryViewItem.large),
        ),
      ),
    );
  }

}