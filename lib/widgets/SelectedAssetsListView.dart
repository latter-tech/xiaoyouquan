import 'package:com.xiaoyoushijie.app/common/widgets.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart' show AssetEntity, AssetPicker, AssetPickerViewer;

import 'AssetWidgetBuilder.dart';

class SelectedAssetsListView extends StatelessWidget {
  const SelectedAssetsListView({
    Key? key,
    required this.assets,
    required this.isDisplayingDetail,
    required this.onResult,
    required this.onRemoveAsset,
  }) : super(key: key);

  final List<AssetEntity> assets;
  final ValueNotifier<bool> isDisplayingDetail;
  final Function(List<AssetEntity>? result) onResult;
  final Function(int index) onRemoveAsset;

  // 单个资源
  Widget _selectedAssetWidget(BuildContext context, int index) {
    final AssetEntity asset = assets.elementAt(index);
    return ValueListenableBuilder<bool>(
      valueListenable: isDisplayingDetail,
      builder: (_, bool value, __) => GestureDetector(
        onTap: () async {
          if (value) {
            final List<AssetEntity>? result = await AssetPickerViewer.pushToViewer(
              context,
              currentIndex: index,
              previewAssets: assets,
              themeData: AssetPicker.themeData(Color.fromARGB(0xFF, 0x42, 0xA5, 0xF5)),
            );
            onResult(result);
          }
        },
        child: RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AssetWidgetBuilder(
              entity: asset,
              isDisplayingDetail: value,
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectedAssetDeleteButton(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => onRemoveAsset(index),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Theme.of(context).canvasColor.withOpacity(0.5),
        ),
        child: const Icon(Icons.close, size: 18.0),
      ),
    );
  }

  Widget selectedAssetsListView( BuildContext context ) {

    if ( assets.isEmpty ) {
        return Container();
    }
    AssetEntity entity = assets.elementAt(0);
    int _typeInt = entity.typeInt; // 资源类型 1图片，2视频

    if( _typeInt == 1 ) {
      return Expanded(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1
              ),
              itemCount: assets.length,
              itemBuilder: (BuildContext context,int index) {
                return AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(child: _selectedAssetWidget(context, index)),
                      ValueListenableBuilder<bool>(
                        valueListenable: isDisplayingDetail,
                        builder: (_, bool value, __) => AnimatedPositioned(
                          duration: kThemeAnimationDuration,
                          top: value ? 6.0 : -30.0,
                          right: value ? 6.0 : -30.0,
                          child: _selectedAssetDeleteButton(context, index),
                        ),
                      ),
                    ],
                  ),
                );
              }
          )
      );
    } else {
      return Container (
        width: Cw.fullWidth(context) - 20,
        child:AspectRatio(
          aspectRatio: 1.0,
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: _selectedAssetWidget(context, 0)),
              ValueListenableBuilder<bool>(
                valueListenable: isDisplayingDetail,
                builder: (_, bool value, __) => AnimatedPositioned(
                  duration: kThemeAnimationDuration,
                  top: value ? 6.0 : -30.0,
                  right: value ? 6.0 : -30.0,
                  child: _selectedAssetDeleteButton(context, 0),
                ),
              ),
            ],
          ),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDisplayingDetail,
      builder: (_, bool value, __) => Container(
        height: assets.isNotEmpty ? Cw.fullWidth(context) : 0,
        child: Column(
          children: <Widget>[
            selectedAssetsListView( context )
          ],
        ),
      ),
    );
  }
}
