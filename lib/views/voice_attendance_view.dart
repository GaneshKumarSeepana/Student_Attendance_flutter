import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:student/stores/main_store.dart';
import 'package:student/models/course.dart';
import 'package:student/models/attendance.dart';

class VoiceAttendanceView extends StatefulWidget {
  final MainStore mainStore;
  final Course? selectedCourse;

  const VoiceAttendanceView({
    Key? key,
    required this.mainStore,
    this.selectedCourse,
  }) : super(key: key);

  @override
  State<VoiceAttendanceView> createState() => _VoiceAttendanceViewState();
}

class _VoiceAttendanceViewState extends State<VoiceAttendanceView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Course? _selectedCourse;

  @override
  void initState() {
    super.initState();
    _selectedCourse = widget.selectedCourse;
    
    // Initialize voice attendance store
    widget.mainStore.voiceAttendanceStore.initialize();
    
    // Setup pulse animation for listening state
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    widget.mainStore.voiceAttendanceStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Attendance'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Observer(
        builder: (context) {
          final voiceStore = widget.mainStore.voiceAttendanceStore;
          
          // Control pulse animation based on listening state
          if (voiceStore.isListening) {
            _pulseController.repeat(reverse: true);
          } else {
            _pulseController.stop();
            _pulseController.reset();
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Course Selection
                _buildCourseSelection(),
                const SizedBox(height: 16),
                
                // Date Selection
                _buildDateSelection(),
                const SizedBox(height: 24),
                
                // Voice Recognition Status
                _buildVoiceStatus(),
                const SizedBox(height: 32),
                
                // Main Voice Button
                _buildVoiceButton(),
                const SizedBox(height: 24),
                
                // Recognition Results
                _buildRecognitionResults(),
                const SizedBox(height: 24),
                
                // Action Buttons
                _buildActionButtons(),
                
                const SizedBox(height: 32),
                
                // Instructions
                _buildInstructions(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseSelection() {
    return Observer(
      builder: (context) {
        final courses = widget.mainStore.courseStore.courses;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Course',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<Course>(
                  value: _selectedCourse,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Choose a course',
                  ),
                  items: courses.map((course) {
                    return DropdownMenuItem<Course>(
                      value: course,
                      child: Text('${course.name} (${course.code})'),
                    );
                  }).toList(),
                  onChanged: (course) {
                    setState(() {
                      _selectedCourse = course;
                    });
                    widget.mainStore.voiceAttendanceStore.reset();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateSelection() {
    return Observer(
      builder: (context) {
        final voiceStore = widget.mainStore.voiceAttendanceStore;
        final selectedDate = voiceStore.selectedDate;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to change the date for attendance marking',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVoiceStatus() {
    return Observer(
      builder: (context) {
        final voiceStore = widget.mainStore.voiceAttendanceStore;
        
        return Card(
          color: voiceStore.isListening 
              ? Colors.green.shade50 
              : Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  voiceStore.isListening ? Icons.mic : Icons.mic_off,
                  size: 32,
                  color: voiceStore.isListening ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  voiceStore.isListening 
                      ? 'Listening...' 
                      : voiceStore.isInitialized 
                          ? 'Ready to listen' 
                          : 'Initializing...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: voiceStore.isListening ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date: ${voiceStore.selectedDate.day}/${voiceStore.selectedDate.month}/${voiceStore.selectedDate.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (voiceStore.recognizedText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Heard: "${voiceStore.recognizedText}"',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVoiceButton() {
    return Observer(
      builder: (context) {
        final voiceStore = widget.mainStore.voiceAttendanceStore;
        
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: voiceStore.isListening ? _pulseAnimation.value : 1.0,
              child: GestureDetector(
                onTap: _selectedCourse != null && !voiceStore.isProcessing 
                    ? _handleVoiceButtonTap 
                    : null,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _selectedCourse != null
                        ? (voiceStore.isListening 
                            ? LinearGradient(
                                colors: [Colors.red.shade400, Colors.red.shade600],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [Colors.blue.shade400, Colors.blue.shade600],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ))
                        : LinearGradient(
                            colors: [Colors.grey.shade400, Colors.grey.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: voiceStore.isListening 
                            ? Colors.red.withOpacity(0.4)
                            : Colors.black.withOpacity(0.2),
                        blurRadius: voiceStore.isListening ? 12 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: voiceStore.isProcessing
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      : Icon(
                          voiceStore.isListening ? Icons.stop : Icons.mic,
                          size: 48,
                          color: Colors.white,
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecognitionResults() {
    return Observer(
      builder: (context) {
        final voiceStore = widget.mainStore.voiceAttendanceStore;
        
        if (voiceStore.detectedStatus == null) {
          return const SizedBox.shrink();
        }
        
        return Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  _getStatusIcon(voiceStore.detectedStatus!),
                  size: 48,
                  color: Attendance.getStatusColor(voiceStore.detectedStatus!),
                ),
                const SizedBox(height: 8),
                Text(
                  'Detected: ${voiceStore.statusText}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Confidence: ${(voiceStore.confidence * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Observer(
      builder: (context) {
        final voiceStore = widget.mainStore.voiceAttendanceStore;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mark Attendance Button
            ElevatedButton.icon(
              onPressed: voiceStore.canMarkAttendance && _selectedCourse != null
                  ? _markAttendance
                  : null,
              icon: voiceStore.isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: const Text('Mark Attendance'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            
            // Reset Button
            ElevatedButton.icon(
              onPressed: voiceStore.isListening ? null : _resetVoice,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInstructions() {
    return Observer(
      builder: (context) {
        final voiceStore = widget.mainStore.voiceAttendanceStore;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Instructions:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('1. Select a course from the dropdown'),
                const Text('2. Choose the date for attendance marking'),
                const Text('3. Tap the microphone button to start listening'),
                const Text('4. Say "Present", "Absent", or "Leave"'),
                const Text('5. Tap "Mark Attendance" to confirm'),
                
                if (voiceStore.feedbackMessage.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            voiceStore.feedbackMessage,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                if (voiceStore.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            voiceStore.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleVoiceButtonTap() {
    final voiceStore = widget.mainStore.voiceAttendanceStore;
    
    if (voiceStore.isListening) {
      voiceStore.stopListening();
    } else {
      voiceStore.startListening();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final voiceStore = widget.mainStore.voiceAttendanceStore;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: voiceStore.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      helpText: 'Select Attendance Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
    );
    
    if (picked != null) {
      voiceStore.setSelectedDate(picked);
      // Reset voice state when date changes
      voiceStore.reset();
    }
  }

  Future<void> _markAttendance() async {
    if (_selectedCourse == null) return;
    
    final success = await widget.mainStore.voiceAttendanceStore
        .markAttendanceWithVoice(
      courseId: _selectedCourse!.id,
    );
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Attendance marked successfully via voice!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back after successful marking
      Navigator.of(context).pop(true); // Return true to indicate success
    }
  }

  void _resetVoice() {
    widget.mainStore.voiceAttendanceStore.reset();
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.leave:
        return Icons.medical_services;
    }
  }
}