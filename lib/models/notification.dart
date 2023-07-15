import 'package:spo_balaesang/utils/app_const.dart';

class UserNotification {
  const UserNotification(
      {required this.id,
      required this.notifiableId,
      required this.notifiableType,
      required this.data,
      required this.isRead,});

  final String id;
  final int notifiableId;
  final String notifiableType;
  final Map<String, dynamic> data;
  final bool isRead;

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
        id: json[notificationIdField] as String,
        notifiableId: json[notificationNotifiableIdField] as int,
        notifiableType: json[notificationNotifiableTypeField] as String,
        data: json[jsonDataField] as Map<String, dynamic>,
        isRead: json[notificationIsReadField] as bool,);
  }
}
