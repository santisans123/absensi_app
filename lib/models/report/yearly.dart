import 'package:spo_balaesang/utils/app_const.dart';

class Yearly {
  const Yearly({
    required this.attendancePercentage,
    required this.outstation,
    required this.absent,
    required this.lateCount,
    required this.absentPermission,
    required this.leaveEarlyCount,
    required this.earlyLunchBreakCount,
    required this.notComeAfterLunchBreakCount,
    required this.notMorningParadeCount,
    required this.annualLeave,
    required this.importantReasonLeave,
    required this.sickLeave,
    required this.maternityLeave,
    required this.outOfLiabilityLeave,
  });

  final double attendancePercentage;
  final int lateCount;
  final int leaveEarlyCount;
  final int notMorningParadeCount;
  final int earlyLunchBreakCount;
  final int notComeAfterLunchBreakCount;
  final Map<String, dynamic> absentPermission;
  final Map<String, dynamic> outstation;
  final Map<String, dynamic> absent;
  final Map<String, dynamic> annualLeave;
  final Map<String, dynamic> importantReasonLeave;
  final Map<String, dynamic> sickLeave;
  final Map<String, dynamic> maternityLeave;
  final Map<String, dynamic> outOfLiabilityLeave;

  factory Yearly.fromJson(Map<String, dynamic> json) {
    return Yearly(
        lateCount: json[reportLateCountField] as int,
        attendancePercentage:
            double.parse(json[reportAttendancePercentageFieldField].toString()),
        absent: json[yearlyAbsentField] as Map<String, dynamic>,
        absentPermission:
            json[yearlyAbsentPermissionField] as Map<String, dynamic>,
        outstation: json[yearlyOutstationField] as Map<String, dynamic>,
        leaveEarlyCount: json[reportLeaveEarlyFieldCountField] as int,
        notMorningParadeCount: json[reportNotMorningParadeCountField] as int,
        earlyLunchBreakCount: json[reportEarlyLunchBreakCountField] as int,
        notComeAfterLunchBreakCount:
            json[reportNotComeAfterLunchBreakCountField] as int,
        annualLeave: json[reportAnnualLeaveField] as Map<String, dynamic>,
        importantReasonLeave:
            json[reportImportantReasonLeaveField] as Map<String, dynamic>,
        sickLeave: json[reportSickLeaveField] as Map<String, dynamic>,
        maternityLeave: json[reportMaternityLeaveField] as Map<String, dynamic>,
        outOfLiabilityLeave:
            json[reportOutOfLiabilityLeaveField] as Map<String, dynamic>,);
  }
}
