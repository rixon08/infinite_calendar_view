# Debug Gesture Detection

## Overview

The diagonal scroll feature includes comprehensive debug logging to help you understand how gestures are detected and processed. This is especially useful for debugging gesture conflicts and understanding the scroll behavior.

## Debug Print Categories

### 🎯 Gesture Start/End
```
🎯 GESTURE START: Pan started at Offset(100.0, 200.0)
🏁 GESTURE END: Pan ended
```

### 📊 Movement Detection
```
📊 MOVEMENT: H=5.2, V=3.1
```
- Shows horizontal (H) and vertical (V) movement deltas
- Only prints when movement > 1 pixel

### 🔄 Diagonal Scroll Detection
```
🔄 DIAGONAL SCROLL: Started (H=8.5, V=6.2)
🔄 DIAGONAL SCROLL: Ended
```
- Triggered when both horizontal and vertical movement > 2 pixels
- Shows the exact movement values that triggered diagonal scroll

### ➡️ Horizontal Scroll Detection
```
➡️ HORIZONTAL SCROLL: Detected (H=12.3)
```
- Triggered when horizontal movement > 2 pixels and vertical ≤ 2 pixels

### ⬆️ Vertical Scroll Detection
```
⬆️ VERTICAL SCROLL: Detected (V=15.7)
```
- Triggered when vertical movement > 2 pixels and horizontal ≤ 2 pixels

### 👆 Tap Gesture Detection
```
👆 TAP GESTURE: Detected (150ms, 8.5px)
```
- Shows duration in milliseconds and distance in pixels
- Triggered when movement is small and fast

### 🚫 Gesture Blocking
```
🚫 GESTURE BLOCKED: Pinch-to-zoom has priority
🚫 GESTURE BLOCKED: Drag event has priority
```
- Shows when diagonal scroll is blocked due to gesture conflicts

### 🔍 Conflict Check
```
🔍 CONFLICT CHECK: Pinch=false, Drag=false
```
- Shows the state of gesture conflicts at start

### 📱 Scroll Controller Updates
```
📱 HORIZONTAL: 100.0 → 95.2
📱 VERTICAL: 200.0 → 196.9
```
- Shows old and new scroll positions
- Only appears during diagonal scroll

### 🎯 EventsPlanner Callbacks
```
🎯 EVENTS PLANNER: Diagonal scroll started
🔄 EVENTS PLANNER: Diagonal scroll update (H=5.2, V=3.1)
🏁 EVENTS PLANNER: Diagonal scroll ended
```

### 📅 Day Change Detection
```
📅 HORIZONTAL SCROLL: Day changed to 15/12/2024
📅 DAY CHANGE: 15/12/2024
```

### ⏰ Time Change Detection
```
⏰ VERTICAL SCROLL: Time changed to offset 150.5
⏰ TIME CHANGE: Offset 150.5
```

### 👆 Slot Tap Detection
```
👆 SLOT TAP: Column 0 at 14:30
```

## How to Use Debug Logs

### 1. Enable Debug Mode
Debug prints are automatically enabled when you use the diagonal scroll feature. No additional configuration needed.

### 2. View Logs
- **Flutter Console**: View logs in your IDE's debug console
- **Terminal**: Run `flutter logs` to see real-time logs
- **VS Code**: Check the Debug Console panel

### 3. Filter Logs
You can filter logs by searching for specific emojis:
- `🎯` - Gesture start/end
- `📊` - Movement detection
- `🔄` - Diagonal scroll
- `➡️` - Horizontal scroll
- `⬆️` - Vertical scroll
- `👆` - Tap gestures
- `🚫` - Blocked gestures
- `📱` - Scroll updates
- `📅` - Day changes
- `⏰` - Time changes

## Example Debug Session

```
🎯 GESTURE START: Pan started at Offset(100.0, 200.0)
🔍 CONFLICT CHECK: Pinch=false, Drag=false
📊 MOVEMENT: H=2.1, V=1.5
📊 MOVEMENT: H=5.3, V=4.2
🔄 DIAGONAL SCROLL: Started (H=5.3, V=4.2)
🎯 EVENTS PLANNER: Diagonal scroll started
📱 HORIZONTAL: 100.0 → 94.7
📱 VERTICAL: 200.0 → 195.8
🔄 EVENTS PLANNER: Diagonal scroll update (H=5.3, V=4.2)
📊 MOVEMENT: H=3.1, V=2.8
📱 HORIZONTAL: 94.7 → 91.6
📱 VERTICAL: 195.8 → 193.0
🔄 EVENTS PLANNER: Diagonal scroll update (H=3.1, V=2.8)
🔄 DIAGONAL SCROLL: Ended
🏁 EVENTS PLANNER: Diagonal scroll ended
🏁 GESTURE END: Pan ended
```

## Troubleshooting with Debug Logs

### Diagonal Scroll Not Working
1. Check if you see `🎯 GESTURE START`
2. Look for `🚫 GESTURE BLOCKED` messages
3. Verify `🔍 CONFLICT CHECK` shows correct states

### Gesture Conflicts
1. Look for `🚫 GESTURE BLOCKED` messages
2. Check `🔍 CONFLICT CHECK` for conflict states
3. Adjust `pinchToZoomPriority` or `dragEventPriority` settings

### Tap Events Not Working
1. Check `👆 TAP GESTURE` detection
2. Look at duration and distance values
3. Adjust `tapEventThreshold` or `tapEventDuration` if needed

### Scroll Not Smooth
1. Check `📱 HORIZONTAL` and `📱 VERTICAL` updates
2. Look for large jumps in scroll positions
3. Adjust `diagonalScrollSensitivity` if needed

## Disabling Debug Logs

To disable debug logs in production, you can:

1. **Remove debug prints** from the source code
2. **Use conditional compilation**:
```dart
if (kDebugMode) {
  debugPrint('🎯 GESTURE START: Pan started at ${details.globalPosition}');
}
```

3. **Create a debug flag**:
```dart
class DiagonalScrollParam {
  const DiagonalScrollParam({
    // ... other parameters
    this.enableDebugLogs = false,
  });
  
  final bool enableDebugLogs;
}
```

## Performance Note

Debug prints have minimal performance impact, but for production apps with heavy usage, consider disabling them or using conditional compilation.
