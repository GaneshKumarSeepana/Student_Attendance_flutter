// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_attendance_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VoiceAttendanceStore on _VoiceAttendanceStore, Store {
  Computed<bool>? _$canMarkAttendanceComputed;

  @override
  bool get canMarkAttendance => (_$canMarkAttendanceComputed ??= Computed<bool>(
    () => super.canMarkAttendance,
    name: '_VoiceAttendanceStore.canMarkAttendance',
  )).value;
  Computed<String>? _$statusTextComputed;

  @override
  String get statusText => (_$statusTextComputed ??= Computed<String>(
    () => super.statusText,
    name: '_VoiceAttendanceStore.statusText',
  )).value;
  Computed<bool>? _$hasValidDetectionComputed;

  @override
  bool get hasValidDetection => (_$hasValidDetectionComputed ??= Computed<bool>(
    () => super.hasValidDetection,
    name: '_VoiceAttendanceStore.hasValidDetection',
  )).value;

  late final _$isListeningAtom = Atom(
    name: '_VoiceAttendanceStore.isListening',
    context: context,
  );

  @override
  bool get isListening {
    _$isListeningAtom.reportRead();
    return super.isListening;
  }

  @override
  set isListening(bool value) {
    _$isListeningAtom.reportWrite(value, super.isListening, () {
      super.isListening = value;
    });
  }

  late final _$isInitializedAtom = Atom(
    name: '_VoiceAttendanceStore.isInitialized',
    context: context,
  );

  @override
  bool get isInitialized {
    _$isInitializedAtom.reportRead();
    return super.isInitialized;
  }

  @override
  set isInitialized(bool value) {
    _$isInitializedAtom.reportWrite(value, super.isInitialized, () {
      super.isInitialized = value;
    });
  }

  late final _$recognizedTextAtom = Atom(
    name: '_VoiceAttendanceStore.recognizedText',
    context: context,
  );

  @override
  String get recognizedText {
    _$recognizedTextAtom.reportRead();
    return super.recognizedText;
  }

  @override
  set recognizedText(String value) {
    _$recognizedTextAtom.reportWrite(value, super.recognizedText, () {
      super.recognizedText = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_VoiceAttendanceStore.errorMessage',
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

  late final _$isProcessingAtom = Atom(
    name: '_VoiceAttendanceStore.isProcessing',
    context: context,
  );

  @override
  bool get isProcessing {
    _$isProcessingAtom.reportRead();
    return super.isProcessing;
  }

  @override
  set isProcessing(bool value) {
    _$isProcessingAtom.reportWrite(value, super.isProcessing, () {
      super.isProcessing = value;
    });
  }

  late final _$selectedCourseIdAtom = Atom(
    name: '_VoiceAttendanceStore.selectedCourseId',
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

  late final _$detectedStatusAtom = Atom(
    name: '_VoiceAttendanceStore.detectedStatus',
    context: context,
  );

  @override
  AttendanceStatus? get detectedStatus {
    _$detectedStatusAtom.reportRead();
    return super.detectedStatus;
  }

  @override
  set detectedStatus(AttendanceStatus? value) {
    _$detectedStatusAtom.reportWrite(value, super.detectedStatus, () {
      super.detectedStatus = value;
    });
  }

  late final _$confidenceAtom = Atom(
    name: '_VoiceAttendanceStore.confidence',
    context: context,
  );

  @override
  double get confidence {
    _$confidenceAtom.reportRead();
    return super.confidence;
  }

  @override
  set confidence(double value) {
    _$confidenceAtom.reportWrite(value, super.confidence, () {
      super.confidence = value;
    });
  }

  late final _$feedbackMessageAtom = Atom(
    name: '_VoiceAttendanceStore.feedbackMessage',
    context: context,
  );

  @override
  String get feedbackMessage {
    _$feedbackMessageAtom.reportRead();
    return super.feedbackMessage;
  }

  @override
  set feedbackMessage(String value) {
    _$feedbackMessageAtom.reportWrite(value, super.feedbackMessage, () {
      super.feedbackMessage = value;
    });
  }

  late final _$selectedDateAtom = Atom(
    name: '_VoiceAttendanceStore.selectedDate',
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

  late final _$initializeAsyncAction = AsyncAction(
    '_VoiceAttendanceStore.initialize',
    context: context,
  );

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$startListeningAsyncAction = AsyncAction(
    '_VoiceAttendanceStore.startListening',
    context: context,
  );

  @override
  Future<void> startListening() {
    return _$startListeningAsyncAction.run(() => super.startListening());
  }

  late final _$stopListeningAsyncAction = AsyncAction(
    '_VoiceAttendanceStore.stopListening',
    context: context,
  );

  @override
  Future<void> stopListening() {
    return _$stopListeningAsyncAction.run(() => super.stopListening());
  }

  late final _$markAttendanceWithVoiceAsyncAction = AsyncAction(
    '_VoiceAttendanceStore.markAttendanceWithVoice',
    context: context,
  );

  @override
  Future<bool> markAttendanceWithVoice({
    required String courseId,
    DateTime? date,
    String? note,
  }) {
    return _$markAttendanceWithVoiceAsyncAction.run(
      () => super.markAttendanceWithVoice(
        courseId: courseId,
        date: date,
        note: note,
      ),
    );
  }

  late final _$quickVoiceAttendanceAsyncAction = AsyncAction(
    '_VoiceAttendanceStore.quickVoiceAttendance',
    context: context,
  );

  @override
  Future<bool> quickVoiceAttendance(String courseId) {
    return _$quickVoiceAttendanceAsyncAction.run(
      () => super.quickVoiceAttendance(courseId),
    );
  }

  late final _$_VoiceAttendanceStoreActionController = ActionController(
    name: '_VoiceAttendanceStore',
    context: context,
  );

  @override
  void _handleStatusChange(String status) {
    final _$actionInfo = _$_VoiceAttendanceStoreActionController.startAction(
      name: '_VoiceAttendanceStore._handleStatusChange',
    );
    try {
      return super._handleStatusChange(status);
    } finally {
      _$_VoiceAttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleSpeechResult(dynamic result) {
    final _$actionInfo = _$_VoiceAttendanceStoreActionController.startAction(
      name: '_VoiceAttendanceStore._handleSpeechResult',
    );
    try {
      return super._handleSpeechResult(result);
    } finally {
      _$_VoiceAttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _processRecognizedText(String text) {
    final _$actionInfo = _$_VoiceAttendanceStoreActionController.startAction(
      name: '_VoiceAttendanceStore._processRecognizedText',
    );
    try {
      return super._processRecognizedText(text);
    } finally {
      _$_VoiceAttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String error) {
    final _$actionInfo = _$_VoiceAttendanceStoreActionController.startAction(
      name: '_VoiceAttendanceStore.setError',
    );
    try {
      return super.setError(error);
    } finally {
      _$_VoiceAttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_VoiceAttendanceStoreActionController.startAction(
      name: '_VoiceAttendanceStore.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_VoiceAttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFeedback(String message) {
    final _$actionInfo = _$_VoiceAttendanceStoreActionController.startAction(
      name: '_VoiceAttendanceStore.setFeedback',
    );
    try {
      return super.setFeedback(message);
    } finally {
      _$_VoiceAttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDate(DateTime date) {
    final _$actionInfo = _$_VoiceAttendanceStoreActionController.startAction(
      name: '_VoiceAttendanceStore.setSelectedDate',
    );
    try {
      return super.setSelectedDate(date);
    } finally {
      _$_VoiceAttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _resetVoiceState() {
    final _$actionInfo = _$_VoiceAttendanceStoreActionController.startAction(
      name: '_VoiceAttendanceStore._resetVoiceState',
    );
    try {
      return super._resetVoiceState();
    } finally {
      _$_VoiceAttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_VoiceAttendanceStoreActionController.startAction(
      name: '_VoiceAttendanceStore.reset',
    );
    try {
      return super.reset();
    } finally {
      _$_VoiceAttendanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isListening: ${isListening},
isInitialized: ${isInitialized},
recognizedText: ${recognizedText},
errorMessage: ${errorMessage},
isProcessing: ${isProcessing},
selectedCourseId: ${selectedCourseId},
detectedStatus: ${detectedStatus},
confidence: ${confidence},
feedbackMessage: ${feedbackMessage},
selectedDate: ${selectedDate},
canMarkAttendance: ${canMarkAttendance},
statusText: ${statusText},
hasValidDetection: ${hasValidDetection}
    ''';
  }
}
