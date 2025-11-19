// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CourseStore on _CourseStore, Store {
  late final _$coursesAtom = Atom(
    name: '_CourseStore.courses',
    context: context,
  );

  @override
  ObservableList<Course> get courses {
    _$coursesAtom.reportRead();
    return super.courses;
  }

  @override
  set courses(ObservableList<Course> value) {
    _$coursesAtom.reportWrite(value, super.courses, () {
      super.courses = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_CourseStore.isLoading',
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

  late final _$loadCoursesAsyncAction = AsyncAction(
    '_CourseStore.loadCourses',
    context: context,
  );

  @override
  Future<void> loadCourses() {
    return _$loadCoursesAsyncAction.run(() => super.loadCourses());
  }

  late final _$_initializeSampleCoursesAsyncAction = AsyncAction(
    '_CourseStore._initializeSampleCourses',
    context: context,
  );

  @override
  Future<void> _initializeSampleCourses() {
    return _$_initializeSampleCoursesAsyncAction.run(
      () => super._initializeSampleCourses(),
    );
  }

  late final _$addCourseAsyncAction = AsyncAction(
    '_CourseStore.addCourse',
    context: context,
  );

  @override
  Future<void> addCourse(Course course) {
    return _$addCourseAsyncAction.run(() => super.addCourse(course));
  }

  late final _$updateCourseAsyncAction = AsyncAction(
    '_CourseStore.updateCourse',
    context: context,
  );

  @override
  Future<void> updateCourse(Course course) {
    return _$updateCourseAsyncAction.run(() => super.updateCourse(course));
  }

  late final _$deleteCourseAsyncAction = AsyncAction(
    '_CourseStore.deleteCourse',
    context: context,
  );

  @override
  Future<void> deleteCourse(String courseId) {
    return _$deleteCourseAsyncAction.run(() => super.deleteCourse(courseId));
  }

  late final _$_CourseStoreActionController = ActionController(
    name: '_CourseStore',
    context: context,
  );

  @override
  void setCurrentUserId(String? userId) {
    final _$actionInfo = _$_CourseStoreActionController.startAction(
      name: '_CourseStore.setCurrentUserId',
    );
    try {
      return super.setCurrentUserId(userId);
    } finally {
      _$_CourseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
courses: ${courses},
isLoading: ${isLoading}
    ''';
  }
}
