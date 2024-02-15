import 'package:example/infrastructure/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlord/overlord.dart';

/// Demo that shows how to use a [PopoverScaffold] to build a button that
/// displays a multi-level dropdown menu.
class DropdownMenuDemo extends StatefulWidget {
  const DropdownMenuDemo({Key? key}) : super(key: key);

  @override
  State<DropdownMenuDemo> createState() => _DropdownMenuDemoState();
}

class _DropdownMenuDemoState extends State<DropdownMenuDemo> {
  final _menuController = MultiLevelMenuController();

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(-0.75, -0.8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            menuController: _menuController,
          ),
          MenuButton(
            isMenuOpen: false,
            onPressed: () {},
            child: const Text('Edit'),
          ),
          MenuButton(
            isMenuOpen: false,
            onPressed: () {},
            child: const Text('View'),
          ),
          MenuButton(
            isMenuOpen: false,
            onPressed: () {},
            child: const Text('Window'),
          ),
          MenuButton(
            isMenuOpen: false,
            onPressed: () {},
            child: const Text('Help'),
          ),
        ],
      ),
    );
  }
}

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.menuController,
  });

  final MultiLevelMenuController menuController;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  late final PopoverController _popoverController;

  @override
  void initState() {
    super.initState();
    _popoverController = PopoverController();
  }

  @override
  void didUpdateWidget(AppButton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
  }

  void _onMenuItemPressed(MenuItem menuItem) {
    _popoverController.close();
  }

  @override
  Widget build(BuildContext context) {
    return PopoverScaffold(
      controller: _popoverController,
      buttonBuilder: (BuildContext context) {
        return ListenableBuilder(
          listenable: _popoverController,
          builder: (context, child) {
            return MenuButton(
              isMenuOpen: _popoverController.shouldShow,
              onPressed: () => _popoverController.toggle(),
              child: const Text('File'),
            );
          },
        );
      },
      popoverGeometry: const PopoverGeometry(
        aligner: MenuPopoverAligner(gap: Offset.zero),
      ),
      popoverBuilder: (BuildContext context) {
        return MenuList(
          menuController: widget.menuController,
          menu: _fileMenu,
          onMenuItemSelected: _onMenuItemPressed,
        );
      },
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.isMenuOpen,
    this.onPressed,
    required this.child,
  });

  final bool isMenuOpen;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Button(
      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 6, right: 12),
      background: isMenuOpen ? const Color(0xFF333333) : Colors.transparent,
      backgroundOnHover: const Color(0xFF333333),
      backgroundOnPress: const Color(0xFF353535),
      borderRadius: BorderRadius.circular(2),
      onPressed: onPressed,
      child: child,
    );
  }
}

class MenuList extends StatefulWidget {
  const MenuList({
    super.key,
    required this.menuController,
    required this.menu,
    required this.onMenuItemSelected,
  });

  final MultiLevelMenuController menuController;
  final MenuGroup menu;

  final void Function(MenuItem menuItem) onMenuItemSelected;

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  final _listFocusNode = FocusNode();

  final _menuItemsToKeys = <String, GlobalKey>{};
  final _keysToMenuItems = <GlobalKey, MenuItem>{};
  final _keysInOrder = <GlobalKey>[];

  GlobalKey? _activeItemKey;

  @override
  void initState() {
    super.initState();

    _listFocusNode.requestFocus();

    _updateGlobalKeyMaps();
  }

