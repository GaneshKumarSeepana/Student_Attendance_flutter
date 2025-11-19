import 'package:mobx/mobx.dart';
import 'package:student/models/attendance.dart';
import 'package:student/models/attendance_stats.dart';
import 'package:student/services/database_service.dart';

part 'attendance_store.g.dart';

class AttendanceStore = _AttendanceStore with _$AttendanceStore;

abstract class _AttendanceStore with Store {
  final DatabaseService _databaseService;
  String? _currentUserId;

  _AttendanceStore(this._databaseService) {
    loadAttendanceRecords();
  }

  @observable
  ObservableList<Attendance> attendanceRecords = ObservableList<Attendance>();

  @observable
  ObservableMap<String, AttendanceStats> attendanceStats = ObservableMap<String, AttendanceStats>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  String? selectedCourseId;

  // Set the current user ID to filter attendance records
  @action
  void setCurrentUserId(String? userId) {
    _currentUserId = userId;
    if (userId != null) {
      loadAttendanceRecords();
    } else {
      // Clear all data when user logs out
      attendanceRecords.clear();
      attendanceStats.clear();
    }
  }

  @action
  Future<void> initializeSampleData(List<String> courseIds) async {
    if (_currentUserId == null || attendanceRecords.isNotEmpty) return;

    // Generate sample attendance data for the last 30 days
    final now = DateTime.now();
    final random = [AttendanceStatus.present, AttendanceStatus.absent, AttendanceStatus.leave];
    
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      
      // Skip weekends
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        continue;
      }

