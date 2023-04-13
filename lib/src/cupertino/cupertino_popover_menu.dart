import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:overlord/overlord.dart';
import 'package:overlord/src/menus/menu_with_pointer.dart';

/// An iOS-style popover menu.
///
/// A [CupertinoPopoverMenu] displays content within a rounded rectangle shape,
/// along with an arrow that points in the general direction of the [focalPoint].
class CupertinoPopoverMenu extends SingleChildRenderObjectWidget {
  const CupertinoPopoverMenu({
    super.key,
    required this.focalPoint,
    this.borderRadius = 12.0,
    this.arrowBaseWidth = 18.0,
    this.arrowLength = 12.0,
    this.allowHorizontalArrow = true,
    this.backgroundColor = const Color(0xFF474747),
    this.padding,
    this.showDebugPaint = false,
    this.elevation = 0.0,
    this.shadowColor = const Color(0xFF000000),
    this.extendAndClipContentOverArrow = false,
    super.child,
  }) : assert(elevation >= 0.0);

  /// Where the toolbar arrow should point.
  final MenuFocalPoint focalPoint;

  /// Indicates whether or not the arrow can point to a horizontal direction.
  ///
  /// When `false`, the arrow only points up or down.
  final bool allowHorizontalArrow;

  /// Base of the arrow in pixels.
  ///
  /// If the arrow points up or down, [arrowBaseWidth] represents the number of
  /// pixels in the x-axis. Otherwise, it represents the number of pixels
  /// in the y-axis.
  final double arrowBaseWidth;

  /// Extent of the arrow in pixels.
  ///
  /// If the arrow points up or down, [arrowLength] represents the number of
  /// pixels in the y-axis. Otherwise, it represents the number of pixels
  /// in the x-axis.
  final double arrowLength;

  /// Radius of the corners of the menu content area.
  final double borderRadius;

  /// Padding around the popover content.
  final EdgeInsets? padding;

  /// Color of the menu background.
  final Color backgroundColor;

  /// The virtual distance between this menu and the content that sits beneath it, which determines
  /// the size, opacity, and spread of the menu's shadow.
  ///
  /// The value must be non-negative.
  final double elevation;

  /// The color of the shadow cast by this menu.
  ///
  /// The opacity of [shadowColor] is ignored. Instead, the final opacity of the shadow
  /// is determined by [elevation].
  final Color shadowColor;

  /// Whether to extend the popup menu content over the popover's arrow, and clip the content around the arrow.
  ///
  /// A popover includes a rectangular content area, and an arrow that points at some relevant content
  /// beneath the popover. Normally, the content within the popover is confined to the rectangular content
  /// area - the arrow has no impact on the size of the content. However, in some cases, it's desirable for
  /// the content to extend into the arrow space.
  ///
  /// For example, consider an iOS text editing toolbar. That toolbar appears above selected text with buttons
  /// for "copy", "cut", "paste", etc. That toolbar has a popover arrow that points down towards the text. When
  /// the user hovers the mouse over the arrow that points down, that arrow behaves as if it's part of the button
  /// that sits directly above it. The button above the arrow shows a hover highlight, and if the user taps on the
  /// little popover arrow, it activates the button right above it. To accomplish this, the buttons for the toolbar
  /// need to extend vertically to include the height of the popover arrow. Then, those buttons need to be clipped
  /// so that they match the shape of the arrow.
  ///
  /// When this property is `true`, its content is extended to cover the popover arrow, and then that content
  /// is clipped to reflect the shape of the arrow.
  final bool extendAndClipContentOverArrow;

  /// Whether to add decorations that show useful metrics for this popover's
  /// layout and position.
  final bool showDebugPaint;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPopover(
      borderRadius: borderRadius,
      arrowWidth: arrowBaseWidth,
      arrowLength: arrowLength,
      padding: padding,
      screenSize: MediaQuery.of(context).size,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      focalPoint: focalPoint,
      allowHorizontalArrow: allowHorizontalArrow,
      extendAndClipContentOverArrow: extendAndClipContentOverArrow,
      showDebugPaint: showDebugPaint,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderPopover renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..borderRadius = borderRadius
      ..arrowBaseWidth = arrowBaseWidth
      ..arrowLength = arrowLength
      ..padding = padding
      ..screenSize = MediaQuery.of(context).size
      ..focalPoint = focalPoint
      ..backgroundColor = backgroundColor
      ..elevation = elevation
      ..shadowColor = shadowColor
      ..allowHorizontalArrow = allowHorizontalArrow
      ..extendAndClipContentOverArrow = extendAndClipContentOverArrow
      ..showDebugPaint = showDebugPaint;
  }
}

