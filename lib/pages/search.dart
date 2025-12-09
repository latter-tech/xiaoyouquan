import 'package:flutter/material.dart';
import '../common/widgets.dart';
import '../generated/l10n.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/blog_list_widget.dart';

/**
 * 搜索页
 */
class SearchPage extends StatefulWidget {
  SearchPage({
    Key? key
  }) : super(key: key);
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {

  late TextEditingController _keywordController;
  String keyword = "";

  @override
  void initState() {
    _keywordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingActionButton(context),
        appBar: AppBar(
            leading: Cw.appBarLeading(context),
            title: Container(
                height: 50,
                width: 300,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {
                      keyword = value;
                    });
                  },
                  controller: _keywordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                    hintText: S.of(context).search,
                    prefixIcon: Icon(Icons.search),
                    hintStyle: TextStyle(),
                    fillColor: Colors.black12,
                    filled: true,
                    focusColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  ),
                ))
        ),
        body: BlogListWidget(uid: 0, types: "BLOG,QUOTE", queryType: "search", keyword: keyword)
    );
  }

}