import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:overlord/overlord.dart';
import 'package:overlord/src/menus/menu_with_pointer.dart';

void main() {
  group('iOS Toolbar', () {
    group('pointing up', () {
      testGoldens('with center focal point', (tester) async {
        await loadAppFonts();

        await _pumpIosToolbar(tester, arrowFocalPoint: const Offset(250, 0));

        await screenMatchesGolden(tester, 'cupertino-toolbar/pointing-up-center-focal-point');
      });

      testGoldens('with left focal point', (tester) async {
        await loadAppFonts();

        await _pumpIosToolbar(tester, arrowFocalPoint: const Offset(200, 0));

        await screenMatchesGolden(tester, 'cupertino-toolbar/pointing-up-left-focal-point');
      });

      testGoldens('with left focal point too low', (tester) async {
        await loadAppFonts();

        await _pumpIosToolbar(tester, arrowFocalPoint: const Offset(0, 0));

        await screenMatchesGolden(tester, 'cupertino-toolbar/pointing-up-left-focal-point-too-low');
      });

      testGoldens('with right focal point', (tester) async {
        await loadAppFonts();

        await _pumpIosToolbar(tester, arrowFocalPoint: const Offset(300, 0));

        await screenMatchesGolden(tester, 'cupertino-toolbar/pointing-up-right-focal-point');
      });

      testGoldens('with right focal point too big', (tester) async {
        await loadAppFonts();

        await _pumpIosToolbar(tester, arrowFocalPoint: const Offset(600, 0));

        await screenMatchesGolden(tester, 'cupertino-toolbar/pointing-up-right-focal-point-too-big');
      });
    });

    group('pointing down', () {
      testGoldens('with center focal point', (tester) async {
        await loadAppFonts();

        await _pumpIosToolbar(tester, arrowFocalPoint: const Offset(250, 1000));

        await screenMatchesGolden(tester, 'cupertino-toolbar/pointing-down-center-focal-point');
      });

      testGoldens('with left focal point', (tester) async {
        await loadAppFonts();

        await _pumpIosToolbar(tester, arrowFocalPoint: const Offset(150, 1000));

        await screenMatchesGolden(tester, 'cupertino-toolbar/pointing-down-left-focal-point');
      });

      testGoldens('with left focal point too low', (tester) async {
        await loadAppFonts();

        await _pumpIosToolbar(tester, arrowFocalPoint: const Offset(0, 1000));

        await screenMatchesGolden(tester, 'cupertino-toolbar/pointing-down-left-focal-point-too-low');
      });

      testGoldens('with right focal point', (tester) async {
        await loadAppFonts();

        await _pumpIosToolbar(tester, arrowFocalPoint: const Offset(350, 1000));

        await screenMatchesGolden(tester, 'cupertino-toolbar/pointing-down-right-focal-point');
      });

      testGoldens('with right focal point too big', (tester) async {
        await loadAppFonts();

        await _pumpIosToolbar(tester, arrowFocalPoint: const Offset(1000, 1000));

        await screenMatchesGolden(tester, 'cupertino-toolbar/pointing-down-right-focal-point-too-big');
      });
    });

    group('pagination', () {
      testGoldens('auto paginates to fit available space', (tester) async {
        await loadAppFonts();

        await _pumpToolbarScaffold(
          tester,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: const CupertinoPopoverToolbar(
              focalPoint: StationaryMenuFocalPoint(Offset(250, 0)),
              children: [
                CupertinoPopoverToolbarMenuItem(label: 'Style'),
                CupertinoPopoverToolbarMenuItem(label: 'Duplicate'),
                CupertinoPopoverToolbarMenuItem(label: 'Cut'),
                CupertinoPopoverToolbarMenuItem(label: 'Copy'),
                CupertinoPopoverToolbarMenuItem(label: 'Paste'),
                CupertinoPopoverToolbarMenuItem(label: 'Delete'),
                CupertinoPopoverToolbarMenuItem(label: 'Long Thing 1'),
                CupertinoPopoverToolbarMenuItem(label: 'Long Thing 2'),
                CupertinoPopoverToolbarMenuItem(label: 'Long Thing 3'),
                CupertinoPopoverToolbarMenuItem(label: 'Long Thing 4'),
              ],
            ),
          ),
        );

        await screenMatchesGolden(tester, 'cupertino-toolbar/auto-paginated-page1');

        // Tap the next page button.
        await tester.tap(find.widgetWithIcon(TextButton, Icons.arrow_right));
        await tester.pumpAndSettle();

        await screenMatchesGolden(tester, 'cupertino-toolbar/auto-paginated-page2');

        // Tap the next page button.
        await tester.tap(find.widgetWithIcon(TextButton, Icons.arrow_right));
        await tester.pumpAndSettle();

        await screenMatchesGolden(tester, 'cupertino-toolbar/auto-paginated-page3');

        // Tap the next page button.
        await tester.tap(find.widgetWithIcon(TextButton, Icons.arrow_right));
        await tester.pumpAndSettle();

        await screenMatchesGolden(tester, 'cupertino-toolbar/auto-paginated-page4');
      });

      testGoldens('respects manual pagination', (tester) async {
        await loadAppFonts();

        await _pumpToolbarScaffold(
          tester,
          child: CupertinoPopoverToolbar.paginated(
            focalPoint: const StationaryMenuFocalPoint(Offset(250, 0)),
            pages: [
              MenuPage(
                items: const [
                  CupertinoPopoverToolbarMenuItem(label: 'Style'),
                  CupertinoPopoverToolbarMenuItem(label: 'Duplicate'),
                ],
              ),
              MenuPage(
                items: const [
                  CupertinoPopoverToolbarMenuItem(label: 'Cut'),
                  CupertinoPopoverToolbarMenuItem(label: 'Copy'),
                  CupertinoPopoverToolbarMenuItem(label: 'Paste'),
                  CupertinoPopoverToolbarMenuItem(label: 'Delete'),
                  CupertinoPopoverToolbarMenuItem(label: 'Long Thing 1'),
                ],
              ),
            ],
          ),
        );

        await screenMatchesGolden(tester, 'cupertino-toolbar/manual-pagination-page1');

        // Tap the next page button.
        await tester.tap(find.widgetWithIcon(TextButton, Icons.arrow_right));
        await tester.pumpAndSettle();

        await screenMatchesGolden(tester, 'cupertino-toolbar/manual-pagination-page2');
      });
    });
  });

  group('iOS Popover Menu', () {
    group('pointing up', () {
      testGoldens('with center focal point', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(250, 0),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-up-center-focal-point');
      });

      testGoldens('with left focal point', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(200, 0),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-up-left-focal-point');
      });

      testGoldens('with left focal point too low', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(118, 0),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-up-left-focal-point-too-low');
      });

      testGoldens('with right focal point', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(280, 0),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-up-right-focal-point');
      });

      testGoldens('with right focal point too big', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(358, 0),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-up-right-focal-point-too-big');
      });
    });

    group('pointing down', () {
      testGoldens('with center focal point', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(250, 1000),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-down-center-focal-point');
      });

      testGoldens('with left focal point', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(210, 1000),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-down-left-focal-point');
      });

      testGoldens('with left focal point too low', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(118, 1000),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-down-left-focal-point-too-low');
      });

      testGoldens('with right focal point', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(280, 1000),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-down-right-focal-point');
      });

      testGoldens('with right focal point too big', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(358, 1000),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-down-right-focal-point-too-big');
      });
    });

    group('pointing left', () {
      testGoldens('with center focal point', (tester) async {
        await _pumpPopoverMenuTestApp(tester, arrowFocalPoint: const Offset(0, 242));

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-left-center-focal-point');
      });

      testGoldens('with top focal point', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(0, 200),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-left-top-focal-point');
      });

      testGoldens('with top focal point too low', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(0, 0),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-left-top-focal-point-too-low');
      });

      testGoldens('with bottom focal point', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(0, 260),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-left-bottom-focal-point');
      });

      testGoldens('with bottom focal point too big', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(0, 1000),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-left-bottom-focal-point-too-big');
      });
    });

    group('pointing right', () {
      testGoldens('without center focal point', (tester) async {
        await _pumpPopoverMenuTestApp(tester, arrowFocalPoint: const Offset(1000, 242));

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-right-center-focal-point');
      });

      testGoldens('with top focal point', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(1000, 200),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-right-top-focal-point');
      });

      testGoldens('with top focal point too low', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(1000, 0),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-right-top-focal-point-too-low');
      });

      testGoldens('with bottom focal point', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(1000, 260),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-right-bottom-focal-point');
      });

      testGoldens('with bottom focal point too big', (tester) async {
        await _pumpPopoverMenuTestApp(
          tester,
          arrowFocalPoint: const Offset(1000, 1000),
        );

        await screenMatchesGolden(tester, 'cupertino-popover-menu/pointing-right-bottom-focal-point-too-big');
      });
    });
  });
}

