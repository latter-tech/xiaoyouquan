
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../common/constants.dart';

class CacheImage extends StatelessWidget {
  const CacheImage({Key? key, this.path, this.fit = BoxFit.contain})
      : super(key: key);
  final String? path;
  final BoxFit fit;

  Widget customNetworkImage(String? path, {BoxFit fit = BoxFit.contain}) {
    return CachedNetworkImage(
      fit: fit,
      imageUrl: path ?? Constants.dummyProfileAvatar,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholderFadeInDuration: const Duration(milliseconds: 500),
      placeholder: (context, url) => Container(
        color: const Color(0xffeeeeee),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return customNetworkImage(path, fit: fit);
  }
}