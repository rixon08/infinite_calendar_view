import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class DiagonalScrollExample extends StatefulWidget {
  const DiagonalScrollExample({super.key});

  @override
  State<DiagonalScrollExample> createState() => _DiagonalScrollExampleState();
}

class _DiagonalScrollExampleState extends State<DiagonalScrollExample> {
  late EventsController eventsController;

  @override
  void initState() {
    super.initState();
    eventsController = EventsController();
    
    // Add some sample events
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents([
        Event(
          title: 'Meeting',
          description: 'Team meeting',
          startTime: DateTime.now().add(const Duration(hours: 2)),
          endTime: DateTime.now().add(const Duration(hours: 3)),
          color: Colors.blue,
        ),
        Event(
          title: 'Lunch',
          description: 'Lunch break',
          startTime: DateTime.now().add(const Duration(hours: 5)),
          endTime: DateTime.now().add(const Duration(hours: 6)),
          color: Colors.green,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagonal Scroll Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diagonal Scroll Features:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('• Swipe diagonally to scroll both horizontally and vertically'),
                Text('• Horizontal scroll: Navigate between days'),
                Text('• Vertical scroll: Navigate through time'),
                Text('• Pinch to zoom: Still works with diagonal scroll'),
                Text('• Tap events: Still work normally'),
                SizedBox(height: 8),
                Text(
                  '🔍 DEBUG: Check console for gesture detection logs',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          
          // EventsPlanner with diagonal scroll enabled
          Expanded(
            child: EventsPlanner(
              controller: eventsController,
              daysShowed: 7, // Show 7 days
              
              // Enable diagonal scroll
              enableDiagonalScroll: true,
              diagonalScrollSensitivity: 1.0,
              
              // Configure diagonal scroll behavior
              diagonalScrollParam: const DiagonalScrollParam(
                gestureConflictResolution: true,
                pinchToZoomPriority: true,
                dragEventPriority: true,
                tapEventThreshold: 10.0,
                tapEventDuration: 200,
              ),
              
              // Existing parameters
              horizontalScrollPhysics: const BouncingScrollPhysics(),
              verticalScrollPhysics: const BouncingScrollPhysics(),
              automaticAdjustHorizontalScrollToDay: false, // Disable for free scrolling
              
              // Callbacks for debugging
              onDayChange: (day) {
                debugPrint('📅 DAY CHANGE: ${day.day}/${day.month}/${day.year}');
              },
              onVerticalScrollChange: (offset) {
                debugPrint('⏰ TIME CHANGE: Offset ${offset.toStringAsFixed(1)}');
              },
              
              // Pinch to zoom
              pinchToZoomParam: const PinchToZoomParameters(
                pinchToZoom: true,
                pinchToZoomMinHeightPerMinute: 0.5,
                pinchToZoomMaxHeightPerMinute: 2.0,
              ),
              
              // Day parameters
              dayParam: DayParam(
                todayColor: Colors.blue.withOpacity(0.1),
                dayColor: Colors.grey.withOpacity(0.05),
                onSlotTap: (column, exact, rounded) {
                  debugPrint('👆 SLOT TAP: Column $column at ${rounded.hour}:${rounded.minute.toString().padLeft(2, '0')}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tapped at: ${rounded.hour}:${rounded.minute.toString().padLeft(2, '0')}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              
              // Current hour indicator
              currentHourIndicatorParam: const CurrentHourIndicatorParam(
                currentHourIndicatorLineVisibility: true,
                currentHourIndicatorHourVisibility: true,
                currentHourIndicatorColor: Colors.red,
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