class RenderPopover extends RenderShiftedBox {
  RenderPopover({
    required double borderRadius,
    required double arrowWidth,
    required double arrowLength,
    required Color backgroundColor,
    required double elevation,
    required Color shadowColor,
    required MenuFocalPoint focalPoint,
    required Size screenSize,
    bool allowHorizontalArrow = true,
    bool extendAndClipContentOverArrow = false,
    EdgeInsets? padding,
    bool showDebugPaint = false,
    RenderBox? child,
  })  : _borderRadius = borderRadius,
        _arrowBaseWidth = arrowWidth,
        _arrowLength = arrowLength,
        _padding = padding,
        _screenSize = screenSize,
        _backgroundColor = backgroundColor,
        _elevation = elevation,
        _shadowColor = shadowColor,
        _backgroundPaint = Paint()..color = backgroundColor,
        _focalPoint = focalPoint,
        _allowHorizontalArrow = allowHorizontalArrow,
        _extendAndClipContentOverArrow = extendAndClipContentOverArrow,
        _showDebugPaint = showDebugPaint,
        super(child);

  double _borderRadius;
  double get borderRadius => _borderRadius;
  set borderRadius(double value) {
    if (_borderRadius != value) {
      _borderRadius = value;
      markNeedsLayout();
    }
  }

  double _arrowBaseWidth;
  double get arrowBaseWidth => _arrowBaseWidth;
  set arrowBaseWidth(double value) {
    if (_arrowBaseWidth != value) {
      _arrowBaseWidth = value;
      markNeedsLayout();
    }
  }

  double _arrowLength;
  double get arrowLength => _arrowLength;
  set arrowLength(double value) {
    if (_arrowLength != value) {
      _arrowLength = value;
      markNeedsLayout();
    }
  }

  MenuFocalPoint _focalPoint;
  MenuFocalPoint get focalPoint => _focalPoint;
  set focalPoint(MenuFocalPoint value) {
    if (_focalPoint != value) {
      _focalPoint = value;
      markNeedsLayout();
    }
  }

  EdgeInsets? _padding;
  EdgeInsets? get padding => _padding;
  set padding(EdgeInsets? value) {
    if (_padding != value) {
      _padding = value;
      markNeedsLayout();
    }
  }

  Size _screenSize;
  Size get screenSize => _screenSize;
  set screenSize(Size value) {
    if (value != _screenSize) {
      _screenSize = value;
      markNeedsLayout();
    }
  }

