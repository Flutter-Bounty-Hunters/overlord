import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follow_the_leader/follow_the_leader.dart';
import 'package:overlord/follow_the_leader.dart';
import 'package:overlord/overlord.dart';

void main() {
  group('iOS Toolbar', () {
    testWidgets('handles a null focal point', (tester) async {
      // A Follower might build when there's no Leader to follow. In that
      // case, the LeaderMenuFocalPoint will have a `null` offset and the
      // toolbar needs to handle that appropriately.
      final leaderLink = LeaderLink();
      await _pumpToolbarScaffold(
        tester,
        child: CupertinoPopoverToolbar(
          focalPoint: LeaderMenuFocalPoint(link: leaderLink),
          children: const [
            CupertinoPopoverToolbarMenuItem(label: 'Style'),
            CupertinoPopoverToolbarMenuItem(label: 'Duplicate'),
            CupertinoPopoverToolbarMenuItem(label: 'Cut'),
            CupertinoPopoverToolbarMenuItem(label: 'Copy'),
            CupertinoPopoverToolbarMenuItem(label: 'Paste')
          ],
        ),
      );
    });
  });
}

Future<void> _pumpToolbarScaffold(WidgetTester tester, {required Widget child}) async {
  tester.binding.window
    ..physicalSizeTestValue = const Size(500, 500)
    ..platformDispatcher.textScaleFactorTestValue = 1.0
    ..devicePixelRatioTestValue = 1.0;
  addTearDown(() => tester.binding.window.clearAllTestValues());

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}
