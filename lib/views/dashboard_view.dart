import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:student/stores/main_store.dart';
import 'package:student/widgets/subject_card.dart';
import 'package:student/widgets/alert_banner.dart';
import 'package:student/models/course.dart';
import 'package:student/models/attendance_stats.dart';
import 'package:student/views/subject_details_view.dart';
import 'package:student/views/add_course_view.dart';
import 'package:student/views/voice_attendance_view.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatefulWidget {
  final MainStore mainStore;
  final VoidCallback onLogout;

  const DashboardView({
    Key? key,
    required this.mainStore,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    widget.mainStore.courseStore.loadCourses();
    widget.mainStore.attendanceStore.loadAttendanceRecords();
  }

  void _navigateToSubjectDetails(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectDetailsView(
          mainStore: widget.mainStore,
          course: course,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: _openVoiceAttendance,
            tooltip: 'Voice Attendance',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareOverallReport,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: Observer(
        builder: (context) {
          final courses = widget.mainStore.courseStore.courses;
          final isLoading = widget.mainStore.courseStore.isLoading ||
              widget.mainStore.attendanceStore.isLoading;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Find courses with low attendance
          final lowAttendanceCourses = courses.where((course) {
            final stats = widget.mainStore.attendanceStore.getStatsForCourse(course.id);
            return stats?.isBelowThreshold ?? false;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await widget.mainStore.courseStore.loadCourses();
              await widget.mainStore.attendanceStore.loadAttendanceRecords();
            },
            child: ListView(
              children: [
                // Alert banners for low attendance
                if (lowAttendanceCourses.isNotEmpty) ...[
                  AlertBanner(
                    message: 'You have ${lowAttendanceCourses.length} subject(s) with attendance below 75%',
                  ),
                  const SizedBox(height: 16),
                ],
                // Courses list
                if (courses.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No courses found. Add courses to get started.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...courses.map((course) {
                    final stats = widget.mainStore.attendanceStore.getStatsForCourse(course.id);
                    return SubjectCard(
                      course: course,
                      stats: stats,
                      onTap: () => _navigateToSubjectDetails(course),
                      onVoiceAttendance: () => _openVoiceAttendanceForCourse(course),
                    );
                  }).toList(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCourse,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCourseView(mainStore: widget.mainStore),
      ),
    );
  }

  Future<void> _shareOverallReport() async {
    try {
      final courses = widget.mainStore.courseStore.courses;
      final studentName = widget.mainStore.authService.studentName ?? 'Student';
      final studentId = widget.mainStore.authService.studentId ?? 'N/A';
      
      if (courses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No courses available to share'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      final reportText = _generateOverallReportText(courses, studentName, studentId);
      
      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: reportText));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Overall attendance report copied to clipboard! You can now paste it in any app to share.'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _generateOverallReportText(List<Course> courses, String studentName, String studentId) {
    final buffer = StringBuffer();
    buffer.writeln('📊 OVERALL ATTENDANCE REPORT');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('Student: $studentName');
    buffer.writeln('Student ID: $studentId');
    buffer.writeln('Generated: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}');
    buffer.writeln();
    
    buffer.writeln('📚 ALL SUBJECTS SUMMARY:');
    buffer.writeln('─────────────────────────');
    
    int totalOverallClasses = 0;
    int totalOverallPresent = 0;
    int lowAttendanceCount = 0;
    
    for (final course in courses) {
      final stats = widget.mainStore.attendanceStore.getStatsForCourse(course.id);
      if (stats != null) {
        buffer.writeln();
        buffer.writeln('📖 ${course.name} (${course.code})');
        buffer.writeln('   Instructor: ${course.instructor}');
        buffer.writeln('   Attendance: ${stats.percentage.toStringAsFixed(1)}%');
        buffer.writeln('   Present: ${stats.presentCount}/${stats.totalClasses}');
        buffer.writeln('   Absent: ${stats.absentCount}');
        buffer.writeln('   Leave: ${stats.leaveCount}');
        
        if (stats.isBelowThreshold) {
          buffer.writeln('   ⚠️ Below 75% threshold');
          lowAttendanceCount++;
        }
        
        totalOverallClasses += stats.totalClasses;
        totalOverallPresent += stats.presentCount;
      }
    }
    
    buffer.writeln();
    buffer.writeln('📈 OVERALL STATISTICS:');
    buffer.writeln('─────────────────────');
    
    final overallPercentage = totalOverallClasses > 0 ? (totalOverallPresent / totalOverallClasses) * 100 : 0.0;
    buffer.writeln('Total Classes: $totalOverallClasses');
    buffer.writeln('Total Present: $totalOverallPresent');
    buffer.writeln('Overall Attendance: ${overallPercentage.toStringAsFixed(1)}%');
    
    if (lowAttendanceCount > 0) {
      buffer.writeln();
      buffer.writeln('⚠️ WARNING: $lowAttendanceCount subject(s) below 75% threshold');
    }
    
    if (overallPercentage >= 75.0) {
      buffer.writeln('✅ Overall attendance meets minimum requirement');
    } else {
      buffer.writeln('❌ Overall attendance below minimum requirement');
    }
    
    buffer.writeln();
    buffer.writeln('Generated by Student Attendance System');
    
    return buffer.toString();
  }

  void _openVoiceAttendance() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VoiceAttendanceView(
          mainStore: widget.mainStore,
        ),
      ),
    );
    
    // Refresh data if attendance was marked
    if (result == true) {
      await widget.mainStore.attendanceStore.loadAttendanceRecords();
    }
  }

  void _openVoiceAttendanceForCourse(Course course) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VoiceAttendanceView(
          mainStore: widget.mainStore,
          selectedCourse: course,
        ),
      ),
    );
    
    // Refresh data if attendance was marked
    if (result == true) {
      await widget.mainStore.attendanceStore.loadAttendanceRecords();
    }
  }
}