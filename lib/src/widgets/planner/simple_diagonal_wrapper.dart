import 'package:flutter/material.dart';

class SimpleDiagonalWrapper extends StatefulWidget {
  const SimpleDiagonalWrapper({
    super.key,
    required this.horizontalController,
    required this.verticalController,
    required this.child,
    this.enableDiagonalScroll = true,
    this.diagonalScrollSensitivity = 1.0,
    this.onDiagonalScrollStart,
    this.onDiagonalScrollUpdate,
    this.onDiagonalScrollEnd,
  });

  final ScrollController horizontalController;
  final ScrollController verticalController;
  final Widget child;
  final bool enableDiagonalScroll;
  final double diagonalScrollSensitivity;
  final VoidCallback? onDiagonalScrollStart;
  final void Function(double horizontalDelta, double verticalDelta)? onDiagonalScrollUpdate;
  final VoidCallback? onDiagonalScrollEnd;

  @override
  State<SimpleDiagonalWrapper> createState() => _SimpleDiagonalWrapperState();
}

class _SimpleDiagonalWrapperState extends State<SimpleDiagonalWrapper> {
  bool _isDiagonalScrolling = false;
  Offset? _lastPanPosition;

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
    _lastPanPosition = details.globalPosition;
    _isDiagonalScrolling = false;
    debugPrint('🎯 SIMPLE DIAGONAL: Pan started at ${details.globalPosition}');
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_lastPanPosition == null) return;

    final delta = details.globalPosition - _lastPanPosition!;
    final horizontalDelta = delta.dx * widget.diagonalScrollSensitivity;
    final verticalDelta = delta.dy * widget.diagonalScrollSensitivity;

    // Always show movement for debugging
    debugPrint('📊 SIMPLE MOVEMENT: H=${horizontalDelta.toStringAsFixed(1)}, V=${verticalDelta.toStringAsFixed(1)}');

    // Very low threshold for diagonal detection
    if (horizontalDelta.abs() > 1 && verticalDelta.abs() > 1) {
      if (!_isDiagonalScrolling) {
        _isDiagonalScrolling = true;
        debugPrint('🔄 SIMPLE DIAGONAL: Started! (H=${horizontalDelta.toStringAsFixed(1)}, V=${verticalDelta.toStringAsFixed(1)})');
        widget.onDiagonalScrollStart?.call();
      }

      // Update scroll controllers immediately
      _updateScrollControllers(horizontalDelta, verticalDelta);
      widget.onDiagonalScrollUpdate?.call(horizontalDelta, verticalDelta);
    } else {
      if (horizontalDelta.abs() > 1 && verticalDelta.abs() <= 1) {
        debugPrint('➡️ SIMPLE HORIZONTAL: Detected (H=${horizontalDelta.toStringAsFixed(1)})');
      } else if (verticalDelta.abs() > 1 && horizontalDelta.abs() <= 1) {
        debugPrint('⬆️ SIMPLE VERTICAL: Detected (V=${verticalDelta.toStringAsFixed(1)})');
      }
    }

    _lastPanPosition = details.globalPosition;
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDiagonalScrolling) {
      debugPrint('🔄 SIMPLE DIAGONAL: Ended');
      widget.onDiagonalScrollEnd?.call();
    }
    
    _isDiagonalScrolling = false;
    _lastPanPosition = null;
    debugPrint('🏁 SIMPLE DIAGONAL: Pan ended');
  }

  void _updateScrollControllers(double horizontalDelta, double verticalDelta) {
    // Update horizontal scroll
    if (widget.horizontalController.hasClients) {
      final newHorizontalOffset = widget.horizontalController.offset - horizontalDelta;
      final maxHorizontalExtent = widget.horizontalController.position.maxScrollExtent;
      final clampedHorizontalOffset = newHorizontalOffset.clamp(0.0, maxHorizontalExtent);
      
      widget.horizontalController.jumpTo(clampedHorizontalOffset);
      debugPrint('📱 SIMPLE HORIZONTAL: ${widget.horizontalController.offset.toStringAsFixed(1)} → ${clampedHorizontalOffset.toStringAsFixed(1)}');
    }

    // Update vertical scroll
    if (widget.verticalController.hasClients) {
      final newVerticalOffset = widget.verticalController.offset - verticalDelta;
      final maxVerticalExtent = widget.verticalController.position.maxScrollExtent;
      final clampedVerticalOffset = newVerticalOffset.clamp(0.0, maxVerticalExtent);
      
      widget.verticalController.jumpTo(clampedVerticalOffset);
      debugPrint('📱 SIMPLE VERTICAL: ${widget.verticalController.offset.toStringAsFixed(1)} → ${clampedVerticalOffset.toStringAsFixed(1)}');
    }
  }
}

