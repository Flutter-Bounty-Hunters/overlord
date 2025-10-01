import 'package:flutter/widgets.dart';
import 'package:follow_the_leader/follow_the_leader.dart';
import 'package:overlord/overlord.dart';

/// Aligns an iOS-style popover toolbar `Follower` with a `Leader` widget.
///
/// Use with `Follower.withDynamics` to position the toolbar based on
/// proximity to the bounds of the screen.
class CupertinoPopoverToolbarAligner implements FollowerAligner {
  CupertinoPopoverToolbarAligner({
    this.toolbarVerticalOffsetAbove = 20,
    this.toolbarVerticalOffsetBelow = 20,
  });

  /// The vertical offset to apply between the toolbar and the leader
  /// when the toolbar is positioned above the leader.
  final double toolbarVerticalOffsetAbove;

  /// The vertical offset to apply between the toolbar and the leader
  /// when the toolbar is positioned below the leader.
  final double toolbarVerticalOffsetBelow;

  @override
  FollowerAlignment align(Rect globalLeaderRect, Size followerSize, [Rect? globalBounds]) {
    final bounds = globalBounds ?? Rect.largest;

    late FollowerAlignment alignment;
    if (globalLeaderRect.top - followerSize.height - _popoverToolbarMinimumDistanceFromEdge < bounds.top) {
      OverlordLogs.cupertinoToolbar.fine(" - follower is too far to the top, switching to bottom");
      // The follower hit the minimum distance. Invert the follower position.
      alignment = FollowerAlignment(
        leaderAnchor: Alignment.bottomCenter,
        followerAnchor: Alignment.topCenter,
        followerOffset: Offset(0, toolbarVerticalOffsetBelow),
      );
    } else {
      // There's enough room to display toolbar above content. That's our desired
      // default position, so put the toolbar on top.
      alignment = FollowerAlignment(
        leaderAnchor: Alignment.topCenter,
        followerAnchor: Alignment.bottomCenter,
        followerOffset: Offset(0, -toolbarVerticalOffsetAbove),
      );
    }

    return alignment;
  }
}

const double _popoverToolbarMinimumDistanceFromEdge = 16;

/// Aligns an iOS-style popover menu `Follower` with a `Leader` widget.
///
/// Use with `Follower.withDynamics` to position the menu based on
/// proximity to the bounds of the screen.
class CupertinoPopoverMenuAligner implements FollowerAligner {
  CupertinoPopoverMenuAligner();

  FollowerAlignment _previousFollowerAlignment = const FollowerAlignment(
    leaderAnchor: Alignment.topCenter,
    followerAnchor: Alignment.bottomCenter,
    followerOffset: Offset(0, -20),
  );

  @override
  FollowerAlignment align(Rect globalLeaderRect, Size followerSize, [Rect? globalBounds]) {
    final bounds = globalBounds ?? Rect.largest;

    late FollowerAlignment alignment;
    if (globalLeaderRect.right + followerSize.width + _popoverMenuMinimumDistanceFromEdge >= bounds.right) {
      OverlordLogs.cupertinoMenu.fine(" - follower is too far to the right, switching to left");
      // The follower hit the minimum distance. Invert the follower position.
      alignment = const FollowerAlignment(
        leaderAnchor: Alignment.centerLeft,
        followerAnchor: Alignment.centerRight,
        followerOffset: Offset(-20, 0),
      );
    } else if (globalLeaderRect.left - followerSize.width - _popoverMenuMinimumDistanceFromEdge < bounds.left) {
      OverlordLogs.cupertinoMenu.fine(" - follower is too far to the left, switching to right");
      // The follower hit the minimum distance. Invert the follower position.
      alignment = const FollowerAlignment(
        leaderAnchor: Alignment.centerRight,
        followerAnchor: Alignment.centerLeft,
        followerOffset: Offset(20, 0),
      );
    } else {
      // We're not too far to the left or the right. Keep us wherever we were before.
      alignment = _previousFollowerAlignment;
    }

    _previousFollowerAlignment = alignment;

    return alignment;
  }
}

const double _popoverMenuMinimumDistanceFromEdge = 16;
