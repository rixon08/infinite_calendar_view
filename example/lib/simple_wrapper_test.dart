import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:infinite_calendar_view/src/widgets/planner/simple_diagonal_wrapper.dart';

class SimpleWrapperTest extends StatefulWidget {
  const SimpleWrapperTest({super.key});

  @override
  State<SimpleWrapperTest> createState() => _SimpleWrapperTestState();
}

class _SimpleWrapperTestState extends State<SimpleWrapperTest> {
  late EventsController eventsController;
  late ScrollController horizontalController;
  late ScrollController verticalController;
  String _lastGesture = 'None';

  @override
  void initState() {
    super.initState();
    eventsController = EventsController();
    horizontalController = ScrollController();
    verticalController = ScrollController();
    
    // Add a simple event
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents([
        Event(
          title: 'Simple Wrapper Test',
          description: 'Testing with simple diagonal wrapper',
          startTime: DateTime.now().add(const Duration(hours: 1)),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          color: Colors.green,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Wrapper Test'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Debug info display
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🔍 SIMPLE WRAPPER TEST:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Last Gesture: $_lastGesture'),
                const SizedBox(height: 8),
                const Text(
                  'INSTRUCTIONS:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('1. This uses SimpleDiagonalWrapper (no conflicts)'),
                const Text('2. Threshold is only 1 pixel'),
                const Text('3. Check console for "SIMPLE DIAGONAL" messages'),
                const Text('4. Should detect diagonal movement easily'),
              ],
            ),
          ),
          
          // Simple wrapper with EventsPlanner
          Expanded(
            child: SimpleDiagonalWrapper(
              horizontalController: horizontalController,
              verticalController: verticalController,
              enableDiagonalScroll: true,
              diagonalScrollSensitivity: 1.0,
              onDiagonalScrollStart: () {
                setState(() {
                  _lastGesture = 'Diagonal Started';
                });
                debugPrint('🎯 SIMPLE WRAPPER TEST: Diagonal scroll started');
              },
              onDiagonalScrollUpdate: (h, v) {
                setState(() {
                  _lastGesture = 'Diagonal: H=${h.toStringAsFixed(1)}, V=${v.toStringAsFixed(1)}';
                });
              },
              onDiagonalScrollEnd: () {
                setState(() {
                  _lastGesture = 'Diagonal Ended';
                });
                debugPrint('🏁 SIMPLE WRAPPER TEST: Diagonal scroll ended');
              },
              child: EventsPlanner(
                controller: eventsController,
                daysShowed: 3,
                
                // Disable diagonal scroll in EventsPlanner since we're using wrapper
                enableDiagonalScroll: false,
                
                // Simple configuration
                automaticAdjustHorizontalScrollToDay: false,
                horizontalScrollPhysics: const ClampingScrollPhysics(),
                verticalScrollPhysics: const ClampingScrollPhysics(),
                
                // Debug callbacks
                onDayChange: (day) {
                  setState(() {
                    _lastGesture = 'Day: ${day.day}/${day.month}';
                  });
                },
                onVerticalScrollChange: (offset) {
                  setState(() {
                    _lastGesture = 'Time: ${offset.toStringAsFixed(1)}';
                  });
                },
                
                // Day parameters
                dayParam: DayParam(
                  todayColor: Colors.green.withOpacity(0.1),
                  onSlotTap: (column, exact, rounded) {
                    setState(() {
                      _lastGesture = 'Tap: ${rounded.hour}:${rounded.minute.toString().padLeft(2, '0')}';
                    });
                  },
                ),
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
    horizontalController.dispose();
    verticalController.dispose();
    super.dispose();
  }
}

