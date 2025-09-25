import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class HorizontalScrollTest extends StatefulWidget {
  const HorizontalScrollTest({super.key});

  @override
  State<HorizontalScrollTest> createState() => _HorizontalScrollTestState();
}

class _HorizontalScrollTestState extends State<HorizontalScrollTest> {
  late EventsController eventsController;
  String _horizontalScrollInfo = 'Horizontal: 0.0';
  String _verticalScrollInfo = 'Vertical: 0.0';

  @override
  void initState() {
    super.initState();
    eventsController = EventsController();
    
    // Add some test events
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents([
        Event(
          title: 'Test Event 1',
          description: 'Testing horizontal scroll',
          startTime: DateTime.now().add(const Duration(hours: 1)),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          color: Colors.blue,
        ),
        Event(
          title: 'Test Event 2',
          description: 'Another test event',
          startTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
          endTime: DateTime.now().add(const Duration(days: 1, hours: 4)),
          color: Colors.green,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horizontal Scroll Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Scroll info display
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 SCROLL INFORMATION:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(_horizontalScrollInfo),
                Text(_verticalScrollInfo),
                const SizedBox(height: 8),
                const Text(
                  'FEATURES TESTED:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('✅ initialHorizontalScrollOffset: 100.0'),
                const Text('✅ onHorizontalScrollChange: Real-time tracking'),
                const Text('✅ initialVerticalScrollOffset: 200.0'),
                const Text('✅ onVerticalScrollChange: Real-time tracking'),
              ],
            ),
          ),
          
          // EventsPlanner with new horizontal scroll features
          Expanded(
            child: EventsPlanner(
              controller: eventsController,
              daysShowed: 7,
              
              // NEW: Horizontal scroll settings
              initialHorizontalScrollOffset: 100.0, // Start 100px from left
              onHorizontalScrollChange: (offset) {
                setState(() {
                  _horizontalScrollInfo = 'Horizontal: ${offset.toStringAsFixed(1)}';
                });
                debugPrint('🔄 HORIZONTAL SCROLL: ${offset.toStringAsFixed(1)}');
              },
              
              // Existing: Vertical scroll settings
              initialVerticalScrollOffset: 200.0, // Start 200px from top
              onVerticalScrollChange: (offset) {
                setState(() {
                  _verticalScrollInfo = 'Vertical: ${offset.toStringAsFixed(1)}';
                });
                debugPrint('⏰ VERTICAL SCROLL: ${offset.toStringAsFixed(1)}');
              },
              
              // Other settings
              automaticAdjustHorizontalScrollToDay: false,
              horizontalScrollPhysics: const ClampingScrollPhysics(),
              verticalScrollPhysics: const ClampingScrollPhysics(),
              
              // Day parameters
              dayParam: DayParam(
                todayColor: Colors.blue.withOpacity(0.1),
                onSlotTap: (column, exact, rounded) {
                  debugPrint('👆 SLOT TAPPED: ${rounded.hour}:${rounded.minute.toString().padLeft(2, '0')}');
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
