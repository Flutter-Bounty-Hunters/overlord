import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_goldens/flutter_test_goldens.dart';
import 'package:overlord/overlord.dart';

void main() {
  group("Cupertino > popover >", () {
    testGoldenSceneOnIOS("points places", (tester) async {
      await Gallery(
        "Cupertino Popover",
        fileName: "cupertino-popover",
        layout: const GridGoldenSceneLayout(),
        itemConstraints: BoxConstraints.tight(const Size(500, 500)),
      ) //
          // Pointing left.
          .itemFromWidget(
            description: "Left (Top)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(0, 0)),
          )
          .itemFromWidget(
            description: "Left (Middle)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(0, 250)),
          )
          .itemFromWidget(
            description: "Center (Bottom)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(0, 500)),
          )
          // Pointing up.
          .itemFromWidget(
            description: "Up (Left)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(150, 0)),
          )
          .itemFromWidget(
            description: "Up (Center)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(250, 0)),
          )
          .itemFromWidget(
            description: "Up (Right)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(350, 0)),
          )
          // Pointing left.
          .itemFromWidget(
            description: "Right (Top)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(500, 0)),
          )
          .itemFromWidget(
            description: "Right (Middle)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(500, 250)),
          )
          .itemFromWidget(
            description: "Right (Bottom)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(500, 500)),
          )
          // Pointing down.
          .itemFromWidget(
            description: "Down (Left)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(150, 500)),
          )
          .itemFromWidget(
            description: "Down (Center)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(250, 500)),
          )
          .itemFromWidget(
            description: "Down (Right)",
            widget: _buildIosPopover(arrowFocalPoint: const Offset(350, 500)),
          )
          .run(tester);
    });
  });
}

Widget _buildIosPopover({
  required Offset arrowFocalPoint,
}) {
  return MaterialApp(
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
                textAlign: TextAlign.center,
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
    debugShowCheckedModeBanner: false,
  );
}
