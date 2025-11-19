# Student Attendance System

A Flutter application for tracking student attendance across multiple courses with analytics.

## Features

- **MobX State Management**: Efficient state management for attendance records, statistics, and course data
- **Authentication**: Login with student ID and password
- **Data Persistence**: Store attendance data locally with proper structure using SQFlite
- **Attendance Tracking**: Mark daily attendance (Present, Absent, Leave) for each subject
- **Visual Analytics**: View attendance percentage by subject/course with color-coded indicators
- **Calendar View**: Display attendance history in a calendar view with color coding
- **Alerts**: Show alerts when attendance falls below 75% threshold
- **Reports**: Monthly and semester-wise attendance reports
- **Export**: Export attendance reports as PDF or share

## Folder Structure

```
lib/
├── models/              # Data models (Course, Attendance, Stats)
├── stores/              # MobX stores for state management
├── views/               # Screen-level UI components
├── widgets/             # Reusable UI components
├── services/            # Business logic and services
└── main.dart            # Entry point
```

## Dependencies

- **MobX**: State management
- **Table Calendar**: Calendar UI component
- **Percent Indicator**: Visual percentage indicators
- **PDF**: PDF generation
- **Intl**: Date formatting
- **SQFlite**: Local database storage
- **Shared Preferences**: Simple local storage

## Testing

The application includes comprehensive tests:

- **Unit Tests**: For attendance calculation logic
- **Widget Tests**: For UI components

Run tests with:
```bash
flutter test
```

## Industrial Best Practices

- **Logic Testing**: Comprehensive unit tests for attendance calculation logic
- **Widget Testing**: Tests for calendar component and attendance cards
- **Reusable Widgets**: AttendanceCard, CalendarView, PercentageIndicator, SubjectCard, AlertBanner
- **Color Coding**: Intuitive color system (green for good, yellow for warning, red for critical)
- **Theme Consistency**: Custom app bar, bottom navigation, and consistent UI elements
- **Error Handling**: Graceful handling with snackbars, dialogs, and validation messages
- **Folder Structure**: Clean separation of models, stores, views, widgets, and utils

## Setup

1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter pub run build_runner build` to generate MobX code
4. Run `flutter run` to start the application

## Pro Tips Implemented

- Started with proper project structure and folder organization
- Implemented MobX stores before building UI components
- Wrote tests as we developed
- Kept widgets small and reusable
- Used meaningful variable and function names
- Commented complex business logic