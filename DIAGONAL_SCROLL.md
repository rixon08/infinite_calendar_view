# Diagonal Scroll Feature

## Overview

The diagonal scroll feature allows users to scroll both horizontally and vertically simultaneously in the EventsPlanner widget. This provides a more intuitive and efficient way to navigate through days and time.

## Features

- **Diagonal Scrolling**: Swipe diagonally to scroll both horizontally (days) and vertically (time) at the same time
- **Gesture Conflict Resolution**: Automatically handles conflicts with pinch-to-zoom, drag events, and tap events
- **Configurable Sensitivity**: Adjust scroll sensitivity for different user preferences
- **Non-Invasive**: Works alongside existing scroll behaviors without breaking them

## Usage

### Basic Usage

```dart
EventsPlanner(
  controller: eventsController,
  daysShowed: 7,
  
  // Enable diagonal scroll
  enableDiagonalScroll: true,
  diagonalScrollSensitivity: 1.0,
  
  // Configure behavior
  diagonalScrollParam: const DiagonalScrollParam(
    gestureConflictResolution: true,
    pinchToZoomPriority: true,
    dragEventPriority: true,
  ),
)
```

### Advanced Configuration

```dart
EventsPlanner(
  controller: eventsController,
  daysShowed: 7,
  
  // Enable diagonal scroll with custom settings
  enableDiagonalScroll: true,
  diagonalScrollSensitivity: 1.5, // 1.5x faster scrolling
  
  // Detailed configuration
  diagonalScrollParam: const DiagonalScrollParam(
    gestureConflictResolution: true,
    pinchToZoomPriority: true,
    dragEventPriority: true,
    tapEventThreshold: 15.0, // 15px threshold for tap detection
    tapEventDuration: 250,   // 250ms max duration for tap
  ),
  
  // Disable automatic scroll adjustment for free scrolling
  automaticAdjustHorizontalScrollToDay: false,
)
```

## Parameters

### EventsPlanner Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enableDiagonalScroll` | `bool` | `false` | Enable/disable diagonal scroll functionality |
| `diagonalScrollSensitivity` | `double` | `1.0` | Scroll sensitivity multiplier (1.0 = normal, 2.0 = double speed) |
| `diagonalScrollParam` | `DiagonalScrollParam` | `DiagonalScrollParam()` | Configuration for diagonal scroll behavior |

### DiagonalScrollParam Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `gestureConflictResolution` | `bool` | `true` | Enable automatic gesture conflict resolution |
| `pinchToZoomPriority` | `bool` | `true` | Give priority to pinch-to-zoom over diagonal scroll |
| `dragEventPriority` | `bool` | `true` | Give priority to drag events over diagonal scroll |
| `tapEventThreshold` | `double` | `10.0` | Distance threshold for tap event detection (pixels) |
| `tapEventDuration` | `int` | `200` | Maximum duration for tap event detection (milliseconds) |

## Gesture Conflict Resolution

The diagonal scroll feature includes intelligent gesture conflict resolution:

### Pinch-to-Zoom Priority
When `pinchToZoomPriority` is `true` (default), diagonal scroll is disabled during pinch-to-zoom gestures to prevent interference.

### Drag Event Priority
When `dragEventPriority` is `true` (default), diagonal scroll is disabled when dragging events to allow proper event manipulation.

### Tap Event Detection
The system distinguishes between tap events and scroll gestures based on:
- **Distance**: Movement less than `tapEventThreshold` pixels
- **Duration**: Gesture completed within `tapEventDuration` milliseconds

## Implementation Details

### Architecture
- **Non-Invasive**: Uses a wrapper widget (`DiagonalScrollWrapper`) that doesn't modify existing scroll controllers
- **Clean Separation**: Diagonal scroll logic is separated from existing scroll behavior
- **Performance Optimized**: Minimal overhead with efficient gesture detection

### Widget Hierarchy
```
EventsPlanner
├── GestureDetector (pinch-to-zoom)
├── Listener (pointer events)
├── IgnorePointer (conditional)
├── ScrollConfiguration
└── DiagonalScrollWrapper (NEW)
    └── CustomScrollView (vertical scroll)
        └── SliverList
            └── Row
                ├── VerticalTimeIndicator
                └── InfiniteList (horizontal scroll)
```

## Best Practices

### For 7-Day View
```dart
EventsPlanner(
  daysShowed: 7,
  enableDiagonalScroll: true,
  automaticAdjustHorizontalScrollToDay: false, // Allow free scrolling
  diagonalScrollSensitivity: 1.0,
)
```

### For Single Day View
```dart
EventsPlanner(
  daysShowed: 1,
  enableDiagonalScroll: false, // Not needed for single day
  automaticAdjustHorizontalScrollToDay: true,
)
```

### For Mobile Apps
```dart
EventsPlanner(
  enableDiagonalScroll: true,
  diagonalScrollSensitivity: 1.2, // Slightly faster for mobile
  diagonalScrollParam: const DiagonalScrollParam(
    tapEventThreshold: 12.0, // Slightly larger for touch
    tapEventDuration: 250,   // Slightly longer for touch
  ),
)
```

## Troubleshooting

### Diagonal Scroll Not Working
1. Check if `enableDiagonalScroll` is set to `true`
2. Verify that scroll controllers are properly initialized
3. Ensure no other gesture detectors are interfering

### Gesture Conflicts
1. Adjust `pinchToZoomPriority` and `dragEventPriority` settings
2. Increase `tapEventThreshold` if tap events are not working
3. Increase `tapEventDuration` if tap events are not working

### Performance Issues
1. Reduce `diagonalScrollSensitivity` if scrolling is too fast
2. Check if too many widgets are rebuilding during scroll
3. Ensure scroll controllers have proper bounds

## Migration Guide

### From Previous Version
No breaking changes. Simply add the new parameters to enable diagonal scroll:

```dart
// Before
EventsPlanner(
  controller: eventsController,
  daysShowed: 7,
)

// After (with diagonal scroll)
EventsPlanner(
  controller: eventsController,
  daysShowed: 7,
  enableDiagonalScroll: true,
  diagonalScrollSensitivity: 1.0,
)
```

## Examples

See `example/lib/diagonal_scroll_example.dart` for a complete working example with sample events and configuration options.
