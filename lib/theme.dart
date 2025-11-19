import 'dart:ui';
import 'package:flutter/material.dart';

// ============================================================================
// APP COLORS
// ============================================================================

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF1E88E5);
  static const Color primaryLight = Color(0xFFE3F2FD);
  static const Color onPrimary = Colors.white;
  
  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF018786);
  static const Color onSecondary = Colors.black;
  
  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF212121);
  static const Color onSurface = Color(0xFF212121);
  
  // Attendance Status Colors
  static const Color attendanceGood = Color(0xFF4CAF50);      // Green - Above 85%
  static const Color attendanceWarning = Color(0xFFFF9800);   // Orange - 75-85%
  static const Color attendanceCritical = Color(0xFFF44336);  // Red - Below 75%
  
  // Attendance Type Colors
  static const Color present = Color(0xFF4CAF50);             // Green
  static const Color absent = Color(0xFFF44336);              // Red
  static const Color leave = Color(0xFFFF9800);               // Orange
  
  // Calendar Colors
  static const Color calendarToday = Color(0xFF2196F3);
  static const Color calendarSelected = Color(0xFF1976D2);
  static const Color calendarWeekend = Color(0xFF757575);
  
  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x0A000000);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Colors.white;
  
  // Error Colors
  static const Color error = Color(0xFFB00020);
  static const Color onError = Colors.white;
  
  // Success Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color onSuccess = Colors.white;
  
  // Warning Colors
  static const Color warning = Color(0xFFFF9800);
  static const Color onWarning = Colors.white;
  
  // Info Colors
  static const Color info = Color(0xFF2196F3);
  static const Color onInfo = Colors.white;
  
  // Divider Colors
  static const Color divider = Color(0xFFE0E0E0);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderFocused = Color(0xFF2196F3);
  
  // Disabled Colors
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color onDisabled = Color(0xFF9E9E9E);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient attendanceGoodGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), attendanceGood],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient attendanceWarningGradient = LinearGradient(
    colors: [Color(0xFFFFB74D), attendanceWarning],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient attendanceCriticalGradient = LinearGradient(
    colors: [Color(0xFFEF5350), attendanceCritical],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ============================================================================
// APP TEXT STYLES
// ============================================================================

class AppTextStyles {
  // Font Family
  static const String fontFamily = 'Roboto';
  
  // App Bar Styles
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    fontFamily: fontFamily,
  );
  
  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );
  
  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );
  
  // Button Styles
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle buttonTextSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    fontFamily: fontFamily,
  );
  
  // Input Styles
  static const TextStyle inputLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle inputHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
    fontFamily: fontFamily,
  );
  
  // Card Styles
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );
  
  // Attendance Percentage Styles
  static const TextStyle percentageGood = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.attendanceGood,
    fontFamily: fontFamily,
  );
  
  static const TextStyle percentageWarning = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.attendanceWarning,
    fontFamily: fontFamily,
  );
  
  static const TextStyle percentageCritical = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.attendanceCritical,
    fontFamily: fontFamily,
  );
  
  // Status Text Styles
  static const TextStyle statusPresent = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.present,
    fontFamily: fontFamily,
  );
  
  static const TextStyle statusAbsent = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.absent,
    fontFamily: fontFamily,
  );
  
  static const TextStyle statusLeave = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.leave,
    fontFamily: fontFamily,
  );
  
  // Alert Styles
  static const TextStyle alertTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle alertMessage = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );
  
  // Calendar Styles
  static const TextStyle calendarHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle calendarDay = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const TextStyle calendarToday = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.calendarToday,
    fontFamily: fontFamily,
  );
  
  static const TextStyle calendarSelected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    fontFamily: fontFamily,
  );
}

// ============================================================================
// APP DIMENSIONS
// ============================================================================

class AppDimensions {
  // Padding & Margins
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  static const double paddingXXLarge = 48.0;
  
  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusCircular = 50.0;
  
