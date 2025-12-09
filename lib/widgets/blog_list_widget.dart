import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/widgets/blog_view_widget.dart';
import 'package:provider/provider.dart';
import '../common/utils/easy_refresh_helper.dart';
import '../models/blog_model.dart';
import '../states/feed_state.dart';
import 'Keep_alive_wrapper.dart';

/**
 * 啦文列表页组件
 */
class BlogListWidget extends StatefulWidget {
  const BlogListWidget({
    Key? key,
    required this.uid,
    required String this.types,
    required String this.queryType,
    String this.keyword = "",
    int this.page = 1
  }) : super(key: key);

  final int uid;
  final String types;
  final String queryType;
  final String keyword;
  final int page;

  @override
  State<StatefulWidget> createState() => _BlogListWidget();
}

class _BlogListWidget extends State<BlogListWidget> {

  late EasyRefreshController _easyRefreshController;
  late int _nowPage;
  late List<BlogModel> _listBlog;
  late FeedState blogState;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController(
        controlFinishRefresh: true,
        controlFinishLoad: true
    );
    blogState = Provider.of<FeedState>(context, listen: false);
    _nowPage = widget.page;
    _listBlog = [];
    _initData();
  }

  @override
  void didUpdateWidget(BlogListWidget widget) {
    print("BlogListWidget didUpdateWidget");
    _initData();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    _nowPage = 1;
    List<BlogModel> listBlog = await blogState.userTimeline(widget.uid, widget.types, _nowPage, widget.queryType, 0, keyword: widget.keyword) ?? [];
    _listBlog = listBlog;
    this.setState(() { });
    // if( _listBlog.length < 10 ) {
    //   _easyRefreshController.finishLoad( IndicatorResult.noMore );
    // }
  }

  void _onLoad() async {
    await Future.delayed(const Duration(seconds: 1));
    _nowPage ++;
    List<BlogModel> listBlog = await blogState.userTimeline(widget.uid, widget.types, _nowPage, widget.queryType, 0, keyword: widget.keyword) ?? [];
    this.setState(() {
      if( _nowPage == 1 ) {
        _listBlog = listBlog;
      } else {
        _listBlog += listBlog;
      }
    });
    _easyRefreshController.finishLoad( listBlog.length < 10 ? IndicatorResult.noMore : IndicatorResult.success );
  }

  void remove(int index) {
    setState(() {
      _listBlog.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {

    return KeepAliveWrapper(
      // 这里去掉了了 EasyRefresh 上层的 SafeArea，不清楚有何影响
        child: EasyRefresh(
          controller: _easyRefreshController,
          header: EasyRefreshHelper.header(context),
          footer: EasyRefreshHelper.footer(context),
          onRefresh: () async { // 下拉加载
            if (!mounted) {
              return;
            }
            _initData();
            _easyRefreshController.finishRefresh();
            _easyRefreshController.resetFooter();
          },
          onLoad: () async { //上拉加载
            if (!mounted) {
              return;
            }
            _onLoad();
          },
          child: ListView.builder(
            padding: EdgeInsets.only(top:5.0),
            itemBuilder: (context, index) {
              return BlogViewWidget(isDetail: false, model: _listBlog[index], index: index, remove: remove);
            },
            itemCount: _listBlog.length,
          ),
        )
    );
  }

}