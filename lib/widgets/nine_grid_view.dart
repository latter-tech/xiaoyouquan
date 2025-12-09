import 'package:flutter/material.dart';
import 'dart:math' as math;

// 九宫格显示图片
class NineGridView extends StatefulWidget {

  NineGridView({
    Key? key,
    this.isRepostBlogImage,
    this.width,
    this.height,
    this.space = 3,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.alignment,
    this.color,
    this.decoration,
    required this.itemCount,
    required this.itemBuilder,
    this.bigImageWidth,
    this.bigImageHeight,
    this.bigImage,
    this.bigImageUrl,
  }) : super(key: key);

  // 是否转发图片
  final bool? isRepostBlogImage;

  /// View width.
  final double? width;

  /// View height.
  final double? height;

  /// The number of logical pixels between each child.
  final double space;

  /// View padding.
  final EdgeInsets padding;

  /// View margin.
  final EdgeInsets margin;

  /// Align the [child] within the container.
  final AlignmentGeometry? alignment;

  /// The color to paint behind the [child].
  final Color? color;

  /// The decoration to paint behind the [child].
  final Decoration? decoration;

  /// The total number of children this delegate can provide.
  final int itemCount;

  /// Called to build children for the view.
  final IndexedWidgetBuilder itemBuilder;

  /// Single big picture width.
  final int? bigImageWidth;

  /// Single big picture height.
  final int? bigImageHeight;

  /// It is recommended to use a medium-quality picture, because the original picture is too large and takes time to load.
  /// 单张大图建议使用中等质量图片，因为原图太大加载耗时。
  /// Single big picture Image.
  final Image? bigImage;

  /// Single big picture url.
  final String? bigImageUrl;

  @override
  State<StatefulWidget> createState() {
    return _NineGridView();
  }

}

class _NineGridView extends State<NineGridView> {
  @override
  Widget build(BuildContext context) {
    Rect rect = _rect(context);
    Widget? child = _buildChild(context, rect.left);
    return Container(
      alignment: widget.alignment,
      color: widget.color,
      decoration: widget.decoration,
      margin: widget.margin,
      padding: widget.padding,
      width: rect.right,
      height: rect.bottom,
      child: child,
    );
  }

  // itemW 图片宽度
  Widget _buildChild(BuildContext context, double itemW) {

    int itemCount = math.min(9, widget.itemCount);
    double space = widget.space;
    int column = itemCount == 4 ? 2 : 3;

    List<Widget> list = [];
    for (int i = 0; i < itemCount; i++) {

      list.add(Positioned(
          top: (space + itemW) * (i ~/ column),  // ~/ 整除 3 ~/ 2 = 1
          left: (space + itemW) * (i % column),
          child: SizedBox(
            width: itemW,
            height: itemW,
            child: widget.itemBuilder(context, i),
          )));
    }

    return Stack(
      children: list,
    );
  }

  Rect _rect(BuildContext context) {
    int itemCount = math.min(9, widget.itemCount);
    EdgeInsets padding = widget.padding;
    if (itemCount == 0) {
      return Rect.fromLTRB(0, 0, padding.horizontal, padding.vertical);
    }

    // 图片区域宽度
    double width = widget.width ?? (MediaQuery.of(context).size.width - widget.margin.horizontal);
    width = width - padding.horizontal;
    if( widget.isRepostBlogImage == true ) {
      width = width - 12;
    }
    double space = widget.space;
    double itemW;
    if ( itemCount == 1 || itemCount == 2 || itemCount == 4 ) {
      itemW = (width - space) / 2;
    } else {
      itemW = (width - space * 2) / 3;
    }
    //bool fourGrid = (itemCount == 4 && widget.type != NineGridType.normal);
    bool fourGrid = itemCount == 4;
    int column = fourGrid ? 2 : math.min(3, itemCount);

    int row = fourGrid ? 2 : (itemCount / 3).ceil();
    double realWidth = itemW * column + space * (column - 1) + padding.horizontal;
    double realHeight = itemW * row + space * (row - 1) + padding.vertical;
    return Rect.fromLTRB(itemW, 0, realWidth, realHeight);
  }

}