  // Component Specific Radius
  static const double buttonRadius = 8.0;
  static const double cardRadius = 12.0;
  static const double inputRadius = 8.0;
  static const double dialogRadius = 16.0;
  static const double bottomSheetRadius = 16.0;
  
  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  static const double elevationXLarge = 16.0;
  
  // Component Specific Elevation
  static const double cardElevation = 2.0;
  static const double buttonElevation = 2.0;
  static const double appBarElevation = 0.0;
  static const double dialogElevation = 8.0;
  static const double bottomSheetElevation = 8.0;
  
  // Icon Sizes
  static const double iconTiny = 12.0;
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  static const double iconXXLarge = 64.0;
  
  // Button Dimensions
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonMinWidth = 88.0;
  
  // Input Field Dimensions
  static const double inputHeight = 56.0;
  static const double inputHeightSmall = 40.0;
  static const double inputMinWidth = 200.0;
  
  // Card Dimensions
  static const double cardMinHeight = 80.0;
  static const double cardMaxWidth = 400.0;
  
  // List Item Dimensions
  static const double listItemHeight = 72.0;
  static const double listItemHeightSmall = 56.0;
  static const double listItemHeightLarge = 88.0;
  
  // App Bar Dimensions
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;
  
  // Bottom Navigation Dimensions
  static const double bottomNavHeight = 60.0;
  
  // Tab Bar Dimensions
  static const double tabBarHeight = 48.0;
  
  // Divider Dimensions
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;
  
  // Border Width
  static const double borderThin = 1.0;
  static const double borderMedium = 2.0;
  static const double borderThick = 3.0;
  
  // Spacing
  static const double spacingTiny = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;
  
  // Grid Spacing
  static const double gridSpacing = 16.0;
  static const double gridSpacingSmall = 8.0;
  static const double gridSpacingLarge = 24.0;
  
  // Attendance Card Specific
  static const double attendanceCardHeight = 120.0;
  static const double attendanceCardWidth = double.infinity;
  static const double percentageIndicatorSize = 60.0;
  
  // Calendar Specific
  static const double calendarCellHeight = 48.0;
  static const double calendarHeaderHeight = 56.0;
  
  // Dialog Dimensions
  static const double dialogMaxWidth = 400.0;
  static const double dialogMinWidth = 280.0;
  
  // Bottom Sheet Dimensions
  static const double bottomSheetMaxHeight = 0.9; // 90% of screen height
  static const double bottomSheetMinHeight = 200.0;
  
  // Screen Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  
  // Animation Durations (in milliseconds)
  static const int animationFast = 150;
  static const int animationNormal = 300;
  static const int animationSlow = 500;
  
  // Opacity Values
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.54;
  static const double opacityHigh = 0.87;
  static const double opacityFull = 1.0;
}

// ============================================================================
// THEME EXTENSIONS
// ============================================================================

// Extension for easy access to theme colors
extension AppColorsExtension on BuildContext {
  AppColorsTheme get colors => Theme.of(this).extension<AppColorsTheme>()!;
}

// Extension for easy access to text styles
extension AppTextStylesExtension on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

// Extension for easy access to dimensions
extension AppDimensionsExtension on BuildContext {
  AppDimensionsTheme get dimensions => Theme.of(this).extension<AppDimensionsTheme>()!;
}

