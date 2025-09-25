import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class PerformanceTest extends StatefulWidget {
  const PerformanceTest({super.key});

  @override
  State<PerformanceTest> createState() => _PerformanceTestState();
}

class _PerformanceTestState extends State<PerformanceTest> {
  late EventsController eventsController;
  bool _enableDebugLogs = false;
  double _sensitivity = 0.8;
  int _batchThreshold = 3;

  @override
  void initState() {
    super.initState();
    eventsController = EventsController();
    
    // Add multiple events for testing
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents([
        Event(
          title: 'Performance Test Event 1',
          description: 'Testing diagonal scroll performance',
          startTime: DateTime.now().add(const Duration(hours: 1)),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          color: Colors.blue,
        ),
        Event(
          title: 'Performance Test Event 2',
          description: 'Another test event',
          startTime: DateTime.now().add(const Duration(hours: 3)),
          endTime: DateTime.now().add(const Duration(hours: 4)),
          color: Colors.green,
        ),
        Event(
          title: 'Performance Test Event 3',
          description: 'Third test event',
          startTime: DateTime.now().add(const Duration(hours: 5)),
          endTime: DateTime.now().add(const Duration(hours: 6)),
          color: Colors.orange,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Test'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_enableDebugLogs ? Icons.bug_report : Icons.bug_report_outlined),
            onPressed: () {
              setState(() {
                _enableDebugLogs = !_enableDebugLogs;
              });
            },
            tooltip: 'Toggle Debug Logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Performance controls
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.purple.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '⚡ PERFORMANCE CONTROLS:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Sensitivity control
                Row(
                  children: [
                    const Text('Sensitivity: '),
                    Expanded(
                      child: Slider(
                        value: _sensitivity,
                        min: 0.1,
                        max: 2.0,
                        divisions: 19,
                        label: _sensitivity.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            _sensitivity = value;
                          });
                        },
                      ),
                    ),
                    Text(_sensitivity.toStringAsFixed(1)),
                  ],
                ),
                
                // Debug logs toggle
                Row(
                  children: [
                    const Text('Debug Logs: '),
                    Switch(
                      value: _enableDebugLogs,
                      onChanged: (value) {
                        setState(() {
                          _enableDebugLogs = value;
                        });
                      },
                    ),
                    Text(_enableDebugLogs ? 'ON' : 'OFF'),
                  ],
                ),
                
                // Performance tips
                const Text(
                  '💡 TIPS: Lower sensitivity = smoother, Higher sensitivity = more responsive',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // EventsPlanner with performance settings
          Expanded(
            child: EventsPlanner(
              controller: eventsController,
              daysShowed: 5, // More days for better testing
              
              // Performance-optimized settings
              enableDiagonalScroll: true,
              diagonalScrollSensitivity: _sensitivity,
              
              // Optimized configuration
              diagonalScrollParam: DiagonalScrollParam(
                gestureConflictResolution: true,
                pinchToZoomPriority: false, // Disable for testing
                dragEventPriority: false,   // Disable for testing
                tapEventThreshold: 10.0,
                tapEventDuration: 200,
              ),
              
              // Disable auto-adjust for free scrolling
              automaticAdjustHorizontalScrollToDay: false,
              
              // Smooth physics
              horizontalScrollPhysics: const ClampingScrollPhysics(),
              verticalScrollPhysics: const ClampingScrollPhysics(),
              
              // Debug callbacks (only if enabled)
              onDayChange: _enableDebugLogs ? (day) {
                debugPrint('📅 PERFORMANCE TEST: Day changed to ${day.day}/${day.month}/${day.year}');
              } : null,
              onVerticalScrollChange: _enableDebugLogs ? (offset) {
                debugPrint('⏰ PERFORMANCE TEST: Time changed to offset ${offset.toStringAsFixed(1)}');
              } : null,
              
              // Day parameters
              dayParam: DayParam(
                todayColor: Colors.purple.withOpacity(0.1),
                onSlotTap: _enableDebugLogs ? (column, exact, rounded) {
                  debugPrint('👆 PERFORMANCE TEST: Slot tapped at ${rounded.hour}:${rounded.minute.toString().padLeft(2, '0')}');
                } : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    eventsController.dispose();
    super.dispose();
  }
}
