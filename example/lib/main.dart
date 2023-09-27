import 'package:example/demos/demo_popover_menu.dart';
import 'package:example/demos/demo_popover_menu_bouncing_ball.dart';
import 'package:example/demos/demo_popover_menu_draggable_ball.dart';
import 'package:example/demos/demo_scrolling_with_toolbar.dart';
import 'package:example/demos/demo_toolbar.dart';
import 'package:example/demos/demo_toolbar_bouncing_ball.dart';
import 'package:example/demos/demo_toolbar_draggable_ball.dart';
import 'package:example/demos/demo_toolbar_wide_draggable_ball.dart';
import 'package:example/demos/inventory_demo.dart';
import 'package:flutter/material.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _MenuItem _selectedMenu = _items.first;

  void _closeDrawer() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF222222),
      body: _selectedMenu.pageBuilder(context),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        primary: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in _items) ...[
                _DrawerButton(
                  title: item.title,
                  onPressed: () => setState(() {
                    _selectedMenu = item;
                    _closeDrawer();
                  }),
                  isSelected: _selectedMenu == item,
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

final _items = [
  _MenuItem(
    title: 'Inventory',
    pageBuilder: (context) => const InventoryDemo(),
  ),
  _MenuItem(
    title: 'Scrolling with iOS Toolbar',
    pageBuilder: (context) => const ScrollingWithToolbarDemo(),
  ),
  _MenuItem(
    title: 'iOS Popover',
    pageBuilder: (context) => const PopoverDemo(),
  ),
  _MenuItem(
    title: 'Popover Menu - Draggable Ball',
    pageBuilder: (context) => const PopoverMenuDraggableBallDemo(),
  ),
  _MenuItem(
    title: 'Popover Menu - Bouncing Ball',
    pageBuilder: (context) => const PopoverMenuBouncingBallDemo(),
  ),
  _MenuItem(
    title: 'iOS Toolbar',
    pageBuilder: (context) => const ToolbarDemo(),
  ),
  _MenuItem(
    title: 'Toolbar - Draggable Ball',
    pageBuilder: (context) => const ToolbarDraggableBallDemo(),
  ),
  _MenuItem(
    title: 'Toolbar (wide) - Draggable Ball',
    pageBuilder: (context) => const WideToolbarDraggableBallDemo(),
  ),
  _MenuItem(
    title: 'Toolbar - Bouncing Ball',
    pageBuilder: (context) => const ToolbarBouncingBallDemo(),
  ),
];

class _MenuItem {
  const _MenuItem({
    required this.title,
    required this.pageBuilder,
  });

  final String title;
  final WidgetBuilder pageBuilder;
}

class _DrawerButton extends StatelessWidget {
  const _DrawerButton({
    Key? key,
    required this.title,
    this.isSelected = false,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) {
              if (isSelected) {
                return const Color(0xFFBBBBBB);
              }

              if (states.contains(MaterialState.hovered)) {
                return Colors.grey.withOpacity(0.1);
              }

              return Colors.transparent;
            }),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => isSelected ? Colors.white : const Color(0xFFBBBBBB)),
            elevation: MaterialStateProperty.resolveWith((states) => 0),
            padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.all(16))),
        onPressed: isSelected ? null : onPressed,
        child: Center(child: Text(title)),
      ),
    );
  }
}