// Custom theme extension for app-specific colors
@immutable
class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  final Color attendanceGood;
  final Color attendanceWarning;
  final Color attendanceCritical;
  final Color present;
  final Color absent;
  final Color leave;
  final Color calendarToday;
  final Color calendarSelected;
  final LinearGradient primaryGradient;
  final LinearGradient attendanceGoodGradient;
  final LinearGradient attendanceWarningGradient;
  final LinearGradient attendanceCriticalGradient;

  const AppColorsTheme({
    required this.attendanceGood,
    required this.attendanceWarning,
    required this.attendanceCritical,
    required this.present,
    required this.absent,
    required this.leave,
    required this.calendarToday,
    required this.calendarSelected,
    required this.primaryGradient,
    required this.attendanceGoodGradient,
    required this.attendanceWarningGradient,
    required this.attendanceCriticalGradient,
  });

  @override
  AppColorsTheme copyWith({
    Color? attendanceGood,
    Color? attendanceWarning,
    Color? attendanceCritical,
    Color? present,
    Color? absent,
    Color? leave,
    Color? calendarToday,
    Color? calendarSelected,
    LinearGradient? primaryGradient,
    LinearGradient? attendanceGoodGradient,
    LinearGradient? attendanceWarningGradient,
    LinearGradient? attendanceCriticalGradient,
  }) {
    return AppColorsTheme(
      attendanceGood: attendanceGood ?? this.attendanceGood,
      attendanceWarning: attendanceWarning ?? this.attendanceWarning,
      attendanceCritical: attendanceCritical ?? this.attendanceCritical,
      present: present ?? this.present,
      absent: absent ?? this.absent,
      leave: leave ?? this.leave,
      calendarToday: calendarToday ?? this.calendarToday,
      calendarSelected: calendarSelected ?? this.calendarSelected,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      attendanceGoodGradient: attendanceGoodGradient ?? this.attendanceGoodGradient,
      attendanceWarningGradient: attendanceWarningGradient ?? this.attendanceWarningGradient,
      attendanceCriticalGradient: attendanceCriticalGradient ?? this.attendanceCriticalGradient,
    );
  }

  @override
  AppColorsTheme lerp(AppColorsTheme? other, double t) {
    if (other is! AppColorsTheme) {
      return this;
    }
    return AppColorsTheme(
      attendanceGood: Color.lerp(attendanceGood, other.attendanceGood, t)!,
      attendanceWarning: Color.lerp(attendanceWarning, other.attendanceWarning, t)!,
      attendanceCritical: Color.lerp(attendanceCritical, other.attendanceCritical, t)!,
      present: Color.lerp(present, other.present, t)!,
      absent: Color.lerp(absent, other.absent, t)!,
      leave: Color.lerp(leave, other.leave, t)!,
      calendarToday: Color.lerp(calendarToday, other.calendarToday, t)!,
      calendarSelected: Color.lerp(calendarSelected, other.calendarSelected, t)!,
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      attendanceGoodGradient: LinearGradient.lerp(attendanceGoodGradient, other.attendanceGoodGradient, t)!,
      attendanceWarningGradient: LinearGradient.lerp(attendanceWarningGradient, other.attendanceWarningGradient, t)!,
      attendanceCriticalGradient: LinearGradient.lerp(attendanceCriticalGradient, other.attendanceCriticalGradient, t)!,
    );
  }

  static const light = AppColorsTheme(
    attendanceGood: AppColors.attendanceGood,
    attendanceWarning: AppColors.attendanceWarning,
    attendanceCritical: AppColors.attendanceCritical,
    present: AppColors.present,
    absent: AppColors.absent,
    leave: AppColors.leave,
    calendarToday: AppColors.calendarToday,
    calendarSelected: AppColors.calendarSelected,
    primaryGradient: AppColors.primaryGradient,
    attendanceGoodGradient: AppColors.attendanceGoodGradient,
    attendanceWarningGradient: AppColors.attendanceWarningGradient,
    attendanceCriticalGradient: AppColors.attendanceCriticalGradient,
  );

  static const dark = AppColorsTheme(
    attendanceGood: AppColors.attendanceGood,
    attendanceWarning: AppColors.attendanceWarning,
    attendanceCritical: AppColors.attendanceCritical,
    present: AppColors.present,
    absent: AppColors.absent,
    leave: AppColors.leave,
    calendarToday: AppColors.calendarToday,
    calendarSelected: AppColors.calendarSelected,
    primaryGradient: AppColors.primaryGradient,
    attendanceGoodGradient: AppColors.attendanceGoodGradient,
    attendanceWarningGradient: AppColors.attendanceWarningGradient,
    attendanceCriticalGradient: AppColors.attendanceCriticalGradient,
  );
}

