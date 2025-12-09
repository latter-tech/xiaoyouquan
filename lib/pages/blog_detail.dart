import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/app_color.dart';
import '../models/blog_model.dart';
import '../states/feed_state.dart';
import '../widgets/blog_view_widget.dart';

/**
 * 啦文详情页
 * isFromQuote 是否点击的是引用区域
 */
class BlogDetail extends StatefulWidget {
  const BlogDetail({
    Key? key,
    required this.model,
    this.index,
    this.remove
  }): super(key: key);

  final BlogModel model;
  final int? index;
  final Function? remove;

  @override
  State<StatefulWidget> createState() => _BlogDetail();
}

class _BlogDetail extends State<BlogDetail> {

  ScrollController _scrollController = ScrollController();
  late FeedState blogState;
  late int _nowPage;
  late List<BlogModel> _listBlog;

  @override
  void initState() {
    blogState = Provider.of<FeedState>(context, listen: false);
    _nowPage = 1;
    _listBlog = [];
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _nowPage ++;
        _loadMore();
      }
    });
    _loadMore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: LatterColor.primary),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("帖子"),
        actions: null,
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(0.0),
        ),
      ),
      backgroundColor: LatterColor.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: ScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
                child: BlogViewWidget(isDetail: true, model: widget.model, index: widget.index, remove: widget.remove)
            ),
            SliverToBoxAdapter(child: SizedBox(height: 15.0)),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                        (_, index) =>
                            BlogReplyWidget(isDetail: false, model: _listBlog[index], index: index, remove: remove),
                    childCount: _listBlog.length)
            ),
          ],
        )
      )

    );

  }

  void _loadMore() async {
    await Future.delayed(Duration(seconds: 1));
    List<BlogModel> listBlog = await blogState.userTimeline(0, "", _nowPage, "reply", widget.model.id ?? 0) ?? [];
    setState(() {
      if( _nowPage == 1 ) {
        _listBlog = listBlog;
      } else {
        _listBlog += listBlog;
      }
    });
  }

  Future<Null> _onRefresh() async {
    print("_onRefresh");
  }

  void remove(int index) {
    setState(() {
      _listBlog.removeAt(index);
    });
  }

}