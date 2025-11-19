# Student Attendance System

A Flutter mobile application for tracking student attendance across multiple courses with comprehensive analytics and reporting features.

## Core Features

- **Authentication**: Student ID and password-based login system
- **Attendance Tracking**: Daily attendance marking (Present, Absent, Leave) per subject
- **Visual Analytics**: Color-coded attendance percentages and statistics
- **Calendar Integration**: Historical attendance view with intuitive color coding
- **Alert System**: Automatic warnings when attendance drops below 75% threshold
- **Reporting**: Monthly and semester-wise attendance reports with PDF export
- **Data Persistence**: Local SQLite database for offline functionality

## Target Users

Students who need to track their attendance across multiple courses and maintain the minimum attendance requirements for academic eligibility.

## Key Business Rules

- 75% attendance threshold triggers warning alerts
- Color coding: Green (good), Yellow (warning), Red (critical)
- Supports multiple courses/subjects per student
- Offline-first approach with local data storage