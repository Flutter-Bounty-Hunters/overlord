import 'package:flutter/material.dart';
import 'package:follow_the_leader/follow_the_leader.dart';
import 'package:overlord/follow_the_leader.dart';
import 'package:overlord/overlord.dart';

class ToolbarWithScrollingFocalPointDemo extends StatefulWidget {
  const ToolbarWithScrollingFocalPointDemo({super.key});

  @override
  State<ToolbarWithScrollingFocalPointDemo> createState() => _ToolbarWithScrollingFocalPointDemoState();
}

class _ToolbarWithScrollingFocalPointDemoState extends State<ToolbarWithScrollingFocalPointDemo> {
  final _leaderLink = LeaderLink();
  final _viewportKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BuildInOrder(
      children: [
        Center(
          child: Column(
            children: [
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300, maxHeight: 500),
                child: ColoredBox(
                  key: _viewportKey,
                  color: Colors.black.withValues(alpha: 0.2),
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      height: 1000,
                      color: Colors.black.withValues(alpha: 0.2),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 250,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Leader(
                                link: _leaderLink,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        FollowerFadeOutBeyondBoundary(
          link: _leaderLink,
          boundary: WidgetFollowerBoundary(boundaryKey: _viewportKey),
          child: Follower.withAligner(
            link: _leaderLink,
            aligner: CupertinoPopoverToolbarAligner(_viewportKey),
            child: CupertinoPopoverToolbar(
              focalPoint: LeaderMenuFocalPoint(link: _leaderLink),
              // height: 54,
              children: [
                CupertinoPopoverToolbarMenuItem(
                  label: 'Cut',
                  onPressed: () {
                    print("Pressed 'Cut'");
                  },
                ),
                CupertinoPopoverToolbarMenuItem(
                  label: 'Copy',
                  onPressed: () {
                    print("Pressed 'Copy'");
                  },
                ),
                CupertinoPopoverToolbarMenuItem(
                  label: 'Paste',
                  onPressed: () {
                    print("Pressed 'Paste'");
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
