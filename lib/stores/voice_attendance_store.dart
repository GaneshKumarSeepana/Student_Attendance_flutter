import 'package:mobx/mobx.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student/models/attendance.dart';
import 'package:student/stores/attendance_store.dart';
import 'package:student/stores/course_store.dart';

part 'voice_attendance_store.g.dart';

class VoiceAttendanceStore = _VoiceAttendanceStore with _$VoiceAttendanceStore;

abstract class _VoiceAttendanceStore with Store {
  final AttendanceStore _attendanceStore;
  final CourseStore _courseStore;
  final SpeechToText _speechToText = SpeechToText();

  _VoiceAttendanceStore(this._attendanceStore, this._courseStore);

  // Observable states
  @observable
  bool isListening = false;

  @observable
  bool isInitialized = false;

  @observable
  String recognizedText = '';

  @observable
  String? errorMessage;

  @observable
  bool isProcessing = false;

  @observable
  String? selectedCourseId;

  @observable
  AttendanceStatus? detectedStatus;

  @observable
  double confidence = 0.0;

  @observable
  String feedbackMessage = '';

  @observable
  DateTime selectedDate = DateTime.now();

  // Actions
  @action
  Future<void> initialize() async {
    try {
      // Request microphone permission
      final permissionStatus = await Permission.microphone.request();
      
      if (permissionStatus != PermissionStatus.granted) {
        setError('Microphone permission is required for voice attendance');
        return;
      }

      // Initialize speech to text
      final available = await _speechToText.initialize(
        onError: (error) => setError('Speech recognition error: ${error.errorMsg}'),
        onStatus: (status) => _handleStatusChange(status),
      );

      if (available) {
        isInitialized = true;
        clearError();
        setFeedback('Voice attendance ready! Say "Present", "Absent", or "Leave"');
      } else {
        setError('Speech recognition not available on this device');
      }
    } catch (e) {
      setError('Failed to initialize voice recognition: $e');
    }
  }

  @action
  void _handleStatusChange(String status) {
    print('Speech status: $status'); // Debug log
    if (status == 'listening') {
      isListening = true;
      setFeedback('🎤 Listening... Say "Present", "Absent", or "Leave"');
    } else if (status == 'notListening') {
      isListening = false;
      if (detectedStatus == null && recognizedText.isEmpty) {
        setFeedback('No speech detected. Try again.');
      }
    } else if (status == 'done') {
      isListening = false;
      if (detectedStatus != null) {
        setFeedback('✅ Ready to mark as ${_getStatusText(detectedStatus!)}');
      }
    }
  }

