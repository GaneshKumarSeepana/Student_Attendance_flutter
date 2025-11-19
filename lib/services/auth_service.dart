import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/services/database_service.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

part 'auth_service.g.dart';

class AuthService = _AuthService with _$AuthService;

abstract class _AuthService with Store {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _studentIdKey = 'studentId';

  final DatabaseService _databaseService;

  _AuthService(this._databaseService);

  @observable
  bool isLoggedIn = false;

  @observable
  String? studentId;

  @observable
  String? studentName;

  @observable
  String? errorMessage;

  @observable
  bool isLoading = false;

  @action
  void setError(String error) {
    errorMessage = error;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void setLoading(bool loading) {
    isLoading = loading;
  }

  @action
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    studentId = prefs.getString(_studentIdKey);
    
    // Load student name if logged in
    if (isLoggedIn && studentId != null) {
      final user = await _databaseService.getUserById(studentId!);
      if (user != null) {
        studentName = user['name'];
      }
    }
  }

  @action
  Future<bool> login(String studentIdInput, String password) async {
    setLoading(true);
    try {
      clearError();
      
      // Get user by student ID
      final user = await _databaseService.getUserByStudentId(studentIdInput);
      
      if (user != null) {
        // Hash the provided password
        final hashedPassword = _hashPassword(password);
        
        // Check if password matches
        if (user['password_hash'] == hashedPassword) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(_isLoggedInKey, true);
          await prefs.setString(_studentIdKey, user['id']);
          
          isLoggedIn = true;
          studentId = user['id'];
          studentName = user['name'];
          return true;
        } else {
          setError('Invalid password');
        }
      } else {
        setError('User not found');
      }
      return false;
    } catch (e) {
      setError('Login failed: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<bool> signup(String studentIdInput, String name, String password) async {
    setLoading(true);
    try {
      clearError();
      
      // Check if user already exists with this student ID
      final existingUser = await _databaseService.getUserByStudentId(studentIdInput);
      
      if (existingUser != null) {
        setError('User with this Student ID already exists');
        return false;
      }
      
      // Hash the password
      final hashedPassword = _hashPassword(password);
      
      // Create user data
      final userData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'student_id': studentIdInput,
        'name': name,
        'password_hash': hashedPassword,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      };
      
      // Insert user into database
      await _databaseService.insertUser(userData);
      
      // Automatically log in the user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_studentIdKey, userData['id'] as String);
      
      isLoggedIn = true;
      studentId = userData['id'] as String;
      studentName = name;
      
      return true;
    } catch (e) {
      setError('Signup failed: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_studentIdKey);
    
    isLoggedIn = false;
    studentId = null;
    studentName = null;
    clearError();
  }

  // Helper method to hash passwords
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}