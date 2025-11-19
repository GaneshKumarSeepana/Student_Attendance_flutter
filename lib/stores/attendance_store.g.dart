// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AttendanceStore on _AttendanceStore, Store {
  Computed<List<Attendance>>? _$attendanceForSelectedDateComputed;

  @override
  List<Attendance> get attendanceForSelectedDate =>
      (_$attendanceForSelectedDateComputed ??= Computed<List<Attendance>>(
        () => super.attendanceForSelectedDate,
        name: '_AttendanceStore.attendanceForSelectedDate',
      )).value;
  Computed<List<Attendance>>? _$attendanceForSelectedCourseComputed;

  @override
  List<Attendance> get attendanceForSelectedCourse =>
      (_$attendanceForSelectedCourseComputed ??= Computed<List<Attendance>>(
        () => super.attendanceForSelectedCourse,
        name: '_AttendanceStore.attendanceForSelectedCourse',
      )).value;
  Computed<AttendanceStats>? _$overallStatsComputed;

  @override
  AttendanceStats get overallStats =>
      (_$overallStatsComputed ??= Computed<AttendanceStats>(
        () => super.overallStats,
        name: '_AttendanceStore.overallStats',
      )).value;
  Computed<List<String>>? _$lowAttendanceCoursesComputed;

  @override
  List<String> get lowAttendanceCourses =>
      (_$lowAttendanceCoursesComputed ??= Computed<List<String>>(
        () => super.lowAttendanceCourses,
        name: '_AttendanceStore.lowAttendanceCourses',
      )).value;

  late final _$attendanceRecordsAtom = Atom(
    name: '_AttendanceStore.attendanceRecords',
    context: context,
  );

  @override
  ObservableList<Attendance> get attendanceRecords {
    _$attendanceRecordsAtom.reportRead();
    return super.attendanceRecords;
  }

  @override
  set attendanceRecords(ObservableList<Attendance> value) {
    _$attendanceRecordsAtom.reportWrite(value, super.attendanceRecords, () {
      super.attendanceRecords = value;
    });
  }

  late final _$attendanceStatsAtom = Atom(
    name: '_AttendanceStore.attendanceStats',
    context: context,
  );

  @override
  ObservableMap<String, AttendanceStats> get attendanceStats {
    _$attendanceStatsAtom.reportRead();
    return super.attendanceStats;
  }

  @override
  set attendanceStats(ObservableMap<String, AttendanceStats> value) {
    _$attendanceStatsAtom.reportWrite(value, super.attendanceStats, () {
      super.attendanceStats = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_AttendanceStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AttendanceStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$selectedDateAtom = Atom(
    name: '_AttendanceStore.selectedDate',
    context: context,
  );

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$selectedCourseIdAtom = Atom(
    name: '_AttendanceStore.selectedCourseId',
    context: context,
  );

  @override
  String? get selectedCourseId {
    _$selectedCourseIdAtom.reportRead();
    return super.selectedCourseId;
  }

  @override
  set selectedCourseId(String? value) {
    _$selectedCourseIdAtom.reportWrite(value, super.selectedCourseId, () {
      super.selectedCourseId = value;
    });
  }

  late final _$initializeSampleDataAsyncAction = AsyncAction(
    '_AttendanceStore.initializeSampleData',
    context: context,
  );

  @override
  Future<void> initializeSampleData(List<String> courseIds) {
    return _$initializeSampleDataAsyncAction.run(
      () => super.initializeSampleData(courseIds),
    );
  }

  late final _$loadAttendanceRecordsAsyncAction = AsyncAction(
    '_AttendanceStore.loadAttendanceRecords',
    context: context,
  );

  @override
  Future<void> loadAttendanceRecords() {
    return _$loadAttendanceRecordsAsyncAction.run(
      () => super.loadAttendanceRecords(),
    );
  }

  late final _$addAttendanceAsyncAction = AsyncAction(
    '_AttendanceStore.addAttendance',
    context: context,
  );

  @override
  Future<void> addAttendance(Attendance attendance) {
    return _$addAttendanceAsyncAction.run(
      () => super.addAttendance(attendance),
    );
  }

  late final _$updateAttendanceAsyncAction = AsyncAction(
    '_AttendanceStore.updateAttendance',
    context: context,
  );

  @override
  Future<void> updateAttendance(Attendance attendance) {
    return _$updateAttendanceAsyncAction.run(
      () => super.updateAttendance(attendance),
    );
  }

  late final _$deleteAttendanceAsyncAction = AsyncAction(
    '_AttendanceStore.deleteAttendance',
    context: context,
  );

  @override
  Future<void> deleteAttendance(String attendanceId) {
    return _$deleteAttendanceAsyncAction.run(
      () => super.deleteAttendance(attendanceId),
    );
  }

  late final _$markAttendanceAsyncAction = AsyncAction(
    '_AttendanceStore.markAttendance',
    context: context,
  );

  @override
  Future<bool> markAttendance({
    required String courseId,
    required DateTime date,
    required AttendanceStatus status,
    String? note,
  }) {
    return _$markAttendanceAsyncAction.run(
      () => super.markAttendance(
        courseId: courseId,
        date: date,
        status: status,
        note: note,
      ),
    );
  }

  late final _$_AttendanceStoreActionController = ActionController(
    name: '_AttendanceStore',
    context: context,
  );

  @override
  void setCurrentUserId(String? userId) {
    final _$actionInfo = _$_AttendanceStoreActionController.startAction(
      name: '_AttendanceStore.setCurrentUserId',
    );
    try {
      return super.setCurrentUserId(userId);
    } finally {
      _$_AttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void calculateAllStats() {
    final _$actionInfo = _$_AttendanceStoreActionController.startAction(
      name: '_AttendanceStore.calculateAllStats',
    );
    try {
      return super.calculateAllStats();
    } finally {
      _$_AttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void calculateStatsForCourse(String courseId) {
    final _$actionInfo = _$_AttendanceStoreActionController.startAction(
      name: '_AttendanceStore.calculateStatsForCourse',
    );
    try {
      return super.calculateStatsForCourse(courseId);
    } finally {
      _$_AttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDate(DateTime date) {
    final _$actionInfo = _$_AttendanceStoreActionController.startAction(
      name: '_AttendanceStore.setSelectedDate',
    );
    try {
      return super.setSelectedDate(date);
    } finally {
      _$_AttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedCourse(String? courseId) {
    final _$actionInfo = _$_AttendanceStoreActionController.startAction(
      name: '_AttendanceStore.setSelectedCourse',
    );
    try {
      return super.setSelectedCourse(courseId);
    } finally {
      _$_AttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_AttendanceStoreActionController.startAction(
      name: '_AttendanceStore.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_AttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String error) {
    final _$actionInfo = _$_AttendanceStoreActionController.startAction(
      name: '_AttendanceStore.setError',
    );
    try {
      return super.setError(error);
    } finally {
      _$_AttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
attendanceRecords: ${attendanceRecords},
attendanceStats: ${attendanceStats},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
selectedDate: ${selectedDate},
selectedCourseId: ${selectedCourseId},
attendanceForSelectedDate: ${attendanceForSelectedDate},
attendanceForSelectedCourse: ${attendanceForSelectedCourse},
overallStats: ${overallStats},
lowAttendanceCourses: ${lowAttendanceCourses}
    ''';
  }
}
