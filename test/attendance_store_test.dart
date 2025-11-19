import 'package:flutter_test/flutter_test.dart';
import 'package:student/models/attendance.dart';
import 'package:student/stores/attendance_store.dart';
import 'package:student/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('AttendanceStore', () {
    late AttendanceStore attendanceStore;

    setUp(() {
      // Initialize FFI database for testing
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      
      // Using a real DatabaseService for simplicity in this test
      final databaseService = DatabaseService();
      attendanceStore = AttendanceStore(databaseService);
      attendanceStore.setCurrentUserId('user1');
    });

    group('calculateStatsForCourse', () {
      test('calculates correct stats for course with attendance records', () {
        // Arrange
        final attendanceRecords = [
          Attendance(
            id: '1',
            courseId: 'course1',
            userId: 'user1',
            date: DateTime(2023, 1, 1),
            status: AttendanceStatus.present,
          ),
          Attendance(
            id: '2',
            courseId: 'course1',
            userId: 'user1',
            date: DateTime(2023, 1, 2),
            status: AttendanceStatus.present,
          ),
          Attendance(
            id: '3',
            courseId: 'course1',
            userId: 'user1',
            date: DateTime(2023, 1, 3),
            status: AttendanceStatus.absent,
          ),
          Attendance(
            id: '4',
            courseId: 'course1',
            userId: 'user1',
            date: DateTime(2023, 1, 4),
            status: AttendanceStatus.leave,
          ),
        ];

        // Add records to the store
        for (var attendance in attendanceRecords) {
          attendanceStore.attendanceRecords.add(attendance);
        }

        // Act
        attendanceStore.calculateStatsForCourse('course1');

        // Assert
        final stats = attendanceStore.getStatsForCourse('course1');
        expect(stats, isNotNull);
        expect(stats!.courseId, 'course1');
        expect(stats.totalClasses, 4);
        expect(stats.presentCount, 2);
        expect(stats.absentCount, 1);
        expect(stats.leaveCount, 1);
        expect(stats.percentage, 50.0); // 2 present out of 4 total
        expect(stats.isBelowThreshold, isTrue); // 50% is below 75% threshold
      });

      test('calculates 100% attendance when all records are present', () {
        // Arrange
        final attendanceRecords = [
          Attendance(
            id: '1',
            courseId: 'course1',
            userId: 'user1',
            date: DateTime(2023, 1, 1),
            status: AttendanceStatus.present,
          ),
          Attendance(
            id: '2',
            courseId: 'course1',
            userId: 'user1',
            date: DateTime(2023, 1, 2),
            status: AttendanceStatus.present,
          ),
        ];

        // Add records to the store
        for (var attendance in attendanceRecords) {
          attendanceStore.attendanceRecords.add(attendance);
        }

        // Act
        attendanceStore.calculateStatsForCourse('course1');

        // Assert
        final stats = attendanceStore.getStatsForCourse('course1');
        expect(stats, isNotNull);
        expect(stats!.percentage, 100.0);
        expect(stats.isBelowThreshold, isFalse);
      });

      test('removes stats when no attendance records exist', () {
        // Act
        attendanceStore.calculateStatsForCourse('course1');

        // Assert
        final stats = attendanceStore.getStatsForCourse('course1');
        expect(stats, isNull);
      });
    });

    group('calculateAllStats', () {
      test('calculates stats for all courses', () {
        // Arrange
        final attendanceRecords = [
          Attendance(
            id: '1',
            courseId: 'course1',
            userId: 'user1',
            date: DateTime(2023, 1, 1),
            status: AttendanceStatus.present,
          ),
          Attendance(
            id: '2',
            courseId: 'course1',
            userId: 'user1',
            date: DateTime(2023, 1, 2),
            status: AttendanceStatus.absent,
          ),
          Attendance(
            id: '3',
            courseId: 'course2',
            userId: 'user1',
            date: DateTime(2023, 1, 1),
            status: AttendanceStatus.present,
          ),
          Attendance(
            id: '4',
            courseId: 'course2',
            userId: 'user1',
            date: DateTime(2023, 1, 2),
            status: AttendanceStatus.present,
          ),
        ];

        // Add records to the store
        for (var attendance in attendanceRecords) {
          attendanceStore.attendanceRecords.add(attendance);
        }

        // Act
        attendanceStore.calculateAllStats();

        // Assert
        final stats1 = attendanceStore.getStatsForCourse('course1');
        final stats2 = attendanceStore.getStatsForCourse('course2');
        
        expect(stats1, isNotNull);
        expect(stats2, isNotNull);
        expect(stats1!.courseId, 'course1');
        expect(stats2!.courseId, 'course2');
      });
    });
  });
}