      for (final courseId in courseIds) {
        // 80% chance of having class on any given day
        if (DateTime.now().millisecondsSinceEpoch % 5 != 0) {
          final status = random[DateTime.now().millisecondsSinceEpoch % 3];
          // Bias towards present (70% present, 20% absent, 10% leave)
          AttendanceStatus finalStatus;
          final rand = DateTime.now().millisecondsSinceEpoch % 10;
          if (rand < 7) {
            finalStatus = AttendanceStatus.present;
          } else if (rand < 9) {
            finalStatus = AttendanceStatus.absent;
          } else {
            finalStatus = AttendanceStatus.leave;
          }

          final attendance = Attendance(
            id: '${courseId}_${date.millisecondsSinceEpoch}',
            courseId: courseId,
            userId: _currentUserId!,
            date: date,
            status: finalStatus,
            note: finalStatus == AttendanceStatus.leave ? 'Medical leave' : null,
          );

          await _databaseService.insertAttendance(attendance);
        }
      }
    }

    // Reload attendance records
    await loadAttendanceRecords();
  }

  @action
  Future<void> loadAttendanceRecords() async {
    if (_currentUserId == null) return;
    
    isLoading = true;
    try {
      final allAttendance = await _databaseService.getAllAttendance();
      // Filter attendance records by current user
      final userAttendance = allAttendance.where((a) => a.userId == _currentUserId).toList();
      attendanceRecords = ObservableList.of(userAttendance);
      calculateAllStats();
    } catch (e) {
      print('Error loading attendance records: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> addAttendance(Attendance attendance) async {
    try {
      await _databaseService.insertAttendance(attendance);
      attendanceRecords.add(attendance);
      calculateStatsForCourse(attendance.courseId);
    } catch (e) {
      print('Error adding attendance: $e');
    }
  }

  @action
  Future<void> updateAttendance(Attendance attendance) async {
    try {
      await _databaseService.updateAttendance(attendance);
      final index = attendanceRecords.indexWhere((a) => a.id == attendance.id);
      if (index != -1) {
        attendanceRecords[index] = attendance;
      }
      calculateStatsForCourse(attendance.courseId);
    } catch (e) {
      print('Error updating attendance: $e');
    }
  }

  @action
  Future<void> deleteAttendance(String attendanceId) async {
    try {
      // Get the course ID before deleting
      final attendance = attendanceRecords.firstWhere((a) => a.id == attendanceId);
      final courseId = attendance.courseId;
      
      await _databaseService.deleteAttendance(attendanceId);
      attendanceRecords.removeWhere((a) => a.id == attendanceId);
      calculateStatsForCourse(courseId);
    } catch (e) {
      print('Error deleting attendance: $e');
    }
  }

  @action
  void calculateAllStats() {
    // Get all unique course IDs
    final courseIds = attendanceRecords.map((a) => a.courseId).toSet();
    
    // Calculate stats for each course
    for (final courseId in courseIds) {
      calculateStatsForCourse(courseId);
    }
    
    print('Calculated stats for ${courseIds.length} courses');
  }

  @action
  void calculateStatsForCourse(String courseId) {
    final courseAttendance = attendanceRecords.where((a) => a.courseId == courseId).toList();
    
    if (courseAttendance.isEmpty) {
      attendanceStats.remove(courseId);
      return;
    }
    
    final totalClasses = courseAttendance.length;
    final presentCount = courseAttendance.where((a) => a.status == AttendanceStatus.present).length;
    final absentCount = courseAttendance.where((a) => a.status == AttendanceStatus.absent).length;
    final leaveCount = courseAttendance.where((a) => a.status == AttendanceStatus.leave).length;
    
    final percentage = totalClasses > 0 ? (presentCount / totalClasses) * 100 : 0.0;
    final isBelowThreshold = percentage < 75.0;
    
    // Determine color status
    AttendanceColorStatus colorStatus;
    if (percentage > 75.0) {
      colorStatus = AttendanceColorStatus.good;
    } else if (percentage == 75.0) {
      colorStatus = AttendanceColorStatus.warning;
    } else {
      colorStatus = AttendanceColorStatus.critical;
    }
    
    attendanceStats[courseId] = AttendanceStats(
      courseId: courseId,
      percentage: percentage,
      totalClasses: totalClasses,
      presentCount: presentCount,
      absentCount: absentCount,
      leaveCount: leaveCount,
      isBelowThreshold: isBelowThreshold,
      colorStatus: colorStatus,
    );
    
    // Debug logging
    print('Stats updated for course $courseId: Total=$totalClasses, Present=$presentCount, Percentage=${percentage.toStringAsFixed(1)}%, Below75=${isBelowThreshold}');
  }

  // Changed from @computed to regular method
  ObservableList<Attendance> getAttendanceForCourse(String courseId) {
    return ObservableList.of(
      attendanceRecords.where((attendance) => attendance.courseId == courseId).toList()
    );
  }

  // Changed from @computed to regular method
  AttendanceStats? getStatsForCourse(String courseId) {
    return attendanceStats[courseId];
  }

  @action
  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  @action
  void setSelectedCourse(String? courseId) {
    selectedCourseId = courseId;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void setError(String error) {
    errorMessage = error;
  }

  // Mark attendance for a specific date and course
  @action
  Future<bool> markAttendance({
    required String courseId,
    required DateTime date,
    required AttendanceStatus status,
    String? note,
  }) async {
    if (_currentUserId == null) {
      setError('User not logged in');
      return false;
    }

    try {
      // Check if attendance already exists for this date and course
      final existingAttendance = attendanceRecords.where((a) =>
          a.courseId == courseId &&
          a.userId == _currentUserId &&
          _isSameDay(a.date, date)).toList();

      if (existingAttendance.isNotEmpty) {
        // Update existing attendance
        final updated = Attendance(
          id: existingAttendance.first.id,
          courseId: courseId,
          userId: _currentUserId!,
          date: date,
          status: status,
          note: note,
        );
        await updateAttendance(updated);
      } else {
        // Create new attendance record
        final attendance = Attendance(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          courseId: courseId,
          userId: _currentUserId!,
          date: date,
          status: status,
          note: note,
        );
        await addAttendance(attendance);
      }
      
      clearError();
      return true;
    } catch (e) {
      setError('Failed to mark attendance: $e');
      return false;
    }
  }

  // Get attendance for a specific date
  @computed
  List<Attendance> get attendanceForSelectedDate {
    return attendanceRecords
        .where((a) => _isSameDay(a.date, selectedDate))
        .toList();
  }

  // Get attendance for selected course
  @computed
  List<Attendance> get attendanceForSelectedCourse {
    if (selectedCourseId == null) return [];
    return attendanceRecords
        .where((a) => a.courseId == selectedCourseId)
        .toList();
  }

  // Get overall attendance statistics
  @computed
  AttendanceStats get overallStats {
    if (attendanceRecords.isEmpty) {
      return AttendanceStats.create(
        courseId: 'overall',
        percentage: 0.0,
        totalClasses: 0,
        presentCount: 0,
        absentCount: 0,
        leaveCount: 0,
        isBelowThreshold: true,
      );
    }

    final totalClasses = attendanceRecords.length;
    final presentCount = attendanceRecords
        .where((a) => a.status == AttendanceStatus.present)
        .length;
    final absentCount = attendanceRecords
        .where((a) => a.status == AttendanceStatus.absent)
        .length;
    final leaveCount = attendanceRecords
        .where((a) => a.status == AttendanceStatus.leave)
        .length;

    final percentage = totalClasses > 0 ? (presentCount / totalClasses) * 100 : 0.0;

    return AttendanceStats.create(
      courseId: 'overall',
      percentage: percentage,
      totalClasses: totalClasses,
      presentCount: presentCount,
      absentCount: absentCount,
      leaveCount: leaveCount,
      isBelowThreshold: percentage < 75.0,
    );
  }

  // Get courses with low attendance
  @computed
  List<String> get lowAttendanceCourses {
    return attendanceStats.entries
        .where((entry) => entry.value.isBelowThreshold)
        .map((entry) => entry.key)
        .toList();
  }

  // Get attendance for date range
  List<Attendance> getAttendanceForDateRange(DateTime start, DateTime end) {
    return attendanceRecords
        .where((a) => a.date.isAfter(start.subtract(const Duration(days: 1))) &&
                     a.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  // Get monthly attendance statistics
  Map<String, AttendanceStats> getMonthlyStats(int year, int month) {
    final monthlyAttendance = attendanceRecords
        .where((a) => a.date.year == year && a.date.month == month)
        .toList();

    final Map<String, AttendanceStats> monthlyStats = {};
    final courseIds = monthlyAttendance.map((a) => a.courseId).toSet();

    for (final courseId in courseIds) {
      final courseAttendance = monthlyAttendance
          .where((a) => a.courseId == courseId)
          .toList();

      if (courseAttendance.isNotEmpty) {
        final totalClasses = courseAttendance.length;
        final presentCount = courseAttendance
            .where((a) => a.status == AttendanceStatus.present)
            .length;
        final absentCount = courseAttendance
            .where((a) => a.status == AttendanceStatus.absent)
            .length;
        final leaveCount = courseAttendance
            .where((a) => a.status == AttendanceStatus.leave)
            .length;

        final percentage = totalClasses > 0 ? (presentCount / totalClasses) * 100 : 0.0;

        monthlyStats[courseId] = AttendanceStats.create(
          courseId: courseId,
          percentage: percentage,
          totalClasses: totalClasses,
          presentCount: presentCount,
          absentCount: absentCount,
          leaveCount: leaveCount,
          isBelowThreshold: percentage < 75.0,
        );
      }
    }

    return monthlyStats;
  }

  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}