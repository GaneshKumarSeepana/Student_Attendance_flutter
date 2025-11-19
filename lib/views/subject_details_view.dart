import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:student/stores/main_store.dart';
import 'package:student/models/course.dart';
import 'package:student/models/attendance.dart';
import 'package:student/models/attendance_stats.dart';
import 'package:student/widgets/calendar_view.dart';
import 'package:student/widgets/attendance_card.dart';
import 'package:student/widgets/percentage_indicator.dart';
import 'package:student/views/mark_attendance_view.dart';
import 'package:student/views/reports_view.dart';
import 'package:intl/intl.dart';

class SubjectDetailsView extends StatefulWidget {
  final MainStore mainStore;
  final Course course;

  const SubjectDetailsView({
    super.key,
    required this.mainStore,
    required this.course,
  });

  @override
  State<SubjectDetailsView> createState() => _SubjectDetailsViewState();
}

class _SubjectDetailsViewState extends State<SubjectDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    widget.mainStore.attendanceStore.setSelectedCourse(widget.course.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Calendar', icon: Icon(Icons.calendar_today)),
            Tab(text: 'History', icon: Icon(Icons.history)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareSubjectReport(),
          ),
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () => _navigateToReports(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildCalendarTab(),
          _buildHistoryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToMarkAttendance(),
        child: const Icon(Icons.add),
        tooltip: 'Mark Attendance',
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Observer(
      builder: (context) {
        final stats = widget.mainStore.attendanceStore.getStatsForCourse(widget.course.id);
        
        if (stats == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No attendance records yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Start marking attendance to see statistics',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alert banner for low attendance
              if (stats.isBelowThreshold)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Attendance is below 75% threshold (${stats.percentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Course info with attendance percentage on the side (no background)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Course information on the left
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.course.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Code: ${widget.course.code}'),
                          Text('Instructor: ${widget.course.instructor}'),
                        ],
                      ),
                    ),
                    // Attendance percentage on the right
                    Expanded(
                      flex: 1,
                      child: PercentageIndicator(
                        percentage: stats.percentage,
                        label: 'Attendance',
                        size: 100,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Statistics cards centered in a 2x2 grid
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Classes',
                              stats.totalClasses.toString(),
                              Icons.school,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Present',
                              stats.presentCount.toString(),
                              Icons.check_circle,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Absent',
                              stats.absentCount.toString(),
                              Icons.cancel,
                              Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Leave',
                              stats.leaveCount.toString(),
                              Icons.event_busy,
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarTab() {
    return Observer(
      builder: (context) {
        final courseAttendance = widget.mainStore.attendanceStore
            .getAttendanceForCourse(widget.course.id);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: CalendarView(
            attendanceRecords: courseAttendance,
            onDaySelected: (selectedDay) {
              widget.mainStore.attendanceStore.setSelectedDate(selectedDay);
            },
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return Observer(
      builder: (context) {
        final courseAttendance = widget.mainStore.attendanceStore
            .getAttendanceForCourse(widget.course.id)
            .reversed
            .toList();

        if (courseAttendance.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No attendance history',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: courseAttendance.length,
          itemBuilder: (context, index) {
            final attendance = courseAttendance[index];
            return AttendanceCard(
              attendance: attendance,
              course: widget.course,
              onEdit: () => _editAttendance(attendance),
              onDelete: () => _deleteAttendance(attendance),
            );
          },
        );
      },
    );
  }

  void _navigateToMarkAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkAttendanceView(
          mainStore: widget.mainStore,
          course: widget.course,
        ),
      ),
    );
  }

  void _navigateToReports() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportsView(
          mainStore: widget.mainStore,
          course: widget.course,
        ),
      ),
    );
  }

  Future<void> _shareSubjectReport() async {
    try {
      final stats = widget.mainStore.attendanceStore.getStatsForCourse(widget.course.id);
      final studentName = widget.mainStore.authService.studentName ?? 'Student';
      final studentId = widget.mainStore.authService.studentId ?? 'N/A';
      
      if (stats == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No attendance data available to share'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      final reportText = _generateSubjectReportText(stats, studentName, studentId);
      
      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: reportText));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Subject report copied to clipboard! You can now paste it in any app to share.'),
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

  String _generateSubjectReportText(AttendanceStats stats, String studentName, String studentId) {
    final buffer = StringBuffer();
    buffer.writeln('📊 SUBJECT ATTENDANCE REPORT');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('Student: $studentName');
    buffer.writeln('Student ID: $studentId');
    buffer.writeln('Subject: ${widget.course.name} (${widget.course.code})');
    buffer.writeln('Instructor: ${widget.course.instructor}');
    buffer.writeln('Generated: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}');
    buffer.writeln();
    
    buffer.writeln('📈 ATTENDANCE SUMMARY:');
    buffer.writeln('─────────────────────');
    buffer.writeln('Overall Attendance: ${stats.percentage.toStringAsFixed(1)}%');
    buffer.writeln('Total Classes: ${stats.totalClasses}');
    buffer.writeln('Present: ${stats.presentCount}');
    buffer.writeln('Absent: ${stats.absentCount}');
    buffer.writeln('Leave: ${stats.leaveCount}');
    buffer.writeln();
    
    if (stats.isBelowThreshold) {
      buffer.writeln('⚠️ WARNING: Attendance is below 75% threshold');
      buffer.writeln('Action required to meet minimum attendance requirement.');
    } else {
      buffer.writeln('✅ Attendance meets the 75% minimum requirement');
    }
    
    buffer.writeln();
    buffer.writeln('Generated by Student Attendance System');
    
    return buffer.toString();
  }

  void _editAttendance(Attendance attendance) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkAttendanceView(
          mainStore: widget.mainStore,
          course: widget.course,
          existingAttendance: attendance,
        ),
      ),
    );
  }

  void _deleteAttendance(Attendance attendance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attendance'),
        content: const Text('Are you sure you want to delete this attendance record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.mainStore.attendanceStore.deleteAttendance(attendance.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Attendance record deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}