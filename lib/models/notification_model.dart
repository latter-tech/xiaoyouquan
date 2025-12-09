
class NotificationModel {
  final int id;
  final String type;
  final int actorUid;
  final String actorNickname;
  final String actorAvatar;
  final String actorContent;
  final int sourceId;
  final int sourceUid;
  final String sourceType;
  final String sourcePreview;
  final int isRead;
  final DateTime createdAt;
  final int createdTimestamp;

  NotificationModel({
    required this.id,
    required this.type,
    required this.actorUid,
    required this.actorNickname,
    required this.actorAvatar,
    required this.actorContent,
    required this.sourceId,
    required this.sourceUid,
    required this.sourceType,
    required this.sourcePreview,
    required this.isRead,
    required this.createdAt,
    required this.createdTimestamp,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int,
      type: map['type'],
      actorUid: map['actorUid'] as int,
      actorNickname: map['actorNickname'],
      actorAvatar: map['actorAvatar'],
      actorContent: map['actorContent'] ?? "",
      sourceId: map['sourceId'] as int,
      sourceUid: map['sourceUid'] as int,
      sourceType: map['sourceType'],
      sourcePreview: map['sourcePreview'] ?? "",
      isRead: map['isRead'] as int,
      createdAt: DateTime.parse(map['createdAt']),
      createdTimestamp: map['createdTimestamp'],
    );
  }
}