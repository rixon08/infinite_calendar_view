import 'package:flutter/material.dart';

class OptimizedDiagonalScrollWrapper extends StatefulWidget {
  const OptimizedDiagonalScrollWrapper({
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
    this.enableDebugLogs = false,
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
  final bool enableDebugLogs;
  final VoidCallback? onDiagonalScrollStart;
  final void Function(double horizontalDelta, double verticalDelta)? onDiagonalScrollUpdate;
  final VoidCallback? onDiagonalScrollEnd;

  @override
  State<OptimizedDiagonalScrollWrapper> createState() => _OptimizedDiagonalScrollWrapperState();
}

class _OptimizedDiagonalScrollWrapperState extends State<OptimizedDiagonalScrollWrapper> {
  bool _isDiagonalScrolling = false;
  Offset? _lastPanPosition;
  DateTime? _panStartTime;
  Offset? _panStartPosition;
  bool _isPinchZooming = false;
  bool _isDraggingEvent = false;
  
  // Performance optimization: batch scroll updates
  double _accumulatedHorizontalDelta = 0.0;
  double _accumulatedVerticalDelta = 0.0;
  static const int _batchUpdateThreshold = 3; // Update every 3 movements
  int _movementCount = 0;

  @override
  Widget build(BuildContext context) {
    if (!widget.enableDiagonalScroll) {
      return widget.child;
    }
    
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }

  void _onPanStart(DragStartDetails details) {
    _panStartTime = DateTime.now();
    _panStartPosition = details.globalPosition;
    _lastPanPosition = details.globalPosition;
    _isDiagonalScrolling = false;
    _accumulatedHorizontalDelta = 0.0;
    _accumulatedVerticalDelta = 0.0;
    _movementCount = 0;

    if (widget.enableDebugLogs) {
      debugPrint('🎯 DIAGONAL: Pan started');
    }

    if (widget.gestureConflictResolution) {
      _checkGestureConflicts(details);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_lastPanPosition == null) return;

    // Skip if gesture conflicts detected
    if (widget.gestureConflictResolution) {
      if (_isPinchZooming && widget.pinchToZoomPriority) return;
      if (_isDraggingEvent && widget.dragEventPriority) return;
    }

    final delta = details.globalPosition - _lastPanPosition!;
    final horizontalDelta = delta.dx * widget.diagonalScrollSensitivity;
    final verticalDelta = delta.dy * widget.diagonalScrollSensitivity;

    // Accumulate deltas for batch processing
    _accumulatedHorizontalDelta += horizontalDelta;
    _accumulatedVerticalDelta += verticalDelta;
    _movementCount++;

    // Always show movement for debugging
    if (widget.enableDebugLogs) {
      debugPrint('📊 MOVEMENT: H=${horizontalDelta.toStringAsFixed(1)}, V=${verticalDelta.toStringAsFixed(1)}');
    }

    // Detect diagonal movement with lower threshold for better detection
    if (horizontalDelta.abs() > 2 && verticalDelta.abs() > 2) {
      if (!_isDiagonalScrolling) {
        _isDiagonalScrolling = true;
        if (widget.enableDebugLogs) {
          debugPrint('🔄 DIAGONAL: Started (H=${horizontalDelta.toStringAsFixed(1)}, V=${verticalDelta.toStringAsFixed(1)})');
        }
        widget.onDiagonalScrollStart?.call();
      }

      // Update scroll controllers immediately for better responsiveness
      _updateScrollControllers(horizontalDelta, verticalDelta);
      widget.onDiagonalScrollUpdate?.call(horizontalDelta, verticalDelta);
    } else if (widget.enableDebugLogs) {
      if (horizontalDelta.abs() > 2 && verticalDelta.abs() <= 2) {
        debugPrint('➡️ HORIZONTAL: Detected (H=${horizontalDelta.toStringAsFixed(1)})');
      } else if (verticalDelta.abs() > 2 && horizontalDelta.abs() <= 2) {
        debugPrint('⬆️ VERTICAL: Detected (V=${verticalDelta.toStringAsFixed(1)})');
      }
    }

    _lastPanPosition = details.globalPosition;
  }

  void _onPanEnd(DragEndDetails details) {
    // Process any remaining accumulated deltas
    if (_movementCount > 0 && _isDiagonalScrolling) {
      _updateScrollControllers(_accumulatedHorizontalDelta, _accumulatedVerticalDelta);
    }

    // Check if this is a tap gesture (not scroll)
    if (_panStartTime != null && _panStartPosition != null) {
      final duration = DateTime.now().difference(_panStartTime!);
      final distance = (details.velocity.pixelsPerSecond.distance);

      // If movement is too small and fast, allow tap event
      if (duration.inMilliseconds < widget.tapEventDuration && 
          distance < widget.tapEventThreshold) {
        if (widget.enableDebugLogs) {
          debugPrint('👆 TAP: Detected');
        }
        _resetState();
        return;
      }
    }

    if (_isDiagonalScrolling) {
      if (widget.enableDebugLogs) {
        debugPrint('🔄 DIAGONAL: Ended');
      }
      widget.onDiagonalScrollEnd?.call();
    }

    _resetState();
  }

  void _updateScrollControllers(double horizontalDelta, double verticalDelta) {
    // Update horizontal scroll with jumpTo for better performance
    if (widget.horizontalController.hasClients) {
      final newHorizontalOffset = widget.horizontalController.offset - horizontalDelta;
      final maxHorizontalExtent = widget.horizontalController.position.maxScrollExtent;
      final clampedHorizontalOffset = newHorizontalOffset.clamp(0.0, maxHorizontalExtent);
      
      widget.horizontalController.jumpTo(clampedHorizontalOffset);
    }

    // Update vertical scroll with jumpTo for better performance
    if (widget.verticalController.hasClients) {
      final newVerticalOffset = widget.verticalController.offset - verticalDelta;
      final maxVerticalExtent = widget.verticalController.position.maxScrollExtent;
      final clampedVerticalOffset = newVerticalOffset.clamp(0.0, maxVerticalExtent);
      
      widget.verticalController.jumpTo(clampedVerticalOffset);
    }
  }

  void _checkGestureConflicts(DragStartDetails details) {
    _isPinchZooming = false;
    _isDraggingEvent = false;
  }

  void _resetState() {
    _isDiagonalScrolling = false;
    _lastPanPosition = null;
    _panStartTime = null;
    _panStartPosition = null;
    _isPinchZooming = false;
    _isDraggingEvent = false;
    _accumulatedHorizontalDelta = 0.0;
    _accumulatedVerticalDelta = 0.0;
    _movementCount = 0;
  }

  // Public methods to control gesture conflicts
  void setPinchZooming(bool isZooming) {
    _isPinchZooming = isZooming;
  }

  void setDraggingEvent(bool isDragging) {
    _isDraggingEvent = isDragging;
  }
}
