import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:com.xiaoyoushijie.app/models/message_model.dart';
import 'package:provider/provider.dart';
import '../common/app_color.dart';
import '../common/current_user.dart';
import '../common/utils/time_utils.dart';
import '../common/widgets.dart';
import '../models/user_model.dart';
import '../states/message_state.dart';
import '../widgets/CircularImage.dart';
import '../widgets/url_text.dart';

/**
 * 显示消息对话
 */
class MessagesPage extends StatefulWidget {
  MessagesPage({
    Key? key,
    required this.peerUser,
    this.conversationId = 0
  }) : super(key: key);
  final UserModel peerUser;
  int conversationId;
  _MessageDetail createState() => _MessageDetail();
}

class _MessageDetail extends State<MessagesPage> {

  final _listenable = IndicatorStateListenable();
  late TextEditingController _messageController;
  late MessageState messateState;

  bool _shrinkWrap = false;
  double? _viewportDimension;

  final ValueNotifier<bool> _isNullInputField = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _listenable.addListener(_onHeaderChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageState>().refreshData4Message(conversationId: widget.conversationId, peerUid: widget.peerUser.uid!);
    });
  }

  @override
  void dispose() {
    _listenable.removeListener(_onHeaderChange);
    _messageController.dispose();
    super.dispose();
  }

  void _onHeaderChange() {
    final state = _listenable.value;
    if (state != null) {
      final position = state.notifier.position;
      _viewportDimension ??= position.viewportDimension;
      final shrinkWrap = state.notifier.position.maxScrollExtent == 0;
      if (_shrinkWrap != shrinkWrap &&
          _viewportDimension == position.viewportDimension) {
        setState(() {
          _shrinkWrap = shrinkWrap;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Cw.customTitleText(widget.peerUser.screenName),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: Consumer<MessageState>(
                builder: (context, provider, child) {
                    if (provider.isLoadingMessage) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return EasyRefresh(
                      clipBehavior: Clip.none,
                      header: ClassicHeader(),
                      onRefresh: () async => await provider.refreshData4Message(),
                      onLoad: () async => await provider.loadMoreData4Message(),
                      child: CustomScrollView(
                        reverse: true,
                        shrinkWrap: true,
                        clipBehavior: Clip.none,
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                return _chat(provider.items4Message[index]);
                              },
                              childCount: provider.items4Message.length,
                            ),
                          ),
                        ],
                      ),
                    );
                    },
                ),
            ),
            _bottomInputField()
          ],
        )
    );
  }

  Widget _bottomInputField() {

    final MessageState messateState = Provider.of<MessageState>(context, listen: false);

    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 15),
          const Divider(
            thickness: 0,
            height: 1,
          ),
          TextField(
            textInputAction: TextInputAction.newline,
            maxLines: 5,
            minLines: 1,
            onChanged: (text) {
              if( text.isNotEmpty ) {
                _isNullInputField.value = false;
              } else {
                _isNullInputField.value = true;
              }
            },
            controller: _messageController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              alignLabelWithHint: true,
              hintText: '消息内容',
              suffixIcon: ValueListenableBuilder<bool>(
                builder: (BuildContext context, bool isNull, Widget? child) {
                  if( isNull ) {
                    return IconButton(
                        icon: const Icon(Icons.send_sharp, color: Colors.black12),
                        onPressed: null
                    );
                  } else {
                    return IconButton(
                        icon: const Icon(Icons.send_sharp, color: LatterColor.primary),
                        onPressed: () async {
                          await messateState.sendMessage(widget.peerUser.uid!, _messageController.value.text);
                          _messageController.clear();
                          Future(() {
                            PrimaryScrollController.of(context).jumpTo(0);
                          });
                        }
                    );
                  }
                },
                valueListenable: _isNullInputField,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chat(MessageModel mm) {
    return Column(
      crossAxisAlignment: mm.senderUid == CurrentUser.instance.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: mm.senderUid == CurrentUser.instance.uid  ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(
              width: 15,
            ),
            mm.senderUid == CurrentUser.instance.uid ? const SizedBox() : CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: customAdvanceNetworkImage(widget.peerUser.profileImageUrl),
            ),
            Expanded(
              child: Container(
                alignment:
                mm.senderUid == CurrentUser.instance.uid ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: mm.senderUid == CurrentUser.instance.uid ? 10 : (Cw.fullWidth(context) / 4),
                  top: 20,
                  left: mm.senderUid == CurrentUser.instance.uid ? (Cw.fullWidth(context) / 4) : 10,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: getBorder( mm.senderUid == CurrentUser.instance.uid ),
                        color: mm.senderUid == CurrentUser.instance.uid
                            ? LatterColor.primary
                            : LatterColor.lightBackground,
                      ),
                      child: UrlText(
                        text: mm.content,
                        style: TextStyle(
                          fontSize: 16,
                          color: mm.senderUid == CurrentUser.instance.uid ? LatterColor.white : Colors.black,
                        ),
                        urlStyle: TextStyle(
                          fontSize: 16,
                          color: mm.senderUid == CurrentUser.instance.uid
                              ? LatterColor.white
                              : LatterColor.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Text(
            TimeUtils.format( context, mm.createdAt ),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
          ),
        )
      ],
    );
  }

  BorderRadius getBorder(bool myMessage) {
    return BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomRight:
      myMessage ? const Radius.circular(0) : const Radius.circular(20),
      bottomLeft:
      myMessage ? const Radius.circular(20) : const Radius.circular(0),
    );
  }

}