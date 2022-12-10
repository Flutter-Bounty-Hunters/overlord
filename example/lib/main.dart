import 'package:flutter/material.dart';
import 'package:overlord/overlord.dart';

void main() {
  runApp(const OverlordExampleApp());
}

class OverlordExampleApp extends StatelessWidget {
  const OverlordExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlord Example',
      theme: ThemeData.dark(),
      home: const OverlordDemoHomepage(),
    );
  }
}

class OverlordDemoHomepage extends StatefulWidget {
  const OverlordDemoHomepage({
    super.key,
  });

  @override
  State<OverlordDemoHomepage> createState() => _OverlordDemoHomepageState();
}

class _OverlordDemoHomepageState extends State<OverlordDemoHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF222222),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: CupertinoPopoverToolbar(
                globalFocalPoint: Offset.zero,
                children: _toolbarMenuItems,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: CupertinoPopoverMenu(
                globalFocalPoint: Offset.zero,
                padding: const EdgeInsets.all(16),
                child: Text("Popover Menu"),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Drawer();
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
