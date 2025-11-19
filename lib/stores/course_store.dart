import 'package:mobx/mobx.dart';
import 'package:student/models/course.dart';
import 'package:student/services/database_service.dart';

part 'course_store.g.dart';

class CourseStore = _CourseStore with _$CourseStore;

abstract class _CourseStore with Store {
  final DatabaseService _databaseService;
  String? _currentUserId;

  _CourseStore(this._databaseService);

  @observable
  ObservableList<Course> courses = ObservableList<Course>();

  @observable
  bool isLoading = false;

  @action
  void setCurrentUserId(String? userId) {
    _currentUserId = userId;
    if (userId != null) {
      loadCourses();
    } else {
      courses.clear();
    }
  }

  @action
  Future<void> loadCourses() async {
    if (_currentUserId == null) return;
    
    isLoading = true;
    try {
      final loadedCourses = await _databaseService.getCoursesByUserId(_currentUserId!);
      courses = ObservableList.of(loadedCourses);
      
      // Add sample courses if none exist for this user
      if (courses.isEmpty) {
        await _initializeSampleCourses();
      }
    } catch (e) {
      // Handle error
      print('Error loading courses: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _initializeSampleCourses() async {
    if (_currentUserId == null) return;
    
    final sampleCourses = [
      Course(
        id: 'cs101_$_currentUserId',
        name: 'Introduction to Computer Science',
        code: 'CS101',
        instructor: 'Dr. Smith',
        userId: _currentUserId!,
      ),
      Course(
        id: 'math201_$_currentUserId',
        name: 'Calculus II',
        code: 'MATH201',
        instructor: 'Prof. Johnson',
        userId: _currentUserId!,
      ),
      Course(
        id: 'eng102_$_currentUserId',
        name: 'English Literature',
        code: 'ENG102',
        instructor: 'Dr. Brown',
        userId: _currentUserId!,
      ),
    ];

    for (final course in sampleCourses) {
      await addCourse(course);
    }
  }

  @action
  Future<void> addCourse(Course course) async {
    try {
      await _databaseService.insertCourse(course);
      courses.add(course);
    } catch (e) {
      // Handle error
      print('Error adding course: $e');
    }
  }

  @action
  Future<void> updateCourse(Course course) async {
    try {
      await _databaseService.updateCourse(course);
      final index = courses.indexWhere((c) => c.id == course.id);
      if (index != -1) {
        courses[index] = course;
      }
    } catch (e) {
      // Handle error
      print('Error updating course: $e');
    }
  }

  @action
  Future<void> deleteCourse(String courseId) async {
    try {
      await _databaseService.deleteCourse(courseId);
      courses.removeWhere((c) => c.id == courseId);
    } catch (e) {
      // Handle error
      print('Error deleting course: $e');
    }
  }

  // Changed from @computed to regular method
  Course? getCourseById(String courseId) {
    try {
      return courses.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }
}