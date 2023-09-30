import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:follow_the_leader/follow_the_leader.dart';
import 'package:overlord/follow_the_leader.dart';
import 'package:overlord/overlord.dart';

/// Demo that simulates the presentation of an iOS toolbar when a user
/// expands and contracts a text selection.
///
/// This demo doesn't include any real text selection manipulation. Instead,
/// this demo includes a rectangle that grows and shrinks when the user
/// presses a button. The rectangle that grows and shrinks represents the
/// selection box for some text, where the user drags a handle to expand
/// or contract it. The toolbar disappears while the rectangle changes width,
/// which simulates typical mobile behavior in which a magnifier replaces the
/// toolbar during text expansion.
///
/// This demo was introduced because the iOS toolbar had a mis-aligned arrow
/// every time the user dragged a new selection. The arrow would correct its
/// orientation after forcing a re-paint. As of `follow_the_leader` `v0.0.4+5`,
/// this demo should always display a correctly oriented toolbar arrow after
/// changing the rectangle's size.
class ToolbarExpandingFocalPointDemo extends StatefulWidget {
  const ToolbarExpandingFocalPointDemo({super.key});

  @override
  State<ToolbarExpandingFocalPointDemo> createState() => _ToolbarExpandingFocalPointDemoState();
}

class _ToolbarExpandingFocalPointDemoState extends State<ToolbarExpandingFocalPointDemo>
    with SingleTickerProviderStateMixin {
  final _leaderLink = LeaderLink();
  final _viewportKey = GlobalKey();

  final _baseContentWidth = 10.0;
  final _expansionExtent = ValueNotifier<double>(0);

  late final OverlayEntry _toolbarEntry;

  late final AnimationController _animationController;
  double _startExtent = 10;
  double _endExtent = 10;

  bool _showToolbar = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.completed:
            _startExtent = _endExtent;

            _showToolbar = true;
            _toolbarEntry.markNeedsBuild();
            break;
          case AnimationStatus.dismissed:
          case AnimationStatus.forward:
          case AnimationStatus.reverse:
            // no-op
            break;
        }
      })
      ..addListener(() {
        _expansionExtent.value = lerpDouble(_startExtent, _endExtent, _animationController.value)!;
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _toolbarEntry = OverlayEntry(builder: (_) {
      return _buildToolbarOverlay();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Overlay.of(context).insert(_toolbarEntry);
    });
  }

  @override
  void dispose() {
    _toolbarEntry.remove();

    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _viewportKey,
      child: Center(
        child: Column(
          children: [
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: _expansionExtent,
              builder: (context, expansionExtent, _) {
                return Container(
                  height: 12,
                  width: _baseContentWidth + (2 * expansionExtent) + 2, // +2 for border
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Leader(
                      link: _leaderLink,
                      child: Container(
                        width: _baseContentWidth + expansionExtent,
                        height: 10,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 96),
            TextButton(
              onPressed: () {
                _endExtent = Random().nextDouble() * 200;
                _animationController.forward(from: 0);

                _showToolbar = false;
                _toolbarEntry.markNeedsBuild();
              },
              child: const Text("Change Size"),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarOverlay() {
    if (!_showToolbar) {
      return const SizedBox();
    }

    return FollowerFadeOutBeyondBoundary(
      link: _leaderLink,
      boundary: WidgetFollowerBoundary(
        boundaryKey: _viewportKey,
        devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
      ),
      child: Follower.withAligner(
        link: _leaderLink,
        aligner: CupertinoPopoverToolbarAligner(_viewportKey),
        child: CupertinoPopoverToolbar(
          focalPoint: LeaderMenuFocalPoint(link: _leaderLink),
          // height: 54,
          children: [
            CupertinoPopoverToolbarMenuItem(
              label: 'Cut',
              onPressed: () {},
            ),
            CupertinoPopoverToolbarMenuItem(
              label: 'Copy',
              onPressed: () {},
            ),
            CupertinoPopoverToolbarMenuItem(
              label: 'Paste',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
