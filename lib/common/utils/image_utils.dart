
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagesUtils {

  static CachedNetworkImage profileImage(String imageurl) {
    return CachedNetworkImage(
      imageUrl: imageurl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

}