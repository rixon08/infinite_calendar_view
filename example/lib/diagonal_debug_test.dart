import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class DiagonalDebugTest extends StatefulWidget {
  const DiagonalDebugTest({super.key});

  @override
  State<DiagonalDebugTest> createState() => _DiagonalDebugTestState();
}

class _DiagonalDebugTestState extends State<DiagonalDebugTest> {
  late EventsController eventsController;
  String _lastGesture = 'None';
  String _lastMovement = 'None';

  @override
  void initState() {
    super.initState();
    eventsController = EventsController();
    
    // Add a simple event
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents([
        Event(
          title: 'Debug Test Event',
          description: 'Testing diagonal scroll detection',
          startTime: DateTime.now().add(const Duration(hours: 1)),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          color: Colors.red,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagonal Debug Test'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Debug info display
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🔍 DIAGONAL SCROLL DEBUG:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Last Gesture: $_lastGesture'),
                Text('Last Movement: $_lastMovement'),
                const SizedBox(height: 8),
                const Text(
                  'INSTRUCTIONS:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('1. Swipe diagonally (↗️↘️↙️↖️)'),
                const Text('2. Check console for debug messages'),
                const Text('3. Look for "DIAGONAL: Started" messages'),
                const Text('4. If only HORIZONTAL/VERTICAL detected, threshold too high'),
              ],
            ),
          ),
          
          // EventsPlanner with debug settings
          Expanded(
            child: EventsPlanner(
              controller: eventsController,
              daysShowed: 3,
              
              // Debug-optimized settings
              enableDiagonalScroll: true,
              diagonalScrollSensitivity: 1.0, // Full sensitivity for testing
              
              // Debug configuration
              diagonalScrollParam: const DiagonalScrollParam(
                gestureConflictResolution: false, // Disable for testing
                pinchToZoomPriority: false,
                dragEventPriority: false,
                tapEventThreshold: 15.0, // Higher threshold
                tapEventDuration: 300,   // Longer duration
              ),
              
              // Disable auto-adjust for free scrolling
              automaticAdjustHorizontalScrollToDay: false,
              
              // Simple physics
              horizontalScrollPhysics: const ClampingScrollPhysics(),
              verticalScrollPhysics: const ClampingScrollPhysics(),
              
              // Debug callbacks
              onDayChange: (day) {
                setState(() {
                  _lastGesture = 'Day Change: ${day.day}/${day.month}';
                });
                debugPrint('📅 DEBUG TEST: Day changed to ${day.day}/${day.month}/${day.year}');
              },
              onVerticalScrollChange: (offset) {
                setState(() {
                  _lastMovement = 'Time: ${offset.toStringAsFixed(1)}';
                });
                debugPrint('⏰ DEBUG TEST: Time changed to offset ${offset.toStringAsFixed(1)}');
              },
              
              // Day parameters
              dayParam: DayParam(
                todayColor: Colors.red.withOpacity(0.1),
                onSlotTap: (column, exact, rounded) {
                  setState(() {
                    _lastGesture = 'Tap: ${rounded.hour}:${rounded.minute.toString().padLeft(2, '0')}';
                  });
                  debugPrint('👆 DEBUG TEST: Slot tapped at ${rounded.hour}:${rounded.minute.toString().padLeft(2, '0')}');
                },
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

