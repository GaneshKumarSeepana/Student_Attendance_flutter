import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:student/models/attendance.dart';

class CalendarView extends StatefulWidget {
  final List<Attendance> attendanceRecords;
  final Function(DateTime) onDaySelected;

  const CalendarView({
    Key? key,
    required this.attendanceRecords,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Map<DateTime, List<Attendance>> _groupAttendanceByDate() {
    final Map<DateTime, List<Attendance>> grouped = {};
    
    for (final attendance in widget.attendanceRecords) {
      final date = DateTime(
        attendance.date.year,
        attendance.date.month,
        attendance.date.day,
      );
      
      if (grouped.containsKey(date)) {
        grouped[date]!.add(attendance);
      } else {
        grouped[date] = [attendance];
      }
    }
    
    return grouped;
  }

  List<Attendance> _getAttendanceForDay(DateTime day) {
    final grouped = _groupAttendanceByDate();
    return grouped[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final groupedAttendance = _groupAttendanceByDate();
    
    return TableCalendar<Attendance>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      eventLoader: (day) => _getAttendanceForDay(day),
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: const CalendarStyle(
        // Use `CalendarStyle` to customize the day cells
        outsideDaysVisible: true,
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
      ),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          widget.onDaySelected(selectedDay);
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return const SizedBox.shrink();
          
          // Determine the dominant status for the day
          int presentCount = 0;
          int absentCount = 0;
          int leaveCount = 0;
          
          for (final attendance in events) {
            switch (attendance.status) {
              case AttendanceStatus.present:
                presentCount++;
                break;
              case AttendanceStatus.absent:
                absentCount++;
                break;
              case AttendanceStatus.leave:
                leaveCount++;
                break;
            }
          }
          
          Color color;
          if (presentCount >= absentCount && presentCount >= leaveCount) {
            color = Attendance.getStatusColor(AttendanceStatus.present);
          } else if (absentCount >= leaveCount) {
            color = Attendance.getStatusColor(AttendanceStatus.absent);
          } else {
            color = Attendance.getStatusColor(AttendanceStatus.leave);
          }
          
          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            width: 8,
            height: 8,
          );
        },
      ),
    );
  }
}