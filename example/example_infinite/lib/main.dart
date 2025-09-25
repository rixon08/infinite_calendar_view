import 'package:example_infinite/perfomance_testing.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PerformanceTest(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


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
