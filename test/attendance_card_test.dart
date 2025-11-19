import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student/models/attendance.dart';
import 'package:student/models/course.dart';
import 'package:student/widgets/attendance_card.dart';

void main() {
  group('AttendanceCard', () {
    late Attendance attendance;
    late Course course;

    setUp(() {
      attendance = Attendance(
        id: '1',
        courseId: 'course1',
        userId: 'user1',
        date: DateTime(2023, 1, 1),
        status: AttendanceStatus.present,
        note: 'Good participation',
      );

      course = Course(
        id: 'course1',
        name: 'Mathematics',
        code: 'MATH101',
        instructor: 'Dr. Smith', userId: '',
      );
    });

    testWidgets('displays attendance information correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: AttendanceCard(
            attendance: attendance,
            course: course,
          ),
        ),
      );

      // Assert
      expect(find.text('Mathematics'), findsOneWidget);
      expect(find.text('Jan 01, 2023 - Present'), findsOneWidget);
      expect(find.text('Good participation'), findsOneWidget);
    });

    testWidgets('displays correct status color indicator', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: AttendanceCard(
            attendance: attendance,
            course: course,
          ),
        ),
      );

      // Assert
      // Find the color indicator (a Container with specific decoration)
      final indicatorFinder = find.byWidgetPredicate((widget) {
        return widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == Colors.green;
      });

      expect(indicatorFinder, findsOneWidget);
    });

    testWidgets('calls onEdit when edit button is pressed', (tester) async {
      // Arrange
      bool editCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: AttendanceCard(
            attendance: attendance,
            course: course,
            onEdit: () => editCalled = true,
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      // Assert
      expect(editCalled, isTrue);
    });

    testWidgets('calls onDelete when delete button is pressed', (tester) async {
      // Arrange
      bool deleteCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: AttendanceCard(
            attendance: attendance,
            course: course,
            onDelete: () => deleteCalled = true,
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // Assert
      expect(deleteCalled, isTrue);
    });
  });
}