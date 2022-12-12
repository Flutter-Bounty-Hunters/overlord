import 'package:flutter/material.dart';
import 'package:follow_the_leader/follow_the_leader.dart';
import 'package:overlord/src/menus/menu_with_pointer.dart';

class MenuWithPointerBuilder extends StatefulWidget {
  const MenuWithPointerBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final void Function(BuildContext, Offset focalPoint) builder;

  @override
  State<MenuWithPointerBuilder> createState() => _MenuWithPointerBuilderState();
}

class _MenuWithPointerBuilderState extends State<MenuWithPointerBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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
    if (!_link.leaderConnected) {
      return null;
    }

    final leaderRect = _link.leader!.offset & _link.leaderSize!;
    return _alignment.withinRect(leaderRect);
  }
}
