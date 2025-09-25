import 'package:flutter/material.dart';

class DiagonalScrollWrapper extends StatefulWidget {
  const DiagonalScrollWrapper({
    super.key,
    required this.horizontalController,
    required this.verticalController,
    required this.child,
    this.enableDiagonalScroll = true,
    this.diagonalScrollSensitivity = 1.0,
    this.gestureConflictResolution = true,
    this.pinchToZoomPriority = true,
    this.dragEventPriority = true,
    this.tapEventThreshold = 10.0,
    this.tapEventDuration = 200,
    this.onDiagonalScrollStart,
    this.onDiagonalScrollUpdate,
    this.onDiagonalScrollEnd,
  });

  final ScrollController horizontalController;
  final ScrollController verticalController;
  final Widget child;
  final bool enableDiagonalScroll;
  final double diagonalScrollSensitivity;
  final bool gestureConflictResolution;
  final bool pinchToZoomPriority;
  final bool dragEventPriority;
  final double tapEventThreshold;
  final int tapEventDuration;
  final VoidCallback? onDiagonalScrollStart;
  final void Function(double horizontalDelta, double verticalDelta)? onDiagonalScrollUpdate;
  final VoidCallback? onDiagonalScrollEnd;

  @override
  State<DiagonalScrollWrapper> createState() => _DiagonalScrollWrapperState();
}

