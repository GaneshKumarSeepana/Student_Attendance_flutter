import 'package:student/models/course.dart';
import 'package:flutter/material.dart';

enum AttendanceStatus { present, absent, leave }

class Attendance {
  final String id;
  final String courseId;
  final String userId;
  final DateTime date;
  final AttendanceStatus status;
  final String? note;

  Attendance({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.date,
    required this.status,
    this.note,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      courseId: json['courseId'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString() == 'AttendanceStatus.${json['status']}',
        orElse: () => AttendanceStatus.absent,
      ),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'user_id': userId,
      'date': date.millisecondsSinceEpoch,
      'status': status.toString().split('.').last,
      'note': note,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toMap() => toJson();
  
  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      courseId: map['course_id'],
      userId: map['user_id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => AttendanceStatus.absent,
      ),
      note: map['note'],
    );
  }

  // Helper method to get color based on status
  static Color getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.leave:
        return Colors.orange;
    }
  }
}