// Custom theme extension for app-specific dimensions
@immutable
class AppDimensionsTheme extends ThemeExtension<AppDimensionsTheme> {
  final double attendanceCardHeight;
  final double percentageIndicatorSize;
  final double calendarCellHeight;
  final double calendarHeaderHeight;

  const AppDimensionsTheme({
    required this.attendanceCardHeight,
    required this.percentageIndicatorSize,
    required this.calendarCellHeight,
    required this.calendarHeaderHeight,
  });

  @override
  AppDimensionsTheme copyWith({
    double? attendanceCardHeight,
    double? percentageIndicatorSize,
    double? calendarCellHeight,
    double? calendarHeaderHeight,
  }) {
    return AppDimensionsTheme(
      attendanceCardHeight: attendanceCardHeight ?? this.attendanceCardHeight,
      percentageIndicatorSize: percentageIndicatorSize ?? this.percentageIndicatorSize,
      calendarCellHeight: calendarCellHeight ?? this.calendarCellHeight,
      calendarHeaderHeight: calendarHeaderHeight ?? this.calendarHeaderHeight,
    );
  }

  @override
  AppDimensionsTheme lerp(AppDimensionsTheme? other, double t) {
    if (other is! AppDimensionsTheme) {
      return this;
    }
    return AppDimensionsTheme(
      attendanceCardHeight: lerpDouble(attendanceCardHeight, other.attendanceCardHeight, t)!,
      percentageIndicatorSize: lerpDouble(percentageIndicatorSize, other.percentageIndicatorSize, t)!,
      calendarCellHeight: lerpDouble(calendarCellHeight, other.calendarCellHeight, t)!,
      calendarHeaderHeight: lerpDouble(calendarHeaderHeight, other.calendarHeaderHeight, t)!,
    );
  }

  static const standard = AppDimensionsTheme(
    attendanceCardHeight: AppDimensions.attendanceCardHeight,
    percentageIndicatorSize: AppDimensions.percentageIndicatorSize,
    calendarCellHeight: AppDimensions.calendarCellHeight,
    calendarHeaderHeight: AppDimensions.calendarHeaderHeight,
  );
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

// Helper function to get attendance color based on percentage
Color getAttendanceColor(double percentage) {
  if (percentage >= 85) {
    return AppColors.attendanceGood;
  } else if (percentage >= 75) {
    return AppColors.attendanceWarning;
  } else {
    return AppColors.attendanceCritical;
  }
}

// Helper function to get attendance gradient based on percentage
LinearGradient getAttendanceGradient(double percentage) {
  if (percentage >= 85) {
    return AppColors.attendanceGoodGradient;
  } else if (percentage >= 75) {
    return AppColors.attendanceWarningGradient;
  } else {
    return AppColors.attendanceCriticalGradient;
  }
}

// Helper function to get attendance text style based on percentage
TextStyle getAttendanceTextStyle(double percentage) {
  if (percentage >= 85) {
    return AppTextStyles.percentageGood;
  } else if (percentage >= 75) {
    return AppTextStyles.percentageWarning;
  } else {
    return AppTextStyles.percentageCritical;
  }
}

// ============================================================================
// APP THEME
// ============================================================================

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: AppColors.background,
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        margin: EdgeInsets.all(AppDimensions.paddingSmall),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLarge,
            vertical: AppDimensions.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          textStyle: AppTextStyles.buttonText,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        ),
        contentPadding: EdgeInsets.all(AppDimensions.paddingMedium),
        labelStyle: AppTextStyles.inputLabel,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: AppColors.background,
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        margin: EdgeInsets.all(AppDimensions.paddingSmall),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLarge,
            vertical: AppDimensions.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          textStyle: AppTextStyles.buttonText,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        ),
        contentPadding: EdgeInsets.all(AppDimensions.paddingMedium),
        labelStyle: AppTextStyles.inputLabel,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }
}