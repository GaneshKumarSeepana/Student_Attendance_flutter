// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthService on _AuthService, Store {
  late final _$isLoggedInAtom = Atom(
    name: '_AuthService.isLoggedIn',
    context: context,
  );

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$studentIdAtom = Atom(
    name: '_AuthService.studentId',
    context: context,
  );

  @override
  String? get studentId {
    _$studentIdAtom.reportRead();
    return super.studentId;
  }

  @override
  set studentId(String? value) {
    _$studentIdAtom.reportWrite(value, super.studentId, () {
      super.studentId = value;
    });
  }

  late final _$studentNameAtom = Atom(
    name: '_AuthService.studentName',
    context: context,
  );

  @override
  String? get studentName {
    _$studentNameAtom.reportRead();
    return super.studentName;
  }

  @override
  set studentName(String? value) {
    _$studentNameAtom.reportWrite(value, super.studentName, () {
      super.studentName = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AuthService.errorMessage',
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

  late final _$isLoadingAtom = Atom(
    name: '_AuthService.isLoading',
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

  late final _$initializeAsyncAction = AsyncAction(
    '_AuthService.initialize',
    context: context,
  );

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$loginAsyncAction = AsyncAction(
    '_AuthService.login',
    context: context,
  );

  @override
  Future<bool> login(String studentIdInput, String password) {
    return _$loginAsyncAction.run(() => super.login(studentIdInput, password));
  }

  late final _$signupAsyncAction = AsyncAction(
    '_AuthService.signup',
    context: context,
  );

  @override
  Future<bool> signup(String studentIdInput, String name, String password) {
    return _$signupAsyncAction.run(
      () => super.signup(studentIdInput, name, password),
    );
  }

  late final _$logoutAsyncAction = AsyncAction(
    '_AuthService.logout',
    context: context,
  );

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$_AuthServiceActionController = ActionController(
    name: '_AuthService',
    context: context,
  );

  @override
  void setError(String error) {
    final _$actionInfo = _$_AuthServiceActionController.startAction(
      name: '_AuthService.setError',
    );
    try {
      return super.setError(error);
    } finally {
      _$_AuthServiceActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_AuthServiceActionController.startAction(
      name: '_AuthService.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_AuthServiceActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$_AuthServiceActionController.startAction(
      name: '_AuthService.setLoading',
    );
    try {
      return super.setLoading(loading);
    } finally {
      _$_AuthServiceActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
studentId: ${studentId},
studentName: ${studentName},
errorMessage: ${errorMessage},
isLoading: ${isLoading}
    ''';
  }
}