  @override
  void didUpdateWidget(MenuList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.menu != oldWidget.menu) {
      _updateGlobalKeyMaps();
    }
  }

  @override
  void dispose() {
    _listFocusNode.dispose();
    super.dispose();
  }

  void _updateGlobalKeyMaps() {
    _menuItemsToKeys.clear();
    _keysToMenuItems.clear();

    for (final group in widget.menu.groupedItems) {
      for (final item in group) {
        final key = GlobalKey(debugLabel: item.id);
        _menuItemsToKeys[item.id] = key;
        _keysToMenuItems[key] = item;
        _keysInOrder.add(key);
      }
    }
  }

  KeyEventResult _onKeyEvent(FocusNode focusNode, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    if (!const [LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.enter]
        .contains(event.logicalKey)) {
      return KeyEventResult.ignored;
    }

    int activeIndex = _activeIndex;

    if (event.logicalKey == LogicalKeyboardKey.arrowUp && activeIndex > 0) {
      setState(() {
        _activateItemAt(activeIndex - 1);
      });
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown && activeIndex < widget.menu.length - 1) {
      setState(() {
        _activateItemAt(activeIndex + 1);
      });
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      widget.onMenuItemSelected(widget.menu.getItemAt(activeIndex));
    }

    return KeyEventResult.ignored;
  }

  int get _activeIndex => _activeItemKey != null ? _keysInOrder.indexOf(_activeItemKey!) : -1;

  void _activateItemAt(int index) {
    _activeItemKey = _menuItemsToKeys[widget.menu.getItemAt(index)]!;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _listFocusNode,
      onKeyEvent: _onKeyEvent,
      child: Container(
        width: 275,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2F),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final group in widget.menu.groupedItems) ...[
                for (final item in group)
                  MenuListItem(
                    key: _menuItemsToKeys[item.id],
                    menuController: widget.menuController,
                    menuItem: item,
                    isActive: _activeItemKey == _menuItemsToKeys[item.id],
                    onHoverEnter: () {
                      setState(() {
                        widget.menuController.show(item.path);
                        _activeItemKey = _menuItemsToKeys[item.id];
                      });
                    },
                    onPressed: () => widget.onMenuItemSelected(item),
                  ),
                if (group != widget.menu.groupedItems.last) //
                  const Divider(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MenuListItem extends StatefulWidget {
  const MenuListItem({
    super.key,
    required this.menuController,
    required this.menuItem,
    required this.isActive,
    this.onHoverEnter,
    this.onHoverExit,
    this.onPressed,
  });

  final MultiLevelMenuController menuController;

  final MenuItem menuItem;

  /// Whether this list item is currently the active item in the list, e.g.,
  /// the item that's focused, or hovered, and should be visually selected.
  final bool isActive;

  final VoidCallback? onHoverEnter;

  final VoidCallback? onHoverExit;

  final VoidCallback? onPressed;

  @override
  State<MenuListItem> createState() => _MenuListItemState();
}

class _MenuListItemState extends State<MenuListItem> {
  late final PopoverController _popoverController;

  @override
  void initState() {
    super.initState();
    _popoverController = PopoverController();

    widget.menuController.addListener(_onMenuChange);
  }

  @override
  void didUpdateWidget(MenuListItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.menuController != oldWidget.menuController) {
      oldWidget.menuController.removeListener(_onMenuChange);
      widget.menuController.addListener(_onMenuChange);
    }
  }

  @override
  void dispose() {
    widget.menuController.removeListener(_onMenuChange);

    _popoverController.dispose();
    super.dispose();
  }

  void _onMenuChange() {
    if (widget.menuItem.subMenu != null &&
        widget.menuController.visiblePath?.containsPath(widget.menuItem.path) == true) {
      _popoverController.open();
    } else {
      _popoverController.close();
    }
  }

  void _onHoverEnter() {
    widget.onHoverEnter?.call();

    // if (widget.menuItem.subMenu != null) {
    //   _popoverController.open();
    // }
  }

  void _onMenuItemPressed(MenuItem menuItem) {
    // _popoverController.close();
  }

  @override
  Widget build(BuildContext context) {
    return PopoverScaffold(
      controller: _popoverController,
      buttonBuilder: (BuildContext context) {
        return ListenableBuilder(
          listenable: _popoverController,
          builder: (context, child) {
            return _buildListItem();
          },
        );
      },
      popoverGeometry: const PopoverGeometry(
        aligner: MenuPopoverAligner(
          contentAnchor: Alignment.topRight,
          popoverAnchor: Alignment.topLeft,
          gap: Offset(-4, 0),
        ),
      ),
      popoverBuilder: (BuildContext context) {
        return MenuList(
          menuController: widget.menuController,
          menu: widget.menuItem.subMenu!,
          onMenuItemSelected: _onMenuItemPressed,
        );
      },
    );
  }

  Widget _buildListItem() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => widget.onHoverExit?.call(),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          color: widget.isActive ? const Color(0xFF444444) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: IconTheme(
            data: IconTheme.of(context).copyWith(size: 18),
            child: Row(
              children: [
                if (widget.menuItem.icon != null) ...[
                  widget.menuItem.icon!,
                  const SizedBox(width: 12),
                ],
                Text(widget.menuItem.label),
                const Spacer(),
                if (widget.menuItem.shortcut != null) //
                  Text(
                    widget.menuItem.shortcut!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (widget.menuItem.subMenu != null) //
                  Icon(Icons.arrow_right, size: 18, color: Colors.white.withOpacity(0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _fileMenu = MenuGroup(groupedItems: [
  [
    MenuItem(
      id: "new",
      path: MenuPath(["file", "new"]),
      icon: Icon(Icons.feed),
      label: "New",
      subMenu: MenuGroup(
        groupedItems: [
          [
            MenuItem(
              id: "document",
              path: MenuPath(["file", "new", "document"]),
              icon: Icon(Icons.feed, color: Colors.blue),
              label: "Document",
              subMenu: MenuGroup(
                groupedItems: [
                  [
                    MenuItem(
                      id: "blog",
                      path: MenuPath(["file", "new", "document", "blog"]),
                      icon: Icon(Icons.article_outlined),
                      label: "Blog",
                    ),
                    MenuItem(
                      id: "news",
                      path: MenuPath(["file", "new", "document", "news"]),
                      icon: Icon(Icons.article_outlined),
                      label: "News",
                    ),
                  ],
                ],
              ),
            ),
            MenuItem(
              id: "from_template_gallery",
              path: MenuPath(["file", "new", "from_template_gallery"]),
              icon: Icon(Icons.browse_gallery_outlined),
              label: "From template gallery",
            ),
          ],
        ],
      ),
    ),
    MenuItem(
      id: "open",
      path: MenuPath(["file", "open"]),
      icon: Icon(Icons.folder_open),
      label: "Open",
      shortcut: "⌘O",
    ),
    MenuItem(
      id: "make_a_copy",
      path: MenuPath(["file", "make_a_copy"]),
      icon: Icon(Icons.copy),
      label: "Make a copy",
    ),
  ],
  [
    MenuItem(
      id: "share",
      path: MenuPath(["file", "share"]),
      icon: Icon(Icons.person_add_alt),
      label: "Share",
      subMenu: MenuGroup(
        groupedItems: [
          [
            MenuItem(
              id: "share_with_others",
              path: MenuPath(["file", "share", "share_with_others"]),
              icon: Icon(Icons.person_add_alt),
              label: "Share with others",
            ),
            MenuItem(
              id: "publish_to_web",
              path: MenuPath(["file", "share", "publish_to_web"]),
              icon: Icon(Icons.public_sharp),
              label: "Publish to web",
            ),
          ],
        ],
      ),
    ),
    MenuItem(
      id: "email",
      path: MenuPath(["email"]),
      icon: Icon(Icons.email_outlined),
      label: "Email",
    ),
    MenuItem(
      id: "download",
      path: MenuPath(["download"]),
      icon: Icon(Icons.download_outlined),
      label: "Download",
    ),
  ],
  [
    MenuItem(
      id: "rename",
      path: MenuPath(["rename"]),
      icon: Icon(Icons.drive_file_rename_outline),
      label: "Rename",
    ),
    MenuItem(
      id: "move",
      path: MenuPath(["move"]),
      icon: Icon(Icons.drive_file_move_outline),
      label: "Move",
    ),
    MenuItem(
      id: "add_shortcut_to_drive",
      path: MenuPath(["add_shortcut_to_drive"]),
      icon: Icon(Icons.add_to_drive),
      label: "Add shortcut to drive",
    ),
    MenuItem(
      id: "move_to_trash",
      path: MenuPath(["move_to_trash"]),
      icon: Icon(Icons.delete),
      label: "Move to trash",
    ),
  ],
  [
    MenuItem(
      id: "version_history",
      path: MenuPath(["version_history"]),
      icon: Icon(Icons.history),
      label: "Version history",
    ),
    MenuItem(
      id: "make_available_offline",
      path: MenuPath(["make_available_offline"]),
      icon: Icon(Icons.offline_pin_outlined),
      label: "Make available offline",
    ),
  ],
  [
    MenuItem(
      id: "details",
      path: MenuPath(["details"]),
      icon: Icon(Icons.info),
      label: "Details",
    ),
    MenuItem(
      id: "language",
      path: MenuPath(["language"]),
      icon: Icon(Icons.language),
      label: "Language",
    ),
    MenuItem(
      id: "page_setup",
      path: MenuPath(["page_setup"]),
      icon: Icon(Icons.contact_page_outlined),
      label: "Page setup",
    ),
    MenuItem(
      id: "print",
      path: MenuPath(["print"]),
      icon: Icon(Icons.print),
      label: "Print",
      shortcut: "⌘P",
    ),
  ],
]);

class MenuGroup {
  const MenuGroup({
    required this.groupedItems,
  });

  final List<List<MenuItem>> groupedItems;

  MenuItem getItemAt(int index) {
    assert(index >= 0);
    assert(index < length);

    int countToGo = index;
    for (final group in groupedItems) {
      if (group.length > countToGo) {
        return group[countToGo];
      }

      countToGo - group.length;
    }

    throw Exception("Couldn't find list item $index in groupedItems: $groupedItems");
  }

  int get length => groupedItems.fold(0, (count, group) => count + group.length);
}

class MenuItem {
  const MenuItem({
    required this.id,
    required this.path,
    this.subMenu,
    this.icon,
    required this.label,
    this.shortcut,
    this.isEnabled = true,
  });

  final String id;
  final MenuPath path;
  final MenuGroup? subMenu;

  final Widget? icon;
  final String label;
  final String? shortcut;
  final bool isEnabled;
}
