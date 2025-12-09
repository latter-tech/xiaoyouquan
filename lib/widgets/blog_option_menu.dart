import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/current_user.dart';
import '../common/functions.dart';
import '../generated/l10n.dart';
import '../models/blog_model.dart';
import '../states/feed_state.dart';

/**
 * 三个点
 */
class BlogOptionMenu extends StatefulWidget {
  const BlogOptionMenu({Key? key,
  required this.model,
  this.index,
  this.remove
  }) : super(key: key);

  final BlogModel? model;
  final int? index;
  final Function? remove;

  @override
  State<StatefulWidget> createState() => _BlogOptionMenu();
}

class _BlogOptionMenu  extends State<BlogOptionMenu> {

  @override
  void initState() {
    super.initState();
  }

  List<PopupMenuEntry<String>> getVisibleMenuItems() {
    List<PopupMenuEntry<String>> listMenuItes = [];
    listMenuItes.add(
        const PopupMenuItem<String>(
          value: "complaint",
          child: Text('投诉'),

        )
    );
    if( CurrentUser.instance.user!.uid == widget.model!.uid ) {
      listMenuItes.add(
          const PopupMenuItem<String>(
            value: "delete",
            child: Text('删除'),
          )
      );
    }
    return listMenuItes;
  }

  @override
  Widget build(BuildContext context) {
    FeedState blogState = Provider.of<FeedState>(context, listen: false);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 25.0
      ),
      child: PopupMenuButton<String>(
        padding: EdgeInsets.only(top: 0),
        onSelected: (String result) async {
          // 增加删除确认对话框
          if( result == "delete" ) {

            bool? confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(S.of(context).are_you_sure_want_to_delete_it),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(S.of(context).cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(S.of(context).confirm, style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
            if (confirm == true) {
              widget.remove!(widget.index);
              blogState.destroy(widget.model!.id);
            }
          }

          if( result == "complaint" ) {
            showComplaintDialog(context: context, blogId: widget.model!.id!, blogUid: widget.model!.uid!);
          }

        },
        color: Colors.white,
        icon: Icon(Icons.more_horiz),
        itemBuilder: (BuildContext context) => getVisibleMenuItems(),
      )
    );
  }

}