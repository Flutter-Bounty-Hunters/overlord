import 'dart:ui';

/// A focal point for the arrow on a popover menu, such as an iOS-style
/// popover toolbar, which points at the content it applies to.
abstract class MenuFocalPoint {
  Offset? get globalOffset;
}

/// A [MenuFocalPoint] that never changes.
class StationaryMenuFocalPoint implements MenuFocalPoint {
  const StationaryMenuFocalPoint(this.globalOffset);

  @override
  final Offset globalOffset;
}

// TODO: a rounded rectangle menu with an arrow that points towards a focal point
