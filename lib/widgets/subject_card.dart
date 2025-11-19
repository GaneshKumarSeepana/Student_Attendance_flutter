import 'package:flutter/material.dart';
import 'package:student/models/course.dart';
import 'package:student/models/attendance_stats.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SubjectCard extends StatelessWidget {
  final Course course;
  final AttendanceStats? stats;
  final VoidCallback? onTap;
  final VoidCallback? onVoiceAttendance;

  const SubjectCard({
    Key? key,
    required this.course,
    this.stats,
    this.onTap,
    this.onVoiceAttendance,
  }) : super(key: key);

  Color _getAttendanceColor(AttendanceStats? stats) {
    if (stats == null) return Colors.grey;
    
    switch (stats.colorStatus) {
      case AttendanceColorStatus.good:
        return Colors.green;
      case AttendanceColorStatus.warning:
        return Colors.orange;
      case AttendanceColorStatus.critical:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendancePercentage = stats?.percentage ?? 0.0;
    final attendanceColor = _getAttendanceColor(stats);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        course.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Voice button (if provided)
                    if (onVoiceAttendance != null) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: onVoiceAttendance,
                          icon: const Icon(Icons.mic),
                          iconSize: 18,
                          color: Colors.blue,
                          tooltip: 'Voice Attendance',
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    // Percentage indicator
                    CircularPercentIndicator(
                      radius: 30,
                      lineWidth: 6,
                      percent: attendancePercentage / 100,
                      center: Text(
                        '${attendancePercentage.toInt()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      progressColor: attendanceColor,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  course.code,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Instructor: ${course.instructor}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                if (stats != null) ...[
                  const SizedBox(height: 8),
                  LinearPercentIndicator(
                    lineHeight: 8,
                    percent: attendancePercentage / 100,
                    barRadius: const Radius.circular(4),
                    progressColor: attendanceColor,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${stats!.presentCount} Present',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        '${stats!.absentCount} Absent',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        '${stats!.leaveCount} Leave',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}