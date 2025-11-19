import 'package:mobx/mobx.dart';
import 'package:student/services/database_service.dart';
import 'package:student/services/auth_service.dart';
import 'package:student/stores/course_store.dart';
import 'package:student/stores/attendance_store.dart';
import 'package:student/stores/voice_attendance_store.dart';

part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  final DatabaseService databaseService = DatabaseService();
  late final AuthService authService;
  late final CourseStore courseStore;
  late final AttendanceStore attendanceStore;
  late final VoiceAttendanceStore voiceAttendanceStore;

  _MainStore() {
    authService = AuthService(databaseService);
    courseStore = CourseStore(databaseService);
    attendanceStore = AttendanceStore(databaseService);
    voiceAttendanceStore = VoiceAttendanceStore(attendanceStore, courseStore);
    
    // Observe changes to auth state
    reaction((_) => authService.isLoggedIn, _onAuthStateChanged);
  }

  @action
  Future<void> initialize() async {
    await authService.initialize();
  }

  @action
  void _onAuthStateChanged(bool isLoggedIn) {
    if (isLoggedIn) {
      // Set the current user ID in both stores
      courseStore.setCurrentUserId(authService.studentId);
      attendanceStore.setCurrentUserId(authService.studentId);
      
      // Initialize sample data after courses are loaded
      _initializeSampleDataIfNeeded();
    } else {
      // Clear the current user ID when logged out
      courseStore.setCurrentUserId(null);
      attendanceStore.setCurrentUserId(null);
    }
  }

  @action
  Future<void> _initializeSampleDataIfNeeded() async {
    // Wait a bit for courses to load
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (courseStore.courses.isNotEmpty) {
      final courseIds = courseStore.courses.map((c) => c.id).toList();
      await attendanceStore.initializeSampleData(courseIds);
    }
  }
}