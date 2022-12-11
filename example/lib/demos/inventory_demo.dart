import 'package:flutter/material.dart';
import 'package:overlord/overlord.dart';

class InventoryDemo extends StatefulWidget {
  const InventoryDemo({Key? key}) : super(key: key);

  @override
  State<InventoryDemo> createState() => _InventoryDemoState();
}

class _InventoryDemoState extends State<InventoryDemo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: CupertinoPopoverToolbar(
              globalFocalPoint: Offset.zero,
              children: _toolbarMenuItems,
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: CupertinoPopoverMenu(
              globalFocalPoint: Offset.zero,
              padding: EdgeInsets.all(16),
              child: Text("Popover Menu"),
            ),
          ),
        ),
      ],
    );
  }
}

final _toolbarMenuItems = [
  CupertinoPopoverToolbarMenuItem(
    label: 'Style',
    onPressed: () {
      // ignore: avoid_print
      print("Tapped 'style'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Duplicate',
    onPressed: () {
      // ignore: avoid_print
      print("Tapped 'duplicate'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Cut',
    onPressed: () {
      // ignore: avoid_print
      print("Tapped 'cut'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Copy',
    onPressed: () {
      // ignore: avoid_print
      print("Tapped 'copy'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Paste',
    onPressed: () {
      // ignore: avoid_print
      print("Tapped 'paste'");
    },
  ),
];
