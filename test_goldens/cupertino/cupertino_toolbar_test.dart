import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_goldens/flutter_test_goldens.dart';
import 'package:overlord/overlord.dart';

void main() {
  group("Cupertino > toolbar >", () {
    testGoldenSceneOnIOS("fits buttons and points places", (tester) async {
      await Gallery(
        "Cupertino Toolbar",
        fileName: "cupertino-toolbar",
        layout: const GridGoldenSceneLayout(),
        itemConstraints: BoxConstraints.tight(const Size(600, 150)),
      ) //
          // Pointing down.
          .itemFromWidget(
            description: "Left (Max) Down",
            widget: _buildIosToolbar(arrowFocalPoint: const Offset(0, 500)),
          )
          .itemFromWidget(
            description: "Left(ish) Down",
            widget: _buildIosToolbar(arrowFocalPoint: const Offset(200, 500)),
          )
          .itemFromWidget(
            description: "Center Down",
            widget: _buildIosToolbar(arrowFocalPoint: const Offset(300, 500)),
          )
          .itemFromWidget(
            description: "Right(ish) Down",
            widget: _buildIosToolbar(arrowFocalPoint: const Offset(400, 500)),
          )
          .itemFromWidget(
            description: "Right (Max) Down",
            widget: _buildIosToolbar(arrowFocalPoint: const Offset(600, 500)),
          )
          // Pointing up.
          .itemFromWidget(
            description: "Left (Max) Up",
            widget: _buildIosToolbar(arrowFocalPoint: const Offset(0, 0)),
          )
          .itemFromWidget(
            description: "Left(ish) Up",
            widget: _buildIosToolbar(arrowFocalPoint: const Offset(200, 0)),
          )
          .itemFromWidget(
            description: "Center Up",
            widget: _buildIosToolbar(arrowFocalPoint: const Offset(300, 0)),
          )
          .itemFromWidget(
            description: "Right(ish) Up",
            widget: _buildIosToolbar(arrowFocalPoint: const Offset(400, 0)),
          )
          .itemFromWidget(
            description: "Right (Max) Up",
            widget: _buildIosToolbar(arrowFocalPoint: const Offset(600, 0)),
          )
          .run(tester);
    });

    testGoldenSceneOnIOS("auto pagination (not enough space)", (tester) async {
      await Timeline(
        "Cupertino Toolbar Pagination (Auto)",
        fileName: "cupertino-toolbar-pagination-auto",
        layout: const AnimationTimelineSceneLayout(),
        windowSize: const Size(600, 150),
      ) //
          .setupWithWidget(
            _buildToolbarScaffold(
              child: const CupertinoPopoverToolbar(
                focalPoint: StationaryMenuFocalPoint(Offset(300, 150)),
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
          )
          .takePhoto("Page 1")
          .tap(find.widgetWithIcon(TextButton, Icons.chevron_right))
          .settle()
          .takePhoto("Page 2")
          .tap(find.widgetWithIcon(TextButton, Icons.chevron_right))
          .settle()
          .takePhoto("Page 3")
          .tap(find.widgetWithIcon(TextButton, Icons.chevron_right))
          .settle()
          .takePhoto("Page 4")
          .run(tester);
    });

    testGoldenSceneOnIOS("manual pagination", (tester) async {
      await Timeline(
        "Cupertino Toolbar Pagination (Manual)",
        fileName: "cupertino-toolbar-pagination-manual",
        layout: const AnimationTimelineSceneLayout(),
        windowSize: const Size(700, 150),
      ) //
          .setupWithWidget(
            _buildToolbarScaffold(
              child: CupertinoPopoverToolbar.paginated(
                focalPoint: const StationaryMenuFocalPoint(Offset(350, 150)),
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
            ),
          )
          .takePhoto("Page 1")
          .tap(find.widgetWithIcon(TextButton, Icons.chevron_right))
          .settle()
          .takePhoto("Page 2")
          .run(tester);
    });
  });
}

Widget _buildIosToolbar({
  required Offset arrowFocalPoint,
}) {
  return _buildToolbarScaffold(
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

Widget _buildToolbarScaffold({required Widget child}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
    debugShowCheckedModeBanner: false,
  );
}
