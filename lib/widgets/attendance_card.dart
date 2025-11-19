import 'package:flutter/material.dart';
import 'package:student/models/attendance.dart';
import 'package:student/models/course.dart';
import 'package:intl/intl.dart';

class AttendanceCard extends StatelessWidget {
  final Attendance attendance;
  final Course course;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AttendanceCard({
    Key? key,
    required this.attendance,
    required this.course,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusText = _getStatusText(attendance.status);
    final statusColor = Attendance.getStatusColor(attendance.status);
    final formattedDate = DateFormat('MMM dd, yyyy').format(attendance.date);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        title: Text(
          course.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '$formattedDate - $statusText',
              style: const TextStyle(fontSize: 14),
            ),
            if (attendance.note != null && attendance.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                attendance.note!,
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.leave:
        return 'Leave';
    }
  }
}