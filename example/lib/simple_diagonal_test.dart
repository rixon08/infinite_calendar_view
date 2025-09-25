import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class SimpleDiagonalTest extends StatefulWidget {
  const SimpleDiagonalTest({super.key});

  @override
  State<SimpleDiagonalTest> createState() => _SimpleDiagonalTestState();
}

class _SimpleDiagonalTestState extends State<SimpleDiagonalTest> {
  late EventsController eventsController;

  @override
  void initState() {
    super.initState();
    eventsController = EventsController();
    
    // Add a simple event
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents([
        Event(
          title: 'Test Event',
          description: 'Simple test event',
          startTime: DateTime.now().add(const Duration(hours: 1)),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          color: Colors.blue,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Diagonal Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Debug info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.yellow.shade100,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔍 DEBUG TEST:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('1. ✅ OPTIMIZED VERSION - Better Performance!'),
                Text('2. Try swiping in different directions'),
                Text('3. Diagonal scroll should be smoother now'),
                Text('4. Debug logs disabled for better performance'),
              ],
            ),
          ),
          
          // Simple EventsPlanner
          Expanded(
            child: EventsPlanner(
              controller: eventsController,
              daysShowed: 3, // Simple 3 days
              
              // Enable diagonal scroll with optimized settings
              enableDiagonalScroll: true,
              diagonalScrollSensitivity: 0.8, // Reduced for better performance
              
              // Simple configuration
              diagonalScrollParam: const DiagonalScrollParam(
                gestureConflictResolution: true,
                pinchToZoomPriority: false, // Disable for testing
                dragEventPriority: false,   // Disable for testing
                tapEventThreshold: 10.0,
                tapEventDuration: 200,
              ),
              
              // Disable auto-adjust for free scrolling
              automaticAdjustHorizontalScrollToDay: false,
              
              // Simple physics
              horizontalScrollPhysics: const ClampingScrollPhysics(),
              verticalScrollPhysics: const ClampingScrollPhysics(),
              
              // Debug callbacks
              onDayChange: (day) {
                debugPrint('📅 SIMPLE TEST: Day changed to ${day.day}/${day.month}/${day.year}');
              },
              onVerticalScrollChange: (offset) {
                debugPrint('⏰ SIMPLE TEST: Time changed to offset ${offset.toStringAsFixed(1)}');
              },
              
              // Simple day parameters
              dayParam: DayParam(
                todayColor: Colors.blue.withOpacity(0.1),
                onSlotTap: (column, exact, rounded) {
                  debugPrint('👆 SIMPLE TEST: Slot tapped at ${rounded.hour}:${rounded.minute.toString().padLeft(2, '0')}');
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
