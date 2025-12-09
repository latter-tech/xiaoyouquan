import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../common/utils/time_utils.dart';
import '../common/widgets.dart';
import '../generated/l10n.dart';
import '../models/conversation_model.dart';
import '../states/message_state.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/text_styles.dart';
import 'messages_page.dart';

/**
 * 消息会话列表
 */
class ConversationsPage extends StatefulWidget {
  ConversationsPage({
    Key? key
  }) : super(key: key);
  _MessagesList createState() => _MessagesList();
}

class _MessagesList extends State<ConversationsPage> {

  TextEditingController _searchPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageState>().refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Cw.appBarLeading(context),
            title: Container(
                height: 50,
                width: 300,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextField(
                  onChanged: null,
                  controller: _searchPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                    hintText: S.of(context).search_messages,
                    prefixIcon: Icon(Icons.search),
                    fillColor: Colors.black12,
                    filled: true,
                    focusColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  ),
                ))
        ),
        body: Consumer<MessageState>(
          builder: (context, provider, child) {
            if ( provider.isLoading ) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if ( provider.items.isEmpty ) {
              return EmptyStateWidget(
                title: S.of(context).no_conversations_yet,
                subtitle: S.of(context).start_chatting_with_someone,
                icon: Icons.chat_bubble_outline,
              );
            }
            return EasyRefresh(
              onRefresh: () async => await provider.refreshData(),
              onLoad: () async => await provider.loadMoreData(),
              child: ListView.separated(
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  return _item(provider.items[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 1,
                    color: Colors.black12,
                  );
                },
              ),
            );
          },
        )
    );
  }

  Widget _item(ConversationModel model) {
    return ListTile(
      leading: Cw.customImage(context, model.user!.profileImageUrl),
      title: Row(
        children: [
          Text(model.user!.screenName!),
          Flexible(
            child: Text(
                " @${model.user!.username!}",
                style: TextStyles.userNameStyle,
                overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
      subtitle: Text(
        model.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            TimeUtils.format(context, model.lastTime),
            style: TextStyle(fontSize: 12, color: Colors.grey), // 可根据需要微调样式
          ),
          const SizedBox(height: 4), // 间距
          if (model.unreadCount > 0)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => MessagesPage(peerUser: model.user!, conversationId: model.id),
          ),
        );
        Future(() async {
          await context.read<MessageState>().markConversationAsRead(model.id);
        });
      }
    );
  }

}