// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:overlord/overlord.dart';

/// Demo which shows the capabilities of the [IosToolbar].
///
/// This demo includes examples of the toolbar pointing up and down,
/// menus with many pages, including an auto-paginated and a manually paginated menu.
///
/// It also includes a draggable example, where the user can drag the toolbar around the screen
/// and the toolbar updates the arrow direction to always point to the focal point.
class ToolbarDemo extends StatefulWidget {
  const ToolbarDemo({Key? key}) : super(key: key);

  @override
  State<ToolbarDemo> createState() => _ToolbarDemoState();
}

class _ToolbarDemoState extends State<ToolbarDemo> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScrollChange);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollChange() {
    setState(() {
      // We rebuild the tree so that each demo rebuilds, and gets an opportunity
      // to locate its new global offset focal point, due to the scroll movement.
      //
      // Rebuilding on every scroll frame is very inefficient and shouldn't be
      // done in general. If you want a menu to follow a moving focal point, consider
      // using the follow_the_leader package to follow a moving widget.
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: _buildDemoGrid(),
      ),
    );
  }

  Widget _buildDemoGrid() {
    final demoRows = <Widget>[];
    for (int i = 0; i < _demoItems.length; i += 2) {
      demoRows.add(
        Row(
          children: [
            Expanded(
              child: _buildDemo(_demoItems[i].builder),
            ),
            Expanded(
              child: (i + 1 < _demoItems.length) //
                  ? _buildDemo(_demoItems[i + 1].builder) //
                  : const SizedBox(),
            ),
          ],
        ),
      );
    }

    return Column(
      children: demoRows,
    );
  }

  Widget _buildDemo(_DemoBuilder demoBuilder) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return demoBuilder(context, constraints.loosen());
        }),
      ),
    );
  }
}

typedef _DemoBuilder = Widget Function(BuildContext, [BoxConstraints boundConstraints]);

final _demoItems = [
  _ToolbarDemoItem(
    label: 'Pointing Up',
    builder: (context, [BoxConstraints? constraints]) {
      Offset focalPoint = const Offset(600, 0);
      if (constraints != null) {
        final size = constraints.biggest;
        focalPoint = Alignment.topCenter.alongSize(size);
      }

      return ToolbarExample(
        demoTitle: "Pointing Up",
        focalPoint: focalPoint,
        constraints: constraints,
        children: _shortListOfToolbarItems,
      );
    },
  ),
  _ToolbarDemoItem(
    label: 'Pointing Down',
    builder: (context, [BoxConstraints? constraints]) {
      Offset focalPoint = const Offset(600, 1000);
      if (constraints != null) {
        final size = constraints.biggest;
        focalPoint = Alignment.bottomCenter.alongSize(size);
      }

      return ToolbarExample(
        demoTitle: "Pointing Down",
        focalPoint: focalPoint,
        constraints: constraints,
        children: _shortListOfToolbarItems,
      );
    },
  ),
  _ToolbarDemoItem(
    label: 'Thin',
    builder: (context, [BoxConstraints? constraints]) {
      Offset focalPoint = const Offset(600, 1000);
      if (constraints != null) {
        final size = constraints.biggest;
        focalPoint = Alignment.bottomCenter.alongSize(size);
      }

      return ToolbarExample(
        demoTitle: "Thin",
        focalPoint: focalPoint,
        constraints: constraints,
        toolbarHeight: 24,
        children: _shortListOfToolbarItems,
      );
    },
  ),
  _ToolbarDemoItem(
    label: 'Thick',
    builder: (context, [BoxConstraints? constraints]) {
      Offset focalPoint = const Offset(600, 1000);
      if (constraints != null) {
        final size = constraints.biggest;
        focalPoint = Alignment.bottomCenter.alongSize(size);
      }

      return ToolbarExample(
        demoTitle: "Thick",
        focalPoint: focalPoint,
        constraints: constraints,
        toolbarHeight: 72,
        children: _shortListOfToolbarItems,
      );
    },
  ),
  _ToolbarDemoItem(
    label: 'Auto Paginated',
    builder: (context, [BoxConstraints? constraints]) {
      Offset focalPoint = const Offset(600, 1000);
      if (constraints != null) {
        final size = constraints.biggest;
        focalPoint = Alignment.bottomCenter.alongSize(size);
      }

      return ToolbarExample(
        demoTitle: "Auto Paginated",
        focalPoint: focalPoint,
        constraints: constraints,
        children: _longListOfToolbarItems,
      );
    },
  ),
  _ToolbarDemoItem(
    label: 'Manually Paginated',
    builder: (context, [BoxConstraints? constraints]) {
      Offset focalPoint = const Offset(600, 1000);
      if (constraints != null) {
        final size = constraints.biggest;
        focalPoint = Alignment.bottomCenter.alongSize(size);
      }

      return ToolbarExample(
        demoTitle: "Manually Paginated",
        focalPoint: focalPoint,
        constraints: constraints,
        pages: _pagedToolbarItems,
      );
    },
  ),
  _ToolbarDemoItem(
    label: 'Draggable',
    builder: (context, [BoxConstraints? constraints]) {
      Offset focalPoint = const Offset(600, 1000);
      if (constraints != null) {
        final size = constraints.biggest;
        focalPoint = Alignment.center.alongSize(size);
      }

      return _DraggableDemo(
        focalPoint: focalPoint,
        children: _shortListOfToolbarItems,
      );
    },
  ),
];

