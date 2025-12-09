
import 'package:com.xiaoyoushijie.app/models/user_model.dart';

class MessageModel {
  final int id;
  final int conversationId;
  final int senderUid;
  final int receiverUid;
  final String content;
  final String? attachmentUrl;
  final String? messageType;
  final bool isRead;
  final bool isRevoked;
  final bool deleted;
  final DateTime createdAt;
  final int createdTimestamp;
  final UserModel? userModel;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderUid,
    required this.receiverUid,
    required this.content,
    this.attachmentUrl,
    this.messageType,
    required this.isRead,
    required this.isRevoked,
    required this.deleted,
    required this.createdAt,
    required this.createdTimestamp,
    this.userModel
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      conversationId: json['conversationId'],
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      content: json['content'],
      attachmentUrl: json['attachmentUrl'],
      messageType: json['messageType'],
      isRead: json['isRead'] == 1,
      isRevoked: json['isRevoked'] == 1,
      deleted: json['deleted'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
      createdTimestamp:json['createdTimestamp'],
    );
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as int,
      conversationId: map['conversationId'] as int,
      senderUid: map['senderUid'] as int,
      receiverUid: map['receiverUid'] as int,
      content: map['content'] ?? '',
      attachmentUrl: map['attachmentUrl'],
      messageType: map['messageType'],
      isRead: (map['isRead'] ?? 0) == 1,
      isRevoked: (map['isRevoked'] ?? 0) == 1,
      deleted: (map['deleted'] ?? 0) == 1,
      createdAt: DateTime.parse(map['createdAt']),
      createdTimestamp: map['createdTimestamp'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'content': content,
      'attachmentUrl': attachmentUrl,
      'messageType': messageType,
      'isRead': isRead ? 1 : 0,
      'isRevoked': isRevoked ? 1 : 0,
      'deleted': deleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'createdTimestamp': createdTimestamp,
    };
  }
}