class _DiagonalScrollWrapperState extends State<DiagonalScrollWrapper> {
  bool _isDiagonalScrolling = false;
  Offset? _lastPanPosition;
  DateTime? _panStartTime;
  Offset? _panStartPosition;
  bool _isPinchZooming = false;
  bool _isDraggingEvent = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enableDiagonalScroll) {
      debugPrint('🚫 DIAGONAL WRAPPER: Diagonal scroll disabled');
      return widget.child;
    }

    debugPrint('✅ DIAGONAL WRAPPER: Building with diagonal scroll enabled');
    
    return Listener(
      onPointerDown: (event) {
        debugPrint('👆 DIAGONAL WRAPPER: Pointer down at ${event.position}');
        _onPanStart(DragStartDetails(
          globalPosition: event.position,
          localPosition: event.localPosition,
        ));
      },
      onPointerMove: (event) {
        debugPrint('📊 DIAGONAL WRAPPER: Pointer move to ${event.position}');
        _onPanUpdate(DragUpdateDetails(
          globalPosition: event.position,
          localPosition: event.localPosition,
          delta: event.delta,
        ));
      },
      onPointerUp: (event) {
        debugPrint('🏁 DIAGONAL WRAPPER: Pointer up at ${event.position}');
        _onPanEnd(DragEndDetails(
          velocity: Velocity.zero,
        ));
      },
      onPointerCancel: (event) {
        debugPrint('❌ DIAGONAL WRAPPER: Pointer cancelled');
        _onPanEnd(DragEndDetails(
          velocity: Velocity.zero,
        ));
      },
      child: widget.child,
    );
  }

  void _onPanStart(DragStartDetails details) {
    _panStartTime = DateTime.now();
    _panStartPosition = details.globalPosition;
    _lastPanPosition = details.globalPosition;
    _isDiagonalScrolling = false;

    // Debug print
    debugPrint('🎯 DIAGONAL WRAPPER: Pan started at ${details.globalPosition}');
    debugPrint('🎯 DIAGONAL WRAPPER: enableDiagonalScroll=${widget.enableDiagonalScroll}');

    // Check for gesture conflicts
    if (widget.gestureConflictResolution) {
      _checkGestureConflicts(details);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_lastPanPosition == null) return;

    // Skip if gesture conflicts detected
    if (widget.gestureConflictResolution) {
      if (_isPinchZooming && widget.pinchToZoomPriority) {
        debugPrint('🚫 GESTURE BLOCKED: Pinch-to-zoom has priority');
        return;
      }
      if (_isDraggingEvent && widget.dragEventPriority) {
        debugPrint('🚫 GESTURE BLOCKED: Drag event has priority');
        return;
      }
    }

    // Use delta directly from pointer event
    final horizontalDelta = details.delta.dx * widget.diagonalScrollSensitivity;
    final verticalDelta = details.delta.dy * widget.diagonalScrollSensitivity;

    // Debug print for movement detection
    if (horizontalDelta.abs() > 1 || verticalDelta.abs() > 1) {
      debugPrint('📊 MOVEMENT: H=${horizontalDelta.toStringAsFixed(1)}, V=${verticalDelta.toStringAsFixed(1)}');
    }

    // Detect diagonal movement
    if (horizontalDelta.abs() > 2 && verticalDelta.abs() > 2) {
      if (!_isDiagonalScrolling) {
        _isDiagonalScrolling = true;
        debugPrint('🔄 DIAGONAL SCROLL: Started (H=${horizontalDelta.toStringAsFixed(1)}, V=${verticalDelta.toStringAsFixed(1)})');
        widget.onDiagonalScrollStart?.call();
      }

      // Update both scroll controllers
      _updateScrollControllers(horizontalDelta, verticalDelta);
      widget.onDiagonalScrollUpdate?.call(horizontalDelta, verticalDelta);
    } else if (horizontalDelta.abs() > 2 && verticalDelta.abs() <= 2) {
      debugPrint('➡️ HORIZONTAL SCROLL: Detected (H=${horizontalDelta.toStringAsFixed(1)})');
    } else if (verticalDelta.abs() > 2 && horizontalDelta.abs() <= 2) {
      debugPrint('⬆️ VERTICAL SCROLL: Detected (V=${verticalDelta.toStringAsFixed(1)})');
    }

    _lastPanPosition = details.globalPosition;
  }

  void _onPanEnd(DragEndDetails details) {
    // Check if this is a tap gesture (not scroll)
    if (_panStartTime != null && _panStartPosition != null) {
      final duration = DateTime.now().difference(_panStartTime!);
      final distance = (details.globalPosition - _panStartPosition!).distance;

      // If movement is too small and fast, allow tap event
      if (duration.inMilliseconds < widget.tapEventDuration && 
          distance < widget.tapEventThreshold) {
        debugPrint('👆 TAP GESTURE: Detected (${duration.inMilliseconds}ms, ${distance.toStringAsFixed(1)}px)');
        // Allow tap event to be triggered
        _resetState();
        return;
      }
    }

    if (_isDiagonalScrolling) {
      debugPrint('🔄 DIAGONAL SCROLL: Ended');
      widget.onDiagonalScrollEnd?.call();
    }

    debugPrint('🏁 GESTURE END: Pan ended');
    _resetState();
  }

  void _updateScrollControllers(double horizontalDelta, double verticalDelta) {
    // Update horizontal scroll
    if (widget.horizontalController.hasClients) {
      final oldHorizontalOffset = widget.horizontalController.offset;
      final newHorizontalOffset = oldHorizontalOffset - horizontalDelta;
      final maxHorizontalExtent = widget.horizontalController.position.maxScrollExtent;
      final clampedHorizontalOffset = newHorizontalOffset.clamp(0.0, maxHorizontalExtent);
      
      widget.horizontalController.jumpTo(clampedHorizontalOffset);
      debugPrint('📱 HORIZONTAL: ${oldHorizontalOffset.toStringAsFixed(1)} → ${clampedHorizontalOffset.toStringAsFixed(1)}');
    }

    // Update vertical scroll
    if (widget.verticalController.hasClients) {
      final oldVerticalOffset = widget.verticalController.offset;
      final newVerticalOffset = oldVerticalOffset - verticalDelta;
      final maxVerticalExtent = widget.verticalController.position.maxScrollExtent;
      final clampedVerticalOffset = newVerticalOffset.clamp(0.0, maxVerticalExtent);
      
      widget.verticalController.jumpTo(clampedVerticalOffset);
      debugPrint('📱 VERTICAL: ${oldVerticalOffset.toStringAsFixed(1)} → ${clampedVerticalOffset.toStringAsFixed(1)}');
    }
  }

  void _checkGestureConflicts(DragStartDetails details) {
    // Check for pinch-to-zoom conflict
    _isPinchZooming = false; // This would be set by parent gesture detector
    
    // Check for drag event conflict
    _isDraggingEvent = false; // This would be set by parent gesture detector
    
    debugPrint('🔍 CONFLICT CHECK: Pinch=${_isPinchZooming}, Drag=${_isDraggingEvent}');
  }

  void _resetState() {
    _isDiagonalScrolling = false;
    _lastPanPosition = null;
    _panStartTime = null;
    _panStartPosition = null;
    _isPinchZooming = false;
    _isDraggingEvent = false;
  }

  // Public methods to control gesture conflicts
  void setPinchZooming(bool isZooming) {
    _isPinchZooming = isZooming;
  }

  void setDraggingEvent(bool isDragging) {
    _isDraggingEvent = isDragging;
  }
}
