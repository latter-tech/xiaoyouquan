
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../../generated/l10n.dart';

class EasyRefreshHelper {

  static ClassicHeader header(BuildContext context) {
    return ClassicHeader(
      dragText: S.of(context).pullToRefresh,
      armedText: S.of(context).pullToRefresh,
      readyText: S.of(context).refreshing,
      processingText: S.of(context).refreshing,
      processedText: S.of(context).refreshCompleted,
      failedText: S.of(context).refreshFailed,
      noMoreText: S.of(context).noMore,
      messageText: S.of(context).last_updated_at,
      textStyle: TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

  static ClassicFooter footer(BuildContext context) {
    return ClassicFooter(
      dragText: S.of(context).pullToRefresh,
      armedText: S.of(context).pullToRefresh,
      readyText: S.of(context).refreshing,
      processingText: S.of(context).refreshing,
      processedText: S.of(context).refreshCompleted,
      failedText: S.of(context).refreshFailed,
      noMoreText: S.of(context).noMore,
      messageText: S.of(context).last_updated_at,
      textStyle: TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

}