  Color _backgroundColor;
  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color value) {
    if (value != _backgroundColor) {
      _backgroundColor = value;
      _backgroundPaint = Paint()..color = _backgroundColor;
      markNeedsPaint();
    }
  }

  double _elevation;
  double get elevation => _elevation;
  set elevation(double value) {
    if (value != _elevation) {
      _elevation = value;
      markNeedsPaint();
    }
  }

  Color _shadowColor;
  Color get shadowColor => _shadowColor;
  set shadowColor(Color value) {
    if (value != _shadowColor) {
      _shadowColor = value;
      markNeedsPaint();
    }
  }

  bool get allowHorizontalArrow => _allowHorizontalArrow;
  bool _allowHorizontalArrow;
  set allowHorizontalArrow(bool value) {
    if (value != _allowHorizontalArrow) {
      _allowHorizontalArrow = value;
      markNeedsLayout();
    }
  }

  bool get extendAndClipContentOverArrow => _extendAndClipContentOverArrow;
  bool _extendAndClipContentOverArrow;
  set extendAndClipContentOverArrow(bool value) {
    if (value == _extendAndClipContentOverArrow) {
      return;
    }
    _extendAndClipContentOverArrow = value;
    markNeedsLayout();
  }

  set showDebugPaint(bool newValue) {
    if (newValue == _showDebugPaint) {
      return;
    }

    _showDebugPaint = newValue;
    markNeedsPaint();
  }

  /// Returns the size which is be reserved to display the arrow.
  ///
  /// When [extendAndClipContentOverArrow] is `true`, no space is reserved for the arrow on the y-axis.
  /// During paint, the [child] is clipped using the background shape. When it's `false`, we reserve the [arrowLength]
  /// on both top and bottom sides.
  ///
  /// When [allowHorizontalArrow] is `false`, the arrow is only permitted to appear above and below the popup,
  /// so we don't reserve any space on the x-axis. When it's `true` we reserve the [arrowLength] on both
  /// left and right sides.
  Size get _reservedSizeForArrow => Size(
        (allowHorizontalArrow ? arrowLength * 2 : 0),
        (extendAndClipContentOverArrow ? 0.0 : arrowLength * 2),
      );

  /// Returns the offset from the top-left corner of this `RenderObject` to the top-left
  /// corner of the toolbar background shape.
  ///
  /// The toolbar background shape is separated, for example, by the size of the arrow,
  /// which might appear on the left side or top side of the toolbar background shape.
  ///
  /// The arrow is always permitted to appear above and below the popup, therefore
  /// space is always set aside above and below the toolbar background shape.
  /// However, left and right arrows are only permitted when [allowHorizontalArrow] is
  /// `true`. When it's `false`, no space is allocated to the left and right sides of the
  /// toolbar background shape, within this `RenderObject`.
  Offset get _shapeOffset => Offset(
        (allowHorizontalArrow ? arrowLength : 0),
        arrowLength,
      );

  /// The offset from the top-left corner of this `RenderObject` to the top-left
  /// corner of the content.
  ///
  /// This offset's `dx` is the same as the [_shapeOffset]'s `dx`, plus padding.
  ///
  /// When [extendAndClipContentOverArrow] is `true`, this offset's `dy` equals the top padding.
  ///
  /// When [extendAndClipContentOverArrow] is `false`, this offset's `dy` is the same as the
  /// [_shapeOffset]'s `dy`, plus padding.
  Offset _contentOffset = Offset.zero;

  bool _showDebugPaint = false;

  late Paint _backgroundPaint;

  /// Prevents the [ClipPathLayer]'s resources from being disposed.
  ///
  /// When the child's `needsCompositing` is `true`, a new layer is created for clipping during paint.
  final LayerHandle<ClipPathLayer> _clipPathLayer = LayerHandle<ClipPathLayer>();

  /// The popover background shape.
  ///
  /// Includes a rounded rectangle, along with an arrow that points in the general direction of the [focalPoint].
  Path? _backgroundShapePath;

  @override
  void dispose() {
    _clipPathLayer.layer = null;
    super.dispose();
  }

  @override
  void performLayout() {
    final reservedSize = Size(
      (padding?.horizontal ?? 0) + _reservedSizeForArrow.width,
      (padding?.vertical ?? 0) + _reservedSizeForArrow.height,
    );

    // Compute the child constraints to leave space for the arrow and padding.
    BoxConstraints innerConstraints = constraints.enforce(
      BoxConstraints(
        maxHeight: min(_screenSize.height, constraints.maxHeight) - reservedSize.height,
        maxWidth: min(_screenSize.width, constraints.maxWidth) - reservedSize.width,
      ),
    );

    _contentOffset = _computeContentOffset();

    if (_extendAndClipContentOverArrow) {
      // Compute the size the child wants to be.
      child!.layout(innerConstraints, parentUsesSize: true);

      // Add room for the arrow in both top and bottom.
      innerConstraints = constraints.enforce(
        BoxConstraints(minHeight: child!.size.height + arrowLength * 2),
      );
    }

    child!.layout(innerConstraints, parentUsesSize: true);

    size = constraints.constrain(Size(
      reservedSize.width + child!.size.width,
      reservedSize.height + child!.size.height,
    ));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    late ArrowDirection direction;
    late double arrowCenter;

    final localFocalPoint = focalPoint.globalOffset != null ? globalToLocal(focalPoint.globalOffset!) : null;
    if (localFocalPoint != null) {
      // We have a menu focal point. Orient the arrow towards that
      // focal point.
      direction = _computeArrowDirection(Offset.zero & size, localFocalPoint);
      arrowCenter = _computeArrowCenter(direction, localFocalPoint);
    } else {
      // We don't have a menu focal point. Perhaps this is a moment just
      // before, or just after a focal point becomes available. Until then,
      // render with the arrow pointing down from the center of the toolbar,
      // as an arbitrary arrow position.
      direction = ArrowDirection.down;
      arrowCenter = 0.5;
    }

    // Cache the background shape path, so it can be used in hit-testing.
    _backgroundShapePath = _buildBackgroundShapePath(direction, arrowCenter);

    if (elevation != 0.0) {
      final isMenuTranslucent = _backgroundColor.alpha != 0xFF;
      context.canvas.drawShadow(
        _backgroundShapePath!,
        _shadowColor,
        _elevation,
        isMenuTranslucent,
      );
    }

    context.canvas.drawPath(_backgroundShapePath!.shift(offset), _backgroundPaint);

    _clipPathLayer.layer = context.pushClipPath(
      needsCompositing,
      offset,
      Offset.zero & child!.size,
      _backgroundShapePath!,
      (PaintingContext innerContext, Offset innerOffset) {
        innerContext.paintChild(child!, innerOffset + _contentOffset);
      },
      oldLayer: _clipPathLayer.layer,
    );

    if (_showDebugPaint) {
      context.canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5,
      );

      if (localFocalPoint != null) {
        context.canvas.drawCircle(localFocalPoint, 10, Paint()..color = Colors.blue);
      }
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    // Applying our padding offset to the paint transform lets Flutter's
    // "Debug Paint" show the correct child widget bounds.
    return transform.translate(_contentOffset.dx, _contentOffset.dy);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (_backgroundShapePath == null) {
      return false;
    }

    if (!_backgroundShapePath!.contains(position)) {
      return false;
    }

    if (hitTestChildren(result, position: position)) {
      return true;
    }
    // Allow hit-testing around the content, e.g, we might have padding and
    // the user is trying to drag using the padding area.
    final rect = Offset.zero & size;
    return rect.contains(position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintOffset(
      offset: _contentOffset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        assert(transformed == position - _contentOffset);
        return child?.hitTest(result, position: transformed) ?? false;
      },
    );
  }

  /// Builds the path used to paint the menu.
  ///
  /// The path includes a rounded rectangle and a arrow pointing to [arrowDirection], centered at [arrowCenter].
  Path _buildBackgroundShapePath(ArrowDirection arrowDirection, double arrowCenter) {
    final halfOfBase = arrowBaseWidth / 2;

    // Adjust the size to leave space for the arrow.
    // During layout, we reserve space for the arrow in both x and y axis.
    final sizeWithoutArrow = Size(
      size.width - (allowHorizontalArrow ? arrowLength * 2 : 0),
      size.height - arrowLength * 2,
    );

    final contentRect = _shapeOffset & sizeWithoutArrow;

    Path path = Path()..addRRect(RRect.fromRectAndRadius(contentRect, Radius.circular(borderRadius)));

    // Add the arrow.
    if (arrowDirection == ArrowDirection.left) {
      path
        ..moveTo(contentRect.centerLeft.dx, arrowCenter - halfOfBase)
        ..relativeLineTo(-arrowLength, halfOfBase)
        ..relativeLineTo(arrowLength, halfOfBase);
    } else if (arrowDirection == ArrowDirection.right) {
      path
        ..moveTo(contentRect.centerRight.dx, arrowCenter - halfOfBase)
        ..relativeLineTo(arrowLength, halfOfBase)
        ..relativeLineTo(-arrowLength, halfOfBase);
    } else if (arrowDirection == ArrowDirection.up) {
      path
        ..moveTo(arrowCenter - halfOfBase, contentRect.topCenter.dy)
        ..relativeLineTo(halfOfBase, -arrowLength)
        ..relativeLineTo(halfOfBase, arrowLength);
    } else {
      path
        ..moveTo(arrowCenter - halfOfBase, contentRect.bottomCenter.dy)
        ..relativeLineTo(halfOfBase, arrowLength)
        ..relativeLineTo(halfOfBase, -arrowLength);
    }

    path.close();

    return path;
  }

  /// Computes the direction where the arrow should point to.
  ///
  /// If [globalFocalPoint] is inside the [menuRect] horizontal bounds, the arrow points up or right. Otherwise,
  /// the arrow points left or right.
  ///
  /// If [allowHorizontalArrow] is `false`, the arrow only points up or down.
  ArrowDirection _computeArrowDirection(Rect menuRect, Offset globalFocalPoint) {
    final isFocalPointInsideHorizontalBounds =
        globalFocalPoint.dx >= menuRect.left && globalFocalPoint.dx <= menuRect.right;

    if (isFocalPointInsideHorizontalBounds || !allowHorizontalArrow) {
      if (globalFocalPoint.dy < menuRect.top) {
        return ArrowDirection.up;
      }
      return ArrowDirection.down;
    } else {
      if (globalFocalPoint.dx < menuRect.left) {
        return ArrowDirection.left;
      }
      return ArrowDirection.right;
    }
  }

  /// Computes the center point of the arrow.
  ///
  /// This point can be on the x or y axis, depending on the [direction].
  double _computeArrowCenter(ArrowDirection direction, Offset focalPoint) {
    final desiredFocalPoint = _isArrowVertical(direction) //
        ? focalPoint.dx
        : focalPoint.dy;

    return _constrainFocalPoint(desiredFocalPoint, direction);
  }

  /// Computes the (x, y) offset used to paint the menu content inside the popover.
  Offset _computeContentOffset() {
    // The reserved size includes the arrow length on both sides.
    //
    // The width includes the arrow length in both left and right.
    // The height includes the arrow length in both top and bottom.
    // Divide by two, so we only translate one arrow length.
    return Offset(
      (padding?.left ?? 0) + (_reservedSizeForArrow.width / 2.0),
      (padding?.top ?? 0) + (_reservedSizeForArrow.height / 2.0),
    );
  }

  /// Indicates whether or not the arrow points to a vertical direction.
  bool _isArrowVertical(ArrowDirection arrowDirection) =>
      arrowDirection == ArrowDirection.up || arrowDirection == ArrowDirection.down;

  /// Minimum focal point for the given [arrowDirection] in which the arrow can be displayed inside the popover bounds.
  double _minArrowFocalPoint(ArrowDirection arrowDirection) => _isArrowVertical(arrowDirection)
      ? _minArrowHorizontalCenter(arrowDirection)
      : _minArrowVerticalCenter(arrowDirection);

  /// Maximum focal point for the given [arrowDirection] in which the arrow can be displayed inside the popover bounds.
  double _maxArrowFocalPoint(ArrowDirection arrowDirection) => _isArrowVertical(arrowDirection)
      ? _maxArrowHorizontalCenter(arrowDirection)
      : _maxArrowVerticalCenter(arrowDirection);

  /// Minimum distance on the x-axis in which the arrow can be displayed without being above the corner.
  double _minArrowHorizontalCenter(ArrowDirection arrowDirection) =>
      (borderRadius + arrowBaseWidth / 2) + _shapeOffset.dx;

  /// Maximum distance on the x-axis in which the arrow can be displayed without being above the corner.
  double _maxArrowHorizontalCenter(ArrowDirection arrowDirection) =>
      (size.width - borderRadius - arrowBaseWidth - _shapeOffset.dx / 2);

  /// Minimum distance on the y-axis which the arrow can be displayed without being above the corner.
  double _minArrowVerticalCenter(ArrowDirection arrowDirection) => (borderRadius + arrowBaseWidth / 2) + arrowLength;

  /// Maximum distance on the y-axis which the arrow can be displayed without being above the corner.
  double _maxArrowVerticalCenter(ArrowDirection arrowDirection) =>
      (size.height - borderRadius - arrowLength - (arrowBaseWidth / 2));

  /// Constrain the focal point to be inside the menu bounds, respecting the minimum and maximum focal points.
  double _constrainFocalPoint(double desiredFocalPoint, ArrowDirection arrowDirection) {
    return min(max(desiredFocalPoint, _minArrowFocalPoint(arrowDirection)), _maxArrowFocalPoint(arrowDirection));
  }
}

/// Direction where a arrow points to.
enum ArrowDirection {
  up,
  down,
  left,
  right,
}
