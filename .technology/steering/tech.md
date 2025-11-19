# Technology Stack

## Framework & Language
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language (SDK ^3.9.2)

## State Management
- **MobX**: Reactive state management with code generation
- **flutter_mobx**: Flutter integration for MobX observers

## Key Dependencies
- **sqflite**: Local SQLite database for data persistence
- **shared_preferences**: Simple key-value storage
- **table_calendar**: Calendar UI component
- **percent_indicator**: Visual percentage displays
- **pdf & printing**: Report generation and export
- **intl**: Date formatting and internationalization
- **crypto**: Password hashing and security

## Development Tools
- **mobx_codegen**: Code generation for MobX stores
- **build_runner**: Dart build system for code generation
- **flutter_lints**: Recommended linting rules
- **mockito**: Mocking framework for testing
- **sqflite_common_ffi**: SQLite testing support

## Common Commands

### Setup & Dependencies
```bash
flutter pub get                           # Install dependencies
flutter pub run build_runner build       # Generate MobX code
flutter pub run build_runner watch       # Watch for changes and regenerate
```

### Development
```bash
flutter run                              # Run app in debug mode
flutter run --release                   # Run in release mode
flutter analyze                         # Static analysis
flutter test                           # Run all tests
```

### Code Generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs  # Clean rebuild
```

### Testing
```bash
flutter test test/attendance_test.dart   # Run specific test file
flutter test --coverage                 # Run tests with coverage
```

## Build Targets
- Android (primary)
- iOS
- Web
- Windows, macOS, Linux (desktop support available)