Future<void> _pumpIosToolbar(
  WidgetTester tester, {
  required Offset arrowFocalPoint,
}) async {
  await _pumpToolbarScaffold(
    tester,
    child: CupertinoPopoverToolbar(
      focalPoint: StationaryMenuFocalPoint(arrowFocalPoint),
      children: const [
        CupertinoPopoverToolbarMenuItem(label: 'Style'),
        CupertinoPopoverToolbarMenuItem(label: 'Duplicate'),
        CupertinoPopoverToolbarMenuItem(label: 'Cut'),
        CupertinoPopoverToolbarMenuItem(label: 'Copy'),
        CupertinoPopoverToolbarMenuItem(label: 'Paste')
      ],
    ),
  );
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

Future<void> _pumpPopoverMenuTestApp(
  WidgetTester tester, {
  required Offset arrowFocalPoint,
}) async {
  tester.binding.window
    ..physicalSizeTestValue = const Size(500, 500)
    ..platformDispatcher.textScaleFactorTestValue = 1.0
    ..devicePixelRatioTestValue = 1.0;
  addTearDown(() => tester.binding.window.clearAllTestValues());

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CupertinoPopoverMenu(
            focalPoint: StationaryMenuFocalPoint(arrowFocalPoint),
            child: const SizedBox(
              width: 254,
              height: 159,
              child: Center(
                child: Text(
                  'Popover Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
