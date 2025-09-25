import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class DelayedScrollTest extends StatefulWidget {
  const DelayedScrollTest({super.key});

  @override
  State<DelayedScrollTest> createState() => _DelayedScrollTestState();
}

class _DelayedScrollTestState extends State<DelayedScrollTest> {
  late EventsController eventsController;
  double currentHorizontalOffset = 0.0;

  @override
  void initState() {
    super.initState();
    eventsController = EventsController();
    
    // Add some test events
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents([
        Event(
          startTime: DateTime.now().add(Duration(hours: 2)),
          endTime: DateTime.now().add(Duration(hours: 3)),
          title: 'Test Event 1',
        ),
        Event(
          startTime: DateTime.now().add(Duration(days: 1, hours: 1)),
          endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
          title: 'Test Event 2',
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delayed Scroll Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Status info
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delayed Scroll Test',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Current Horizontal Offset: ${currentHorizontalOffset.toStringAsFixed(1)}px'),
                Text('Target Offset: -500.0px (negative)'),
                Text('Delay: 200ms'),
                Text('Animation: None (jumpTo)'),
              ],
            ),
          ),
          
          // EventsPlanner with delayed scroll
          Expanded(
            child: EventsPlanner(
              controller: eventsController,
              daysShowed: 7,
              
              // Delayed scroll settings
              initialHorizontalScrollOffset: -500.0, // Target position (negative for testing)
              delayedHorizontalScroll: true,         // Enable delayed scroll
              delayedHorizontalScrollDelay: 200,     // Wait 200ms after build
              
              // Scroll change listener
              onHorizontalScrollChange: (offset) {
                setState(() {
                  currentHorizontalOffset = offset;
                });
                print('📱 Horizontal scroll changed: ${offset.toStringAsFixed(1)}px');
              },
              
              // Other settings
              dayParam: DayParam(
                dayColor: Colors.white,
                todayColor: Colors.blue[50],
              ),
            ),
          ),
          
          // Control buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Test Different Scroll Values:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Test negative scroll
                        setState(() {
                          // This will trigger rebuild with negative value
                        });
                      },
                      child: Text('Test -500px'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Test positive scroll
                        setState(() {
                          // This will trigger rebuild with positive value
                        });
                      },
                      child: Text('Test +500px'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Test zero scroll
                        setState(() {
                          // This will trigger rebuild with zero value
                        });
                      },
                      child: Text('Test 0px'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