final _shortListOfToolbarItems = [
  CupertinoPopoverToolbarMenuItem(
    label: 'Style',
    onPressed: () {
      print("Pressed 'Style'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Duplicate',
    onPressed: () {
      print("Pressed 'Duplicate'");
    },
  ),
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
];

final _longListOfToolbarItems = [
  CupertinoPopoverToolbarMenuItem(
    label: 'Style',
    onPressed: () {
      print("Pressed 'Style'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Duplicate',
    onPressed: () {
      print("Pressed 'Duplicate'");
    },
  ),
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
  CupertinoPopoverToolbarMenuItem(
    label: 'Delete',
    onPressed: () {
      print("Pressed 'Delete'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Long Thing 1',
    onPressed: () {
      print("Pressed 'Long Thing 1'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Long Thing 2',
    onPressed: () {
      print("Pressed 'Long Thing 2'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Long Thing 3',
    onPressed: () {
      print("Pressed 'Long Thing 3'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Long Thing 4',
    onPressed: () {
      print("Pressed 'Long Thing 4'");
    },
  ),
  CupertinoPopoverToolbarMenuItem(
    label: 'Long Thing 5',
    onPressed: () {
      print("Pressed 'Long Thing 5'");
    },
  ),
];

final _pagedToolbarItems = [
  MenuPage(
    items: [
      CupertinoPopoverToolbarMenuItem(
        label: 'Style',
        onPressed: () {
          print("Pressed 'Style'");
        },
      ),
      CupertinoPopoverToolbarMenuItem(
        label: 'Duplicate',
        onPressed: () {
          print("Pressed 'Duplicate'");
        },
      ),
    ],
  ),
  MenuPage(
    items: [
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
      CupertinoPopoverToolbarMenuItem(
        label: 'Delete',
        onPressed: () {
          print("Pressed 'Delete'");
        },
      ),
    ],
  ),
  MenuPage(
    items: [
      CupertinoPopoverToolbarMenuItem(
        label: 'Page 3 Copy',
        onPressed: () {
          print("Pressed 'Page 3 Copy'");
        },
      ),
      CupertinoPopoverToolbarMenuItem(
        label: 'Page 3 Paste',
        onPressed: () {
          print("Pressed 'Page 3 Paste'");
        },
      ),
      CupertinoPopoverToolbarMenuItem(
        label: 'Page 3 Delete',
        onPressed: () {
          print("Pressed 'Page 3 Delete'");
        },
      ),
    ],
  ),
];

class _ToolbarDemoItem {
  _ToolbarDemoItem({
    required this.label,
    required this.builder,
  });

  final String label;
  final _DemoBuilder builder;
}

/// An example of an [IosToolbar] usage.
///
/// When [constraints] are provided, the toolbar is displayed inside a [ConstrainedBox].
///
/// Use [pages] to manually configure the menu pages.
///
/// Use [children] to let the toolbar compute the pages based on the available width.
class ToolbarExample extends StatefulWidget {
  const ToolbarExample({
    super.key,
    required this.demoTitle,
    required this.focalPoint,
    this.constraints,
    this.pages,
    this.toolbarHeight,
    this.children,
  })  : assert(children != null || pages != null, 'You should provide either children or pages'),
        assert(children == null || pages == null, "You can't provide both children and pages");

  final String demoTitle;
  final BoxConstraints? constraints;
  final List<MenuPage>? pages;
  final Offset focalPoint;
  final double? toolbarHeight;
  final List<Widget>? children;

  @override
  State<ToolbarExample> createState() => _ToolbarExampleState();
}

class _ToolbarExampleState extends State<ToolbarExample> {
  @override
  Widget build(BuildContext context) {
    // Re-calculate focal point on every frame, because the toolbar expects a
    // global value, and these demos can scroll up and down, so it changes.
    Offset globalFocalPoint = widget.focalPoint;
    final myBox = context.findRenderObject() as RenderBox?;
    if (myBox != null) {
      globalFocalPoint = myBox.localToGlobal(Offset.zero) + widget.focalPoint;
    } else {
      // Schedule another frame so that we start with the correct global
      // focal point.
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    }

    final toolbar = widget.children != null
        ? CupertinoPopoverToolbar(
            focalPoint: StationaryMenuFocalPoint(globalFocalPoint),
            height: widget.toolbarHeight,
            children: widget.children!,
          )
        : CupertinoPopoverToolbar.paginated(
            focalPoint: StationaryMenuFocalPoint(globalFocalPoint),
            height: widget.toolbarHeight,
            pages: widget.pages,
          );

    final constrainedToolbar = widget.constraints != null
        ? ConstrainedBox(
            constraints: widget.constraints!,
            child: toolbar,
          )
        : toolbar;

    return Stack(
      children: [
        Align(
          alignment: const Alignment(0.0, 0.9),
          child: Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IntrinsicWidth(
              child: Center(
                child: Text(
                  widget.demoTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: constrainedToolbar,
        ),
      ],
    );
  }
}

class _DraggableDemo extends StatefulWidget {
  const _DraggableDemo({
    super.key,
    required this.focalPoint,
    required this.children,
  });

  final Offset focalPoint;
  final List<Widget> children;

  @override
  State<_DraggableDemo> createState() => _DraggableDemoState();
}

class _DraggableDemoState extends State<_DraggableDemo> {
  Offset _offset = const Offset(50, 50);

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Re-calculate focal point on every frame, because the toolbar expects a
    // global value, and these demos can scroll up and down, so it changes.
    Offset globalFocalPoint = widget.focalPoint;
    final myBox = context.findRenderObject() as RenderBox?;
    if (myBox != null) {
      globalFocalPoint = myBox.localToGlobal(Offset.zero) + widget.focalPoint;
    } else {
      // Schedule another frame so that we start with the correct global
      // focal point.
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    }

    return Stack(
      children: [
        Positioned(
          left: widget.focalPoint.dx,
          top: widget.focalPoint.dy,
          child: Container(
            color: Colors.red,
            height: 10,
            width: 10,
          ),
        ),
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: GestureDetector(
            onPanUpdate: _onPanUpdate,
            child: CupertinoPopoverToolbar(
              focalPoint: StationaryMenuFocalPoint(globalFocalPoint),
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}