  @action
  Future<void> startListening() async {
    if (!isInitialized) {
      await initialize();
      if (!isInitialized) return;
    }

    try {
      clearError();
      recognizedText = '';
      detectedStatus = null;
      confidence = 0.0;
      isListening = true; // Explicitly set listening state
      
      await _speechToText.listen(
        onResult: _handleSpeechResult,
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 2),
        partialResults: false, // Only get final results for better accuracy
        localeId: 'en_US',
        cancelOnError: true,
        listenMode: ListenMode.confirmation, // Wait for clear speech
      );
      
      setFeedback('🎤 Listening... Say "Present", "Absent", or "Leave"');
    } catch (e) {
      isListening = false;
      setError('Failed to start listening: $e');
    }
  }

  @action
  void _handleSpeechResult(result) {
    recognizedText = result.recognizedWords.toLowerCase();
    confidence = result.confidence;
    
    // Process the recognized text to detect attendance status
    _processRecognizedText(recognizedText);
  }

  @action
  void _processRecognizedText(String text) {
    final cleanText = text.trim().toLowerCase();
    
    // More specific keyword matching to avoid false positives
    AttendanceStatus? status;
    double matchConfidence = 0.0;
    
    // Exact word matching for better accuracy
    final words = cleanText.split(' ');
    
    // Check for present keywords
    if (words.contains('present') || words.contains('here') || 
        words.contains('attending') || cleanText == 'yes') {
      status = AttendanceStatus.present;
      matchConfidence = 0.9;
    }
    // Check for absent keywords  
    else if (words.contains('absent') || words.contains('missing') || 
             cleanText.contains('not here') || cleanText == 'no') {
      status = AttendanceStatus.absent;
      matchConfidence = 0.9;
    }
    // Check for leave keywords
    else if (words.contains('leave') || words.contains('sick') || 
             words.contains('medical') || words.contains('emergency')) {
      status = AttendanceStatus.leave;
      matchConfidence = 0.9;
    }
    
    // Only accept if both speech confidence and keyword match are high
    if (status != null && confidence > 0.6 && matchConfidence > 0.8) {
      detectedStatus = status;
      setFeedback('✅ Detected: ${_getStatusText(status)} (${(confidence * 100).toInt()}% confidence)');
    } else if (cleanText.isNotEmpty && cleanText.length > 2) {
      setFeedback('🎤 Say clearly: "Present", "Absent", or "Leave"');
    }
  }

  @action
  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
      isListening = false;
      
      if (detectedStatus != null && confidence > 0.7) {
        setFeedback('Ready to mark attendance as ${_getStatusText(detectedStatus!)}');
      } else {
        setFeedback('No clear attendance status detected. Try again.');
      }
    } catch (e) {
      setError('Failed to stop listening: $e');
    }
  }

  @action
  Future<bool> markAttendanceWithVoice({
    required String courseId,
    DateTime? date,
    String? note,
  }) async {
    if (detectedStatus == null) {
      setError('No attendance status detected. Please use voice command first.');
      return false;
    }

    try {
      isProcessing = true;
      clearError();
      
      final attendanceDate = date ?? selectedDate;
      
      final success = await _attendanceStore.markAttendance(
        courseId: courseId,
        date: attendanceDate,
        status: detectedStatus!,
        note: note ?? 'Marked via voice: "$recognizedText" for ${attendanceDate.day}/${attendanceDate.month}/${attendanceDate.year}',
      );

      if (success) {
        // Reload attendance records to ensure UI updates
        await _attendanceStore.loadAttendanceRecords();
        setFeedback('✅ Attendance marked as ${_getStatusText(detectedStatus!)} via voice for ${attendanceDate.day}/${attendanceDate.month}/${attendanceDate.year}');
        _resetVoiceState();
        return true;
      } else {
        setError('Failed to mark attendance');
        return false;
      }
    } catch (e) {
      setError('Error marking attendance: $e');
      return false;
    } finally {
      isProcessing = false;
    }
  }

  @action
  Future<bool> quickVoiceAttendance(String courseId) async {
    if (!isInitialized) {
      await initialize();
      if (!isInitialized) return false;
    }

    selectedCourseId = courseId;
    await startListening();
    
    // Wait for speech recognition to complete
    await Future.delayed(const Duration(seconds: 8));
    
    if (isListening) {
      await stopListening();
    }
    
    if (detectedStatus != null && confidence > 0.7) {
      return await markAttendanceWithVoice(
        courseId: courseId,
        date: selectedDate,
      );
    }
    
    return false;
  }

  @action
  void setError(String error) {
    errorMessage = error;
    feedbackMessage = '';
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void setFeedback(String message) {
    feedbackMessage = message;
    errorMessage = null;
  }

  @action
  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  @action
  void _resetVoiceState() {
    recognizedText = '';
    detectedStatus = null;
    confidence = 0.0;
    selectedCourseId = null;
  }

  @action
  void reset() {
    _resetVoiceState();
    clearError();
    feedbackMessage = '';
    if (isListening) {
      stopListening();
    }
  }

  // Computed properties
  @computed
  bool get canMarkAttendance => 
      detectedStatus != null && 
      confidence > 0.7 && 
      !isProcessing;

  @computed
  String get statusText => detectedStatus != null 
      ? _getStatusText(detectedStatus!)
      : 'None';

  @computed
  bool get hasValidDetection => 
      detectedStatus != null && confidence > 0.7;

  // Helper methods
  String _getStatusText(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.leave:
        return 'Leave';
    }
  }

  // Dispose method
  void dispose() {
    if (isListening) {
      _speechToText.stop();
    }
  }
}