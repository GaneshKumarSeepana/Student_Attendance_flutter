import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:student/models/attendance.dart';
import 'package:student/models/attendance_stats.dart';
import 'package:student/models/course.dart';
import 'package:intl/intl.dart';

class PDFService {
  Future<void> generateMonthlyReport(
    Map<String, AttendanceStats> monthlyStats,
    DateTime month,
    List<Course> courses,
    String studentName,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Header
            pw.Header(
              level: 0,
              child: pw.Text(
                'Monthly Attendance Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            
            pw.SizedBox(height: 20),
            
            // Student info
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Student: $studentName'),
                pw.Text('Month: ${DateFormat('MMMM yyyy').format(month)}'),
              ],
            ),
            
            pw.SizedBox(height: 20),
            
            // Summary table
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                // Header row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Course', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Present', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Absent', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Leave', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Percentage', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                
                // Data rows
                ...monthlyStats.entries.map((entry) {
                  final courseId = entry.key;
                  final stats = entry.value;
                  final course = courses.firstWhere(
                    (c) => c.id == courseId,
                    orElse: () => Course(id: courseId, name: 'Unknown', code: '', instructor: '', userId: ''),
                  );
                  
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('${course.name}\n(${course.code})'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(stats.totalClasses.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(stats.presentCount.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(stats.absentCount.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(stats.leaveCount.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          '${stats.percentage.toStringAsFixed(1)}%',
                          style: pw.TextStyle(
                            color: stats.isBelowThreshold ? PdfColors.red : PdfColors.green,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            
            pw.SizedBox(height: 20),
            
            // Warnings section
            if (monthlyStats.values.any((stats) => stats.isBelowThreshold)) ...[
              pw.Text(
                'Attendance Warnings',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red,
                ),
              ),
              pw.SizedBox(height: 10),
              ...monthlyStats.entries
                  .where((entry) => entry.value.isBelowThreshold)
                  .map((entry) {
                final course = courses.firstWhere(
                  (c) => c.id == entry.key,
                  orElse: () => Course(id: entry.key, name: 'Unknown', code: '', instructor: '', userId: ''),
                );
                return pw.Bullet(
                  text: '${course.name} (${course.code}): ${entry.value.percentage.toStringAsFixed(1)}% - Below 75% threshold',
                );
              }).toList(),
            ],
            
            pw.SizedBox(height: 30),
            
            // Footer
            pw.Text(
              'Generated on ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> generateSemesterReport(
    List<Attendance> semesterAttendance,
    int semester,
    int year,
    List<Course> courses,
    String studentName,
  ) async {
    final pdf = pw.Document();

    // Group attendance by course
    final Map<String, List<Attendance>> attendanceByCourse = {};
    for (final attendance in semesterAttendance) {
      if (!attendanceByCourse.containsKey(attendance.courseId)) {
        attendanceByCourse[attendance.courseId] = [];
      }
      attendanceByCourse[attendance.courseId]!.add(attendance);
    }

    // Calculate stats for each course
    final Map<String, AttendanceStats> semesterStats = {};
    for (final entry in attendanceByCourse.entries) {
      final courseId = entry.key;
      final courseAttendance = entry.value;
      
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

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Header
            pw.Header(
              level: 0,
              child: pw.Text(
                'Semester Attendance Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            
            pw.SizedBox(height: 20),
            
            // Student info
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Student: $studentName'),
                pw.Text('Semester: $semester, Year: $year'),
              ],
            ),
            
            pw.SizedBox(height: 20),
            
            // Overall summary
            pw.Text(
              'Overall Summary',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            
            pw.SizedBox(height: 10),
            
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Column(
                  children: [
                    pw.Text(
                      semesterAttendance.length.toString(),
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue,
                      ),
                    ),
                    pw.Text('Total Classes'),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text(
                      semesterAttendance
                          .where((a) => a.status == AttendanceStatus.present)
                          .length
                          .toString(),
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                    pw.Text('Present'),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text(
                      semesterAttendance
                          .where((a) => a.status == AttendanceStatus.absent)
                          .length
                          .toString(),
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red,
                      ),
                    ),
                    pw.Text('Absent'),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text(
                      semesterAttendance
                          .where((a) => a.status == AttendanceStatus.leave)
                          .length
                          .toString(),
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.orange,
                      ),
                    ),
                    pw.Text('Leave'),
                  ],
                ),
              ],
            ),
            
            pw.SizedBox(height: 30),
            
            // Course-wise breakdown
            pw.Text(
              'Course-wise Breakdown',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            
            pw.SizedBox(height: 10),
            
            // Course table
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                // Header row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Course', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Present', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Absent', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Leave', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Percentage', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                
                // Data rows
                ...semesterStats.entries.map((entry) {
                  final courseId = entry.key;
                  final stats = entry.value;
                  final course = courses.firstWhere(
                    (c) => c.id == courseId,
                    orElse: () => Course(id: courseId, name: 'Unknown', code: '', instructor: '', userId: ''),
                  );
                  
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('${course.name}\n(${course.code})'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(stats.totalClasses.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(stats.presentCount.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(stats.absentCount.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(stats.leaveCount.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          '${stats.percentage.toStringAsFixed(1)}%',
                          style: pw.TextStyle(
                            color: stats.isBelowThreshold ? PdfColors.red : PdfColors.green,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            
            pw.SizedBox(height: 20),
            
            // Warnings section
            if (semesterStats.values.any((stats) => stats.isBelowThreshold)) ...[
              pw.Text(
                'Attendance Warnings',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red,
                ),
              ),
              pw.SizedBox(height: 10),
              ...semesterStats.entries
                  .where((entry) => entry.value.isBelowThreshold)
                  .map((entry) {
                final course = courses.firstWhere(
                  (c) => c.id == entry.key,
                  orElse: () => Course(id: entry.key, name: 'Unknown', code: '', instructor: '', userId: ''),
                );
                return pw.Bullet(
                  text: '${course.name} (${course.code}): ${entry.value.percentage.toStringAsFixed(1)}% - Below 75% threshold',
                );
              }).toList(),
            ],
            
            pw.SizedBox(height: 30),
            
            // Footer
            pw.Text(
              'Generated on ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
