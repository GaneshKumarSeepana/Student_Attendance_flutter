import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:student/stores/main_store.dart';
import 'package:student/views/login_view.dart';
import 'package:student/views/signup_view.dart';
import 'package:student/views/dashboard_view.dart';
import 'package:student/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Attendance System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MainStore _mainStore;
  int _currentIndex = 0; // 0: Login, 1: Signup, 2: Dashboard

  @override
  void initState() {
    super.initState();
    _mainStore = MainStore();
    _mainStore.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (_mainStore.authService.isLoggedIn) {
          return DashboardView(
            mainStore: _mainStore,
            onLogout: _handleLogout,
          );
        } else {
          if (_currentIndex == 0) {
            return LoginView(
              mainStore: _mainStore,
              onLoginSuccess: _handleLoginSuccess,
              onNavigateToSignup: () => setState(() => _currentIndex = 1),
            );
          } else {
            return SignupView(
              mainStore: _mainStore,
              onSignupSuccess: _handleLoginSuccess,
              onNavigateToLogin: () => setState(() => _currentIndex = 0),
            );
          }
        }
      },
    );
  }

  void _handleLoginSuccess() {
    setState(() {
      _currentIndex = 2; // Show dashboard
    });
  }

  void _handleLogout() {
    _mainStore.authService.logout();
    setState(() {
      _currentIndex = 0; // Show login
    });
  }


}