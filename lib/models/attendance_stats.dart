enum AttendanceColorStatus {
  good,     // > 75% - Green
  warning,  // = 75% - Yellow  
  critical, // < 75% - Red
}

class AttendanceStats {
  final String courseId;
  final double percentage;
  final int totalClasses;
  final int presentCount;
  final int absentCount;
  final int leaveCount;
  final bool isBelowThreshold;
  final AttendanceColorStatus colorStatus;

  AttendanceStats({
    required this.courseId,
    required this.percentage,
    required this.totalClasses,
    required this.presentCount,
    required this.absentCount,
    required this.leaveCount,
    required this.isBelowThreshold,
    required this.colorStatus,
  });

  // Helper factory constructor that automatically determines color status
  factory AttendanceStats.create({
    required String courseId,
    required double percentage,
    required int totalClasses,
    required int presentCount,
    required int absentCount,
    required int leaveCount,
    required bool isBelowThreshold,
  }) {
    AttendanceColorStatus colorStatus;
    if (percentage > 75) {
      colorStatus = AttendanceColorStatus.good;
    } else if (percentage == 75) {
      colorStatus = AttendanceColorStatus.warning;
    } else {
      colorStatus = AttendanceColorStatus.critical;
    }

    return AttendanceStats(
      courseId: courseId,
      percentage: percentage,
      totalClasses: totalClasses,
      presentCount: presentCount,
      absentCount: absentCount,
      leaveCount: leaveCount,
      isBelowThreshold: isBelowThreshold,
      colorStatus: colorStatus,
    );
  }

  factory AttendanceStats.fromJson(Map<String, dynamic> json) {
    return AttendanceStats(
      courseId: json['courseId'],
      percentage: json['percentage'].toDouble(),
      totalClasses: json['totalClasses'],
      presentCount: json['presentCount'],
      absentCount: json['absentCount'],
      leaveCount: json['leaveCount'],
      isBelowThreshold: json['isBelowThreshold'],
      colorStatus: AttendanceColorStatus.values[json['colorStatus'] ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'percentage': percentage,
      'totalClasses': totalClasses,
      'presentCount': presentCount,
      'absentCount': absentCount,
      'leaveCount': leaveCount,
      'isBelowThreshold': isBelowThreshold,
      'colorStatus': colorStatus.index,
    };
  }
}