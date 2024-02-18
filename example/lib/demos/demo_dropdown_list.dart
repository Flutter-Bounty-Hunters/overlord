import 'package:example/infrastructure/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlord/overlord.dart';

/// Demo that shows how to use a [PopoverScaffold] to build a button that
/// displays a dropdown list.
class DropdownListDemo extends StatefulWidget {
  const DropdownListDemo({Key? key}) : super(key: key);

  @override
  State<DropdownListDemo> createState() => _DropdownListDemoState();
}

class _DropdownListDemoState extends State<DropdownListDemo> {
  late final PopoverController _menuController;

  final _runConfigurations = [
    RunConfiguration(
      key: GlobalKey(),
      icon: const FlutterLogo(size: 18),
      name: "Super Editor",
    ),
    RunConfiguration(
      key: GlobalKey(),
      icon: const FlutterLogo(size: 18),
      name: "Super Reader",
    ),
    RunConfiguration(
      key: GlobalKey(),
      icon: const FlutterLogo(size: 18),
      name: "Super Text Field",
    ),
    RunConfiguration(
      key: GlobalKey(),
      icon: const FlutterLogo(size: 18),
      name: "Docs",
    ),
  ];

  RunConfiguration? _selectedConfiguration;

  @override
  void initState() {
    super.initState();
    _menuController = PopoverController();
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  void _onEditConfigurationSelected() {
    _menuController.close();
  }

  void _onRunConfigurationSelected(RunConfiguration config) {
    _menuController.close();

    setState(() {
      _selectedConfiguration = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopoverScaffold(
        controller: _menuController,
        buttonBuilder: (BuildContext context) {
          return AndroidStudioRunConfigDropdown(
            child: _RunConfigurationListItem(
              icon: _selectedConfiguration?.icon,
              label: _selectedConfiguration?.name ?? "None",
              isSelected: _selectedConfiguration != null,
            ),
            onPressed: () => _menuController.toggle(),
          );
        },
        popoverGeometry: const PopoverGeometry(
          aligner: MenuPopoverAligner(gap: Offset(0, 2)),
        ),
        popoverBuilder: (BuildContext context) {
          return AndroidStudioRunConfigurationList(
            runConfigurations: _runConfigurations,
            selectedConfiguration: _selectedConfiguration,
            onEditConfigurationsSelected: _onEditConfigurationSelected,
            onRunConfigurationSelected: _onRunConfigurationSelected,
          );
        },
      ),
    );
  }
}

class RunConfiguration {
  const RunConfiguration({
    required this.key,
    this.icon,
    required this.name,
  });

  final GlobalKey key;
  final Widget? icon;
  final String name;
}

class AndroidStudioRunConfigDropdown extends StatelessWidget {
  const AndroidStudioRunConfigDropdown({
    super.key,
    this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Button(
      padding: const EdgeInsets.only(left: 0, top: 2, bottom: 2, right: 2),
      background: const Color(0xFF2F2F2F),
      backgroundOnHover: const Color(0xFF333333),
      backgroundOnPress: const Color(0xFF353535),
      border: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      borderRadius: BorderRadius.circular(4),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          child,
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

class AndroidStudioRunConfigurationList extends StatefulWidget {
  const AndroidStudioRunConfigurationList({
    super.key,
    required this.runConfigurations,
    this.selectedConfiguration,
    required this.onEditConfigurationsSelected,
    required this.onRunConfigurationSelected,
  });

  final List<RunConfiguration> runConfigurations;

  final RunConfiguration? selectedConfiguration;

  final VoidCallback onEditConfigurationsSelected;

  final void Function(RunConfiguration runConfiguration) onRunConfigurationSelected;

  @override
  State<AndroidStudioRunConfigurationList> createState() => _AndroidStudioRunConfigurationListState();
}

class _AndroidStudioRunConfigurationListState extends State<AndroidStudioRunConfigurationList> {
  final _listFocusNode = FocusNode();
  final _editConfigurationsKey = GlobalKey();

  late GlobalKey _activeItemKey;

  @override
  void initState() {
    super.initState();

    _listFocusNode.requestFocus();

    _activeItemKey = _editConfigurationsKey;
  }

  @override
  void dispose() {
    _listFocusNode.dispose();
    super.dispose();
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

    if (event.logicalKey == LogicalKeyboardKey.arrowDown && activeIndex < _listLength - 1) {
      setState(() {
        _activateItemAt(activeIndex + 1);
      });
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (activeIndex == 0) {
        widget.onEditConfigurationsSelected();
      } else {
        widget.onRunConfigurationSelected(widget.runConfigurations[activeIndex - 1]);
      }
    }

    return KeyEventResult.ignored;
  }

  int get _activeIndex => _activeItemKey == _editConfigurationsKey //
      ? 0
      : widget.runConfigurations.indexWhere((element) => element.key == _activeItemKey) + 1;

  int get _listLength => widget.runConfigurations.length + 1;

  void _activateItemAt(int index) {
    if (index == 0) {
      _activeItemKey = _editConfigurationsKey;
      return;
    }

    _activeItemKey = widget.runConfigurations[index - 1].key;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _listFocusNode,
      onKeyEvent: _onKeyEvent,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2F),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AndroidStudioRunConfigurationListItem(
              key: _editConfigurationsKey,
              isActive: _activeItemKey == _editConfigurationsKey,
              onHoverEnter: () {
                setState(() {
                  _activeItemKey = _editConfigurationsKey;
                });
              },
              onPressed: widget.onEditConfigurationsSelected,
              child: const Text(
                "Edit Configurations...",
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Text(
                "Run Configurations",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (final config in widget.runConfigurations)
              AndroidStudioRunConfigurationListItem(
                key: config.key,
                isActive: _activeItemKey == config.key,
                onHoverEnter: () {
                  setState(() {
                    _activeItemKey = config.key;
                  });
                },
                onPressed: () => widget.onRunConfigurationSelected(config),
                child: _RunConfigurationListItem(
                  icon: config.icon,
                  label: config.name,
                  isSelected: widget.selectedConfiguration == config,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AndroidStudioRunConfigurationListItem extends StatelessWidget {
  const AndroidStudioRunConfigurationListItem({
    super.key,
    required this.isActive,
    this.onHoverEnter,
    this.onHoverExit,
    this.onPressed,
    required this.child,
  });

  /// Whether this list item is currently the active item in the list, e.g.,
  /// the item that's focused, or hovered, and should be visually selected.
  final bool isActive;

  final VoidCallback? onHoverEnter;

  final VoidCallback? onHoverExit;

  final VoidCallback? onPressed;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHoverEnter?.call(),
      onExit: (_) => onHoverExit?.call(),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          color: isActive ? Colors.blue : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: child,
        ),
      ),
    );
  }
}

class _RunConfigurationListItem extends StatelessWidget {
  const _RunConfigurationListItem({
    this.icon,
    required this.label,
    this.isSelected = false,
  });

  final Widget? icon;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 4),
        if (icon != null) //
          Stack(
            clipBehavior: Clip.none,
            children: [
              icon!,
              if (isSelected) //
                Positioned.fill(
                  child: Align(
                    alignment: const Alignment(1.1, 1.1),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
