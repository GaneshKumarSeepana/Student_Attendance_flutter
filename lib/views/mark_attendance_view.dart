import 'package:flutter/material.dart';
import 'package:student/stores/main_store.dart';
import 'package:student/models/course.dart';
import 'package:student/models/attendance.dart';
import 'package:intl/intl.dart';

class MarkAttendanceView extends StatefulWidget {
  final MainStore mainStore;
  final Course course;
  final Attendance? existingAttendance;

  const MarkAttendanceView({
    super.key,
    required this.mainStore,
    required this.course,
    this.existingAttendance,
  });

  @override
  State<MarkAttendanceView> createState() => _MarkAttendanceViewState();
}

class _MarkAttendanceViewState extends State<MarkAttendanceView> {
  late DateTime _selectedDate;
  late AttendanceStatus _selectedStatus;
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingAttendance != null) {
      _selectedDate = widget.existingAttendance!.date;
      _selectedStatus = widget.existingAttendance!.status;
      _noteController.text = widget.existingAttendance!.note ?? '';
    } else {
      _selectedDate = DateTime.now();
      _selectedStatus = AttendanceStatus.present;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingAttendance != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Attendance' : 'Mark Attendance'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveAttendance,
            child: Text(
              isEditing ? 'Update' : 'Save',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Code: ${widget.course.code}'),
                    Text('Instructor: ${widget.course.instructor}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Date selection
            const Text(
              'Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Status selection
            const Text(
              'Attendance Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: AttendanceStatus.values.map((status) {
                return RadioListTile<AttendanceStatus>(
                  title: Text(_getStatusText(status)),
                  subtitle: Text(_getStatusDescription(status)),
                  value: status,
                  groupValue: _selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                  secondary: Icon(
                    _getStatusIcon(status),
                    color: Attendance.getStatusColor(status),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Note field
            const Text(
              'Note (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Add a note about this attendance...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const Spacer(),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveAttendance,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        isEditing ? 'Update Attendance' : 'Mark Attendance',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
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

  String _getStatusDescription(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Student was present in class';
      case AttendanceStatus.absent:
        return 'Student was absent from class';
      case AttendanceStatus.leave:
        return 'Student was on approved leave';
    }
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.leave:
        return Icons.event_busy;
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveAttendance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await widget.mainStore.attendanceStore.markAttendance(
        courseId: widget.course.id,
        date: _selectedDate,
        status: _selectedStatus,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );

      if (success) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.existingAttendance != null
                    ? 'Attendance updated successfully'
                    : 'Attendance marked successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.mainStore.attendanceStore.errorMessage ??
                    'Failed to save attendance',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}