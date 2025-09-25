import 'package:example/views/events_months_view.dart';
import 'package:example/views/events_planner_multi_columns_view.dart';
import 'package:example/views/events_planner_multi_columns_view2.dart';
import 'package:example/views/events_planner_one_day_view.dart';
import 'package:example/views/events_planner_three_days_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

import 'app_bar.dart';
import 'data.dart';
import 'enumerations.dart';
import 'simple_diagonal_test.dart';
import 'performance_test.dart';
import 'diagonal_debug_test.dart';
import 'simple_wrapper_test.dart';
import 'views/events_list_view.dart';
import 'views/events_planner_draggable_events_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  EventsController eventsController = EventsController();
  var calendarMode = CalendarView.day3Draggable;
  var darkMode = false;

  @override
  void initState() {
    super.initState();
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents(events);
      calendarData.addEvents(fullDayEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Calendar View',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(backgroundColor: Color(0xff2F2F2F)),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.blueAccent,
        ),
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: calendarMode == CalendarView.day7 ? double.infinity : 500,
          ),
          child: Scaffold(
            appBar: CustomAppBar(
              eventsController: eventsController,
              onChangeCalendarView: (calendarMode) =>
                  setState(() => this.calendarMode = calendarMode),
              onChangeDarkMode: (darkMode) =>
                  setState(() => this.darkMode = darkMode),
            ),
            body: CalendarViewWidget(
                calendarMode: calendarMode,
                controller: eventsController,
                darkMode: darkMode),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SimpleWrapperTest(),
                      ),
                    );
                  },
                  child: const Icon(Icons.wrap_text),
                  tooltip: 'Simple Wrapper Test',
                  heroTag: "wrapper",
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DiagonalDebugTest(),
                      ),
                    );
                  },
                  child: const Icon(Icons.bug_report),
                  tooltip: 'Debug Diagonal Test',
                  heroTag: "debug",
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PerformanceTest(),
                      ),
                    );
                  },
                  child: const Icon(Icons.speed),
                  tooltip: 'Performance Test',
                  heroTag: "performance",
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SimpleDiagonalTest(),
                      ),
                    );
                  },
                  child: const Icon(Icons.touch_app),
                  tooltip: 'Simple Diagonal Test',
                  heroTag: "simple",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarViewWidget extends StatelessWidget {
  const CalendarViewWidget({
    super.key,
    required this.calendarMode,
    required this.controller,
    required this.darkMode,
  });

  final CalendarView calendarMode;
  final EventsController controller;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return switch (calendarMode) {
      CalendarView.agenda => EventsListView(
          controller: controller,
        ),
      CalendarView.day => EventsPlannerOneDayView(
          key: UniqueKey(),
          controller: controller,
          isDarkMode: darkMode,
        ),
      CalendarView.day3 => EventsPlannerTreeDaysView(
          key: UniqueKey(),
          controller: controller,
          isDarkMode: darkMode,
        ),
      CalendarView.day3Draggable => EventsPlannerDraggableEventsView(
          key: UniqueKey(),
          controller: controller,
          daysShowed: 3,
          isDarkMode: darkMode,
        ),
      CalendarView.day7 => EventsPlannerDraggableEventsView(
          key: UniqueKey(),
          controller: controller,
          daysShowed: 7,
          isDarkMode: darkMode,
        ),
      CalendarView.multi_column2 => EventsPlannerMultiColumnView(
          key: UniqueKey(),
          isDarkMode: darkMode,
        ),
      CalendarView.multi_column1 => EventsPlannerMultiColumnSchedulerView(
          key: UniqueKey(),
          isDarkMode: darkMode,
        ),
      CalendarView.month => EventsMonthsView(
          controller: controller,
        ),
    };
  }
}
