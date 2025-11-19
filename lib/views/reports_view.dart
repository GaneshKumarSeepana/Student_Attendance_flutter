import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:student/stores/main_store.dart';
import 'package:student/models/course.dart';
import 'package:student/models/attendance.dart';
import 'package:student/models/attendance_stats.dart';
import 'package:student/services/pdf_service.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter/services.dart';

class ReportsView extends StatefulWidget {
  final MainStore mainStore;
  final Course? course;

  const ReportsView({
    super.key,
    required this.mainStore,
    this.course,
  });

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedMonth = DateTime.now();
  int _selectedSemester = 1;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOverallReport = widget.course == null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isOverallReport 
              ? 'Attendance Reports' 
              : '${widget.course!.name} Reports'
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Monthly', icon: Icon(Icons.calendar_view_month)),
            Tab(text: 'Semester', icon: Icon(Icons.school)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReport,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPDF,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMonthlyReport(),
          _buildSemesterReport(),
        ],
      ),
    );
  }

  Widget _buildMonthlyReport() {
    return Observer(
      builder: (context) {
        final monthlyStats = widget.mainStore.attendanceStore
            .getMonthlyStats(_selectedMonth.year, _selectedMonth.month);

        return Column(
          children: [
            // Month selector
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Month: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: _selectMonth,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          DateFormat('MMMM yyyy').format(_selectedMonth),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Monthly stats
            Expanded(
              child: monthlyStats.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assessment, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No attendance data for this month',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: monthlyStats.length,
                      itemBuilder: (context, index) {
                        final courseId = monthlyStats.keys.elementAt(index);
                        final stats = monthlyStats[courseId]!;
                        final course = widget.course ??
                            widget.mainStore.courseStore.getCourseById(courseId);

                        return _buildStatsCard(course, stats);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSemesterReport() {
    return Observer(
      builder: (context) {
        // Calculate semester date range
        final semesterStart = DateTime(_selectedYear, _selectedSemester == 1 ? 1 : 7, 1);
        final semesterEnd = DateTime(_selectedYear, _selectedSemester == 1 ? 6 : 12, 30);
        
        final semesterAttendance = widget.mainStore.attendanceStore
            .getAttendanceForDateRange(semesterStart, semesterEnd);

        // Group by course
        final Map<String, AttendanceStats> semesterStats = {};
        final courseIds = semesterAttendance.map((a) => a.courseId).toSet();

        for (final courseId in courseIds) {
          final courseAttendance = semesterAttendance
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

            semesterStats[courseId] = AttendanceStats.create(
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

        return Column(
          children: [
            // Semester selector
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Semester: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        DropdownButton<int>(
                          value: _selectedSemester,
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('Semester 1')),
                            DropdownMenuItem(value: 2, child: Text('Semester 2')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedSemester = value!;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<int>(
                          value: _selectedYear,
                          items: List.generate(5, (index) {
                            final year = DateTime.now().year - 2 + index;
                            return DropdownMenuItem(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              _selectedYear = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Semester stats
            Expanded(
              child: semesterStats.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No attendance data for this semester',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: semesterStats.length,
                      itemBuilder: (context, index) {
                        final courseId = semesterStats.keys.elementAt(index);
                        final stats = semesterStats[courseId]!;
                        final course = widget.course ??
                            widget.mainStore.courseStore.getCourseById(courseId);

                        return _buildStatsCard(course, stats);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsCard(Course? course, AttendanceStats stats) {
    if (course == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${course.code} - ${course.instructor}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Percentage indicator
            LinearPercentIndicator(
              lineHeight: 20,
              percent: stats.percentage / 100,
              center: Text(
                '${stats.percentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              barRadius: const Radius.circular(10),
              progressColor: stats.isBelowThreshold ? Colors.red : Colors.green,
              backgroundColor: Colors.grey[300],
            ),

            const SizedBox(height: 16),

            // Statistics row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', stats.totalClasses, Colors.blue),
                _buildStatItem('Present', stats.presentCount, Colors.green),
                _buildStatItem('Absent', stats.absentCount, Colors.red),
                _buildStatItem('Leave', stats.leaveCount, Colors.orange),
              ],
            ),

            // Warning if below threshold
            if (stats.isBelowThreshold) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Below 75% threshold',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Future<void> _selectMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      setState(() {
        _selectedMonth = picked;
      });
    }
  }

  Future<void> _shareReport() async {
    try {
      final isMonthly = _tabController.index == 0;
      final studentName = widget.mainStore.authService.studentName ?? 'Student';
      final rollNumber = widget.mainStore.authService.studentId ?? 'N/A';
      
      String reportText;
      String subject;
      
      if (isMonthly) {
        final monthlyStats = widget.mainStore.attendanceStore
            .getMonthlyStats(_selectedMonth.year, _selectedMonth.month);
        
        reportText = _generateMonthlyReportText(monthlyStats, studentName, rollNumber);
        subject = 'Monthly Attendance Report - ${DateFormat('MMMM yyyy').format(_selectedMonth)}';
      } else {
        final semesterStart = DateTime(_selectedYear, _selectedSemester == 1 ? 1 : 7, 1);
        final semesterEnd = DateTime(_selectedYear, _selectedSemester == 1 ? 6 : 12, 30);
        final semesterAttendance = widget.mainStore.attendanceStore
            .getAttendanceForDateRange(semesterStart, semesterEnd);
        
        reportText = _generateSemesterReportText(semesterAttendance, studentName, rollNumber);
        subject = 'Semester $_selectedSemester Attendance Report - $_selectedYear';
      }
      
      // Copy to clipboard and show share options
      await Clipboard.setData(ClipboardData(text: reportText));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Report copied to clipboard! You can now paste it in any app to share.'),
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

  String _generateMonthlyReportText(Map<String, AttendanceStats> monthlyStats, String studentName, String rollNumber) {
    final buffer = StringBuffer();
    buffer.writeln('📊 MONTHLY ATTENDANCE REPORT');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('Student: $studentName');
    buffer.writeln('Roll Number: $rollNumber');
    buffer.writeln('Month: ${DateFormat('MMMM yyyy').format(_selectedMonth)}');
    buffer.writeln('Generated: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}');
    buffer.writeln();
    
    if (monthlyStats.isEmpty) {
      buffer.writeln('No attendance data available for this month.');
      return buffer.toString();
    }
    
    buffer.writeln('📚 COURSE-WISE BREAKDOWN:');
    buffer.writeln('─────────────────────────');
    
    for (final entry in monthlyStats.entries) {
      final courseId = entry.key;
      final stats = entry.value;
      final course = widget.mainStore.courseStore.getCourseById(courseId);
      
      if (course != null) {
        buffer.writeln();
        buffer.writeln('📖 ${course.name} (${course.code})');
        buffer.writeln('   Instructor: ${course.instructor}');
        buffer.writeln('   Attendance: ${stats.percentage.toStringAsFixed(1)}%');
        buffer.writeln('   Present: ${stats.presentCount}/${stats.totalClasses}');
        buffer.writeln('   Absent: ${stats.absentCount}');
        buffer.writeln('   Leave: ${stats.leaveCount}');
        
        if (stats.isBelowThreshold) {
          buffer.writeln('   ⚠️ Below 75% threshold');
        }
      }
    }
    
    buffer.writeln();
    buffer.writeln('Generated by Student Attendance System');
    
    return buffer.toString();
  }

  String _generateSemesterReportText(List<Attendance> semesterAttendance, String studentName, String rollNumber) {
    final buffer = StringBuffer();
    buffer.writeln('📊 SEMESTER ATTENDANCE REPORT');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('Student: $studentName');
    buffer.writeln('Roll Number: $rollNumber');
    buffer.writeln('Semester: $_selectedSemester, Year: $_selectedYear');
    buffer.writeln('Generated: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}');
    buffer.writeln();
    
    if (semesterAttendance.isEmpty) {
      buffer.writeln('No attendance data available for this semester.');
      return buffer.toString();
    }
    
    // Overall statistics
    final totalClasses = semesterAttendance.length;
    final presentCount = semesterAttendance
        .where((a) => a.status == AttendanceStatus.present)
        .length;
    final absentCount = semesterAttendance
        .where((a) => a.status == AttendanceStatus.absent)
        .length;
    final leaveCount = semesterAttendance
        .where((a) => a.status == AttendanceStatus.leave)
        .length;
    final overallPercentage = totalClasses > 0 ? (presentCount / totalClasses) * 100 : 0.0;
    
    buffer.writeln('📈 OVERALL SUMMARY:');
    buffer.writeln('─────────────────');
    buffer.writeln('Total Classes: $totalClasses');
    buffer.writeln('Present: $presentCount');
    buffer.writeln('Absent: $absentCount');
    buffer.writeln('Leave: $leaveCount');
    buffer.writeln('Overall Attendance: ${overallPercentage.toStringAsFixed(1)}%');
    
    if (overallPercentage < 75.0) {
      buffer.writeln('⚠️ Overall attendance is below 75% threshold');
    }
    
    buffer.writeln();
    
    // Course-wise breakdown
    final Map<String, List<Attendance>> attendanceByCourse = {};
    for (final attendance in semesterAttendance) {
      if (!attendanceByCourse.containsKey(attendance.courseId)) {
        attendanceByCourse[attendance.courseId] = [];
      }
      attendanceByCourse[attendance.courseId]!.add(attendance);
    }
    
    if (attendanceByCourse.isNotEmpty) {
      buffer.writeln('📚 COURSE-WISE BREAKDOWN:');
      buffer.writeln('─────────────────────────');
      
      for (final entry in attendanceByCourse.entries) {
        final courseId = entry.key;
        final courseAttendance = entry.value;
        final course = widget.mainStore.courseStore.getCourseById(courseId);
        
        if (course != null) {
          final courseTotalClasses = courseAttendance.length;
          final coursePresentCount = courseAttendance
              .where((a) => a.status == AttendanceStatus.present)
              .length;
          final courseAbsentCount = courseAttendance
              .where((a) => a.status == AttendanceStatus.absent)
              .length;
          final courseLeaveCount = courseAttendance
              .where((a) => a.status == AttendanceStatus.leave)
              .length;
          final coursePercentage = courseTotalClasses > 0 ? (coursePresentCount / courseTotalClasses) * 100 : 0.0;
          
          buffer.writeln();
          buffer.writeln('📖 ${course.name} (${course.code})');
          buffer.writeln('   Instructor: ${course.instructor}');
          buffer.writeln('   Attendance: ${coursePercentage.toStringAsFixed(1)}%');
          buffer.writeln('   Present: $coursePresentCount/$courseTotalClasses');
          buffer.writeln('   Absent: $courseAbsentCount');
          buffer.writeln('   Leave: $courseLeaveCount');
          
          if (coursePercentage < 75.0) {
            buffer.writeln('   ⚠️ Below 75% threshold');
          }
        }
      }
    }
    
    buffer.writeln();
    buffer.writeln('Generated by Student Attendance System');
    
    return buffer.toString();
  }

  Future<void> _exportToPDF() async {
    try {
      final pdfService = PDFService();
      final isMonthly = _tabController.index == 0;
      
      if (isMonthly) {
        final monthlyStats = widget.mainStore.attendanceStore
            .getMonthlyStats(_selectedMonth.year, _selectedMonth.month);
        
        await pdfService.generateMonthlyReport(
          monthlyStats,
          _selectedMonth,
          widget.mainStore.courseStore.courses,
          widget.mainStore.authService.studentName ?? 'Student',
        );
      } else {
        // Generate semester report
        final semesterStart = DateTime(_selectedYear, _selectedSemester == 1 ? 1 : 7, 1);
        final semesterEnd = DateTime(_selectedYear, _selectedSemester == 1 ? 6 : 12, 30);
        
        await pdfService.generateSemesterReport(
          widget.mainStore.attendanceStore.getAttendanceForDateRange(semesterStart, semesterEnd),
          _selectedSemester,
          _selectedYear,
          widget.mainStore.courseStore.courses,
          widget.mainStore.authService.studentName ?? 'Student',
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF report generated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}