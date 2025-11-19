import 'package:flutter_test/flutter_test.dart';
import 'package:student/models/attendance.dart';
import 'package:flutter/material.dart';

void main() {
  group('Attendance', () {
    test('fromJson creates Attendance object correctly', () {
      // Arrange
      final json = {
        'id': '1',
        'courseId': 'course1',
        'userId': 'user1',
        'date': '2023-01-01T00:00:00.000',
        'status': 'present',
        'note': 'Good student',
      };

      // Act
      final attendance = Attendance.fromJson(json);

      // Assert
      expect(attendance.id, '1');
      expect(attendance.courseId, 'course1');
      expect(attendance.userId, 'user1');
      expect(attendance.date, DateTime(2023, 1, 1));
      expect(attendance.status, AttendanceStatus.present);
      expect(attendance.note, 'Good student');
    });

    test('toJson converts Attendance object to JSON correctly', () {
      // Arrange
      final attendance = Attendance(
        id: '1',
        courseId: 'course1',
        userId: 'user1',
        date: DateTime(2023, 1, 1),
        status: AttendanceStatus.absent,
        note: 'Late arrival',
      );

      // Act
      final json = attendance.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['courseId'], 'course1');
      expect(json['userId'], 'user1');
      expect(json['date'], '2023-01-01T00:00:00.000');
      expect(json['status'], 'absent');
      expect(json['note'], 'Late arrival');
    });

    group('getStatusColor', () {
      test('returns green for present status', () {
        final color = Attendance.getStatusColor(AttendanceStatus.present);
        expect(color, Colors.green);
      });

      test('returns red for absent status', () {
        final color = Attendance.getStatusColor(AttendanceStatus.absent);
        expect(color, Colors.red);
      });

      test('returns orange for leave status', () {
        final color = Attendance.getStatusColor(AttendanceStatus.leave);
        expect(color, Colors.orange);
      });
    });
  });
}