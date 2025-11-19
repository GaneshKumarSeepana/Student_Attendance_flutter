import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/models/course.dart';
import 'package:student/models/attendance.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static SharedPreferences? _prefs;
  static bool _initialized = false;

  Future<SharedPreferences> get prefs async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
    return _prefs!;
  }

  // Web-compatible storage keys
  static const String _usersKey = 'users_data';
  static const String _coursesKey = 'courses_data';
  static const String _attendanceKey = 'attendance_data';

  // User operations
  Future<void> insertUser(Map<String, dynamic> user) async {
    final prefs = await this.prefs;
    final users = await _getUsers();
    users.add(user);
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<Map<String, dynamic>?> getUserByStudentId(String studentId) async {
    final users = await _getUsers();
    try {
      return users.firstWhere((user) => user['student_id'] == studentId);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserById(String id) async {
    final users = await _getUsers();
    try {
      return users.firstWhere((user) => user['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final prefs = await this.prefs;
    final users = await _getUsers();
    final index = users.indexWhere((u) => u['id'] == user['id']);
    if (index != -1) {
      users[index] = user;
      await prefs.setString(_usersKey, jsonEncode(users));
    }
  }

  Future<void> deleteUser(String id) async {
    final prefs = await this.prefs;
    final users = await _getUsers();
    users.removeWhere((user) => user['id'] == id);
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  // Course operations
  Future<void> insertCourse(Course course) async {
    final prefs = await this.prefs;
    final courses = await _getCourses();
    courses.add(course.toMap());
    await prefs.setString(_coursesKey, jsonEncode(courses));
  }

  Future<List<Course>> getCoursesByUserId(String userId) async {
    final courses = await _getCourses();
    return courses
        .where((course) => course['user_id'] == userId)
        .map((course) => Course.fromMap(course))
        .toList();
  }

  Future<Course?> getCourseById(String id) async {
    final courses = await _getCourses();
    try {
      final courseMap = courses.firstWhere((course) => course['id'] == id);
      return Course.fromMap(courseMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateCourse(Course course) async {
    final prefs = await this.prefs;
    final courses = await _getCourses();
    final index = courses.indexWhere((c) => c['id'] == course.id);
    if (index != -1) {
      courses[index] = course.toMap();
      await prefs.setString(_coursesKey, jsonEncode(courses));
    }
  }

  Future<void> deleteCourse(String id) async {
    final prefs = await this.prefs;
    final courses = await _getCourses();
    courses.removeWhere((course) => course['id'] == id);
    await prefs.setString(_coursesKey, jsonEncode(courses));
    
    // Also delete related attendance records
    final attendance = await _getAttendance();
    attendance.removeWhere((record) => record['course_id'] == id);
    await prefs.setString(_attendanceKey, jsonEncode(attendance));
  }

  // Attendance operations
  Future<void> insertAttendance(Attendance attendance) async {
    final prefs = await this.prefs;
    final attendanceList = await _getAttendance();
    attendanceList.add(attendance.toMap());
    await prefs.setString(_attendanceKey, jsonEncode(attendanceList));
  }

  Future<List<Attendance>> getAllAttendance() async {
    final attendanceList = await _getAttendance();
    return attendanceList
        .map((attendance) => Attendance.fromMap(attendance))
        .toList();
  }

  Future<List<Attendance>> getAttendanceByUserId(String userId) async {
    final attendanceList = await _getAttendance();
    return attendanceList
        .where((attendance) => attendance['user_id'] == userId)
        .map((attendance) => Attendance.fromMap(attendance))
        .toList();
  }

  Future<List<Attendance>> getAttendanceByCourseId(String courseId) async {
    final attendanceList = await _getAttendance();
    return attendanceList
        .where((attendance) => attendance['course_id'] == courseId)
        .map((attendance) => Attendance.fromMap(attendance))
        .toList();
  }

  Future<void> updateAttendance(Attendance attendance) async {
    final prefs = await this.prefs;
    final attendanceList = await _getAttendance();
    final index = attendanceList.indexWhere((a) => a['id'] == attendance.id);
    if (index != -1) {
      attendanceList[index] = attendance.toMap();
      await prefs.setString(_attendanceKey, jsonEncode(attendanceList));
    }
  }

  Future<void> deleteAttendance(String id) async {
    final prefs = await this.prefs;
    final attendanceList = await _getAttendance();
    attendanceList.removeWhere((attendance) => attendance['id'] == id);
    await prefs.setString(_attendanceKey, jsonEncode(attendanceList));
  }

  // Database operations
  Future<void> initializeDatabase() async {
    // Initialize SharedPreferences
    await prefs;
  }

  Future<void> closeDatabase() async {
    // No need to close SharedPreferences
  }

  Future<void> clearAllData() async {
    final prefs = await this.prefs;
    await prefs.remove(_usersKey);
    await prefs.remove(_coursesKey);
    await prefs.remove(_attendanceKey);
  }

  // Private helper methods
  Future<List<Map<String, dynamic>>> _getUsers() async {
    final prefs = await this.prefs;
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return [];
    return List<Map<String, dynamic>>.from(
      jsonDecode(usersJson).map((user) => Map<String, dynamic>.from(user))
    );
  }

  Future<List<Map<String, dynamic>>> _getCourses() async {
    final prefs = await this.prefs;
    final coursesJson = prefs.getString(_coursesKey);
    if (coursesJson == null) return [];
    return List<Map<String, dynamic>>.from(
      jsonDecode(coursesJson).map((course) => Map<String, dynamic>.from(course))
    );
  }

  Future<List<Map<String, dynamic>>> _getAttendance() async {
    final prefs = await this.prefs;
    final attendanceJson = prefs.getString(_attendanceKey);
    if (attendanceJson == null) return [];
    return List<Map<String, dynamic>>.from(
      jsonDecode(attendanceJson).map((attendance) => Map<String, dynamic>.from(attendance))
    );
  }
}