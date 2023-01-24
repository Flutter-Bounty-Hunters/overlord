import 'package:flutter/material.dart';
import 'package:follow_the_leader/follow_the_leader.dart';
import 'package:overlord/src/menus/menu_with_pointer.dart';

/// A [MenuFocalPoint] that's calculated on demand, based on the bounding
/// rectangle of a [Leader].
class LeaderMenuFocalPoint implements MenuFocalPoint {
  const LeaderMenuFocalPoint({
    required LeaderLink link,
    Alignment alignment = Alignment.center,
  })  : _link = link,
        _alignment = alignment;

  final LeaderLink _link;
  final Alignment _alignment;

  @override
  Offset? get globalOffset {
    if (!_link.leaderConnected || _link.offset == null) {
      return null;
    }

    return _link.getOffsetInLeader(_alignment)!;
  }
}
