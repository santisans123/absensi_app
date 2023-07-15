import 'package:spo_balaesang/models/user.dart';
import 'package:spo_balaesang/utils/app_const.dart';

class PaidLeave {
  const PaidLeave(
      {required this.title,
        required this.id,
        required this.category,
        required this.photo,
        required this.approvalStatus,
        required this.description,
        required this.startDate,
        required this.dueDate,
        required this.isApproved,
        required this.user,});

  final int id;
  final String title;
  final String category;
  final String description;
  final bool isApproved;
  final String approvalStatus;
  final DateTime startDate;
  final DateTime dueDate;
  final String photo;
  final User user;

  factory PaidLeave.fromJson(Map<String, dynamic> json) => PaidLeave(
      id: json[paidLeaveIdField] as int,
      title: json[paidLeaveTitleField] as String,
      category: json[paidLeaveCategoryField] as String,
      description: json[paidLeaveDescriptionField] as String,
      isApproved: json[paidLeaveIsApprovedField] as bool,
      approvalStatus: json[approvalStatusField] as String,
      startDate: DateTime.parse(json[paidLeaveStartDateField].toString()),
      dueDate: DateTime.parse(json[paidLeaveDueDateField].toString()),
      photo: json[paidLeavePhotoField] as String,
      user: json[paidLeaveUserField] != null
          ? User.fromJson(json[paidLeaveUserField] as Map<String, dynamic>)
          : null,);
}
