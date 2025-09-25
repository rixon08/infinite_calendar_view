# 📊 Horizontal Scroll Features Documentation

## 🎯 Overview

New horizontal scroll features have been added to the `EventsPlanner` widget to provide better control over horizontal scrolling behavior and monitoring.

## ✨ New Features

### 1. **initialHorizontalScrollOffset**
- **Type**: `double`
- **Default**: `0`
- **Description**: Sets the initial horizontal scroll position when the widget is first built
- **Usage**: Similar to `initialVerticalScrollOffset` but for horizontal scrolling

### 2. **onHorizontalScrollChange**
- **Type**: `void Function(double offset)?`
- **Default**: `null`
- **Description**: Callback function that is called when horizontal scroll position changes
- **Usage**: Real-time monitoring of horizontal scroll position

## 🔧 Implementation Details

### Constructor Changes
```dart
const EventsPlanner({
  // ... existing parameters ...
  this.onVerticalScrollChange,
  this.initialHorizontalScrollOffset = 0,        // ← NEW
  this.onHorizontalScrollChange,                 // ← NEW
  this.horizontalScrollPhysics = const BouncingScrollPhysics(
    decelerationRate: ScrollDecelerationRate.fast,
  ),
  // ... rest of parameters ...
});
```

### Field Declarations
```dart
/// initial horizontal scroll offset (in pixels)
/// used to set the initial horizontal scroll position
final double initialHorizontalScrollOffset;

/// call when horizontal scroll change
final void Function(double offset)? onHorizontalScrollChange;
```

### ScrollController Initialization
```dart
mainHorizontalController = ScrollController(
  initialScrollOffset: widget.initialHorizontalScrollOffset,
);
```

### Scroll Listener
```dart
// init horizontal scroll listener when scroll stop
if (widget.onHorizontalScrollChange != null) {
  mainHorizontalController.position.isScrollingNotifier.addListener(() {
    if (!mainHorizontalController.position.isScrollingNotifier.value) {
      widget.onHorizontalScrollChange?.call(mainHorizontalController.offset);
    }
  });
}
```

## 📱 Usage Examples

### Basic Usage
```dart
EventsPlanner(
  controller: eventsController,
  daysShowed: 7,
  
  // Set initial horizontal scroll position
  initialHorizontalScrollOffset: 100.0,
  
  // Monitor horizontal scroll changes
  onHorizontalScrollChange: (offset) {
    print('Horizontal scroll: $offset');
  },
  
  // Existing vertical scroll features still work
  initialVerticalScrollOffset: 200.0,
  onVerticalScrollChange: (offset) {
    print('Vertical scroll: $offset');
  },
)
```

### Advanced Usage with State Management
```dart
class MyCalendarWidget extends StatefulWidget {
  @override
  _MyCalendarWidgetState createState() => _MyCalendarWidgetState();
}

class _MyCalendarWidgetState extends State<MyCalendarWidget> {
  double _savedHorizontalOffset = 0.0;
  double _savedVerticalOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return EventsPlanner(
      controller: eventsController,
      daysShowed: 7,
      
      // Restore previous scroll positions
      initialHorizontalScrollOffset: _savedHorizontalOffset,
      initialVerticalScrollOffset: _savedVerticalOffset,
      
      // Save scroll positions for later restoration
      onHorizontalScrollChange: (offset) {
        _savedHorizontalOffset = offset;
        // Save to SharedPreferences, database, etc.
      },
      
      onVerticalScrollChange: (offset) {
        _savedVerticalOffset = offset;
        // Save to SharedPreferences, database, etc.
      },
    );
  }
}
```

### Custom Scroll Animation
```dart
EventsPlanner(
  controller: eventsController,
  daysShowed: 7,
  
  onHorizontalScrollChange: (offset) {
    // Custom logic based on scroll position
    if (offset > 500) {
      // Show additional UI elements
      showFloatingActionButton();
    } else {
      // Hide additional UI elements
      hideFloatingActionButton();
    }
  },
)
```

## 🧪 Testing

### Test Page
A test page has been created at `example/lib/horizontal_scroll_test.dart` to demonstrate the new features:

- **Access**: Tap the floating action button (swap_horiz icon) in the main app
- **Features Tested**:
  - ✅ `initialHorizontalScrollOffset: 100.0`
  - ✅ `onHorizontalScrollChange: Real-time tracking`
  - ✅ `initialVerticalScrollOffset: 200.0`
  - ✅ `onVerticalScrollChange: Real-time tracking`

### Expected Behavior
1. **Initial Position**: Calendar starts at 100px horizontal and 200px vertical offset
2. **Real-time Updates**: Scroll position is displayed and logged in real-time
3. **Console Output**: Debug prints show scroll changes
4. **UI Feedback**: Scroll information is displayed in the UI

## 🔄 Backward Compatibility

- ✅ **Fully Backward Compatible**: Existing code will continue to work without changes
- ✅ **Default Values**: New parameters have sensible defaults
- ✅ **Optional Parameters**: All new parameters are optional
- ✅ **No Breaking Changes**: No existing functionality is affected

## 🎯 Use Cases

### 1. **Scroll Position Restoration**
- Save user's scroll position when navigating away
- Restore position when returning to the calendar
- Improve user experience by maintaining context

### 2. **Custom UI Behavior**
- Show/hide UI elements based on scroll position
- Implement custom scroll indicators
- Add scroll-based animations

### 3. **Analytics and Monitoring**
- Track user scroll behavior
- Monitor which parts of the calendar are viewed
- Implement scroll-based features

### 4. **Accessibility**
- Programmatically scroll to specific positions
- Implement keyboard navigation
- Support screen readers with scroll announcements

## 🚀 Performance Considerations

- **Efficient Listeners**: Scroll listeners only trigger when scrolling stops
- **Minimal Overhead**: No performance impact when callbacks are not provided
- **Memory Safe**: Proper cleanup of listeners in dispose method
- **Optimized Updates**: Uses `isScrollingNotifier` for efficient scroll detection

## 📋 API Summary

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `initialHorizontalScrollOffset` | `double` | `0` | Initial horizontal scroll position |
| `onHorizontalScrollChange` | `Function(double)?` | `null` | Callback for horizontal scroll changes |

## 🔗 Related Features

- **Vertical Scroll**: `initialVerticalScrollOffset`, `onVerticalScrollChange`
- **Scroll Physics**: `horizontalScrollPhysics`, `verticalScrollPhysics`
- **Auto Adjust**: `automaticAdjustHorizontalScrollToDay`
- **Scroll Controllers**: Direct access to `mainHorizontalController`, `mainVerticalController`

---

**🎉 The horizontal scroll features are now ready to use! Test them with the provided test page.**
