
import 'package:dashed_rect/dashed_rect.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:com.xiaoyoushijie.app/pages/profile.dart';
import 'package:provider/provider.dart';
import '../common/utils.dart';
import '../common/utils/time_utils.dart';
import '../common/widgets.dart';
import '../generated/l10n.dart';
import '../models/notification_model.dart';
import '../states/notification_state.dart';
import '../widgets/empty_state_widget.dart';

/**
 * 通知
 */
class NotificationsPage extends StatefulWidget {
  NotificationsPage({
    Key? key
  }) : super(key: key);
  _NotificationsPage createState() => _NotificationsPage();
}

class _NotificationsPage extends State<NotificationsPage> {

  late NotificationState notificationState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationState>().refreshData();
      context.read<NotificationState>().markAllNotificationsAsRead();
    });
  }

  String _buildMessage(NotificationModel n) {
    switch (n.type) {
      case 'LIKE':
        return ' 点赞了你的啦文';
      case 'QUOTE':
        return ' 引用了你的啦文';
      case 'REPLY':
        return ' 评论了你的啦文';
      case 'FOLLOW':
        return ' 关注了你';
      default:
        return ' did something';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Cw.appBarLeading(context),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Cw.customTitleText(S.of(context).notifications),
                SizedBox(width: 55)
              ],
            )
        ),
        body: Consumer<NotificationState>(
          builder: (context, provider, child) {
            if ( provider.isLoading ) {
              return Center(
                child: CircularProgressIndicator()
              );
            }
            if( provider.items.isEmpty ) {
              return EmptyStateWidget(
                title: S.of(context).no_notification_available_yet,
                subtitle: S.of(context).when_new_notification_found,
                icon: Icons.notifications_none
              );
            }
            return EasyRefresh(
                header: ClassicHeader(),
                footer: ClassicFooter(),
                onRefresh: () async => await provider.refreshData(),
                onLoad: () async => await provider.refreshData(),
                child: ListView.separated(
                itemCount: provider.items.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
                itemBuilder: (context, index) {
                  final n = provider.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => Profile(profileUid: n.actorUid),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(n.actorAvatar),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: n.actorNickname,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: ' ${_buildMessage(n)}'),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            TimeUtils.format(context, n.createdAt),
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (n.actorContent.isNotEmpty && n.type != 'FOLLOW')
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                n.actorContent,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          if (n.sourcePreview.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Container(
                                width: double.infinity, // 占满整行
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                                child: DashedRect(
                                  color: Colors.black38,
                                  strokeWidth: 1.0,
                                  gap: 5.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Text(
                                      n.sourcePreview,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  )
                                ),
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        if( n.sourceId > 0 ) {
                          Utils.gotoBlogDetail(context, n.sourceId);
                        }
                      },
                    ),
                  );
                },
              )
            );
        },
      ),
    );
  }
}