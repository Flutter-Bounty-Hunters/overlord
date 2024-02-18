import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    this.focusNode,
    this.padding = EdgeInsets.zero,
    this.background = Colors.transparent,
    this.backgroundOnHover,
    this.backgroundOnPress,
    this.border,
    this.borderOnHover,
    this.borderOnPress,
    this.borderRadius = BorderRadius.zero,
    this.enabled = true,
    this.onPressed,
    required this.child,
  });

  final FocusNode? focusNode;

  final EdgeInsets padding;

  final Color background;

  final Color? backgroundOnHover;

  final Color? backgroundOnPress;

  final BorderSide? border;

  final BorderSide? borderOnHover;

  final BorderSide? borderOnPress;

  final BorderRadius borderRadius;

  final bool enabled;

  final VoidCallback? onPressed;

  final Widget child;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late Color _background;
  BorderSide? _border;

  bool _isHovering = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _background = widget.background;
    _border = widget.border;
  }

  @override
  void didUpdateWidget(Button oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateStyles();
  }

  bool get _isEnabled => widget.enabled && widget.onPressed != null;

  void _onHoverEnter(PointerEnterEvent event) {
    if (!_isEnabled) {
      return;
    }

    setState(() {
      _isHovering = true;
      _updateStyles();
    });
  }

  void _onHoverExit(PointerExitEvent event) {
    setState(() {
      _isHovering = false;
      _updateStyles();
    });
  }

  void _onPressDown(TapDownDetails details) {
    if (!_isEnabled) {
      return;
    }

    setState(() {
      _isPressed = true;
      _updateStyles();
    });
  }

  void _onPressUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
      _updateStyles();
    });

    if (_isEnabled) {
      widget.onPressed!();
    }
  }

  void _onPressCancel() {
    setState(() {
      _isPressed = false;
      _updateStyles();
    });
  }

  void _updateStyles() {
    _background = widget.background;
    _border = widget.border;

    if (_isHovering) {
      _background = widget.backgroundOnHover ?? _background;
      _border = widget.borderOnHover ?? _border;
    }

    if (_isPressed) {
      _background = widget.backgroundOnPress ?? _background;
      _border = widget.borderOnPress ?? _border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _onHoverEnter,
        onExit: _onHoverExit,
        hitTestBehavior: HitTestBehavior.opaque,
        child: GestureDetector(
          onTapDown: _onPressDown,
          onTapUp: _onPressUp,
          onTapCancel: _onPressCancel,
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: _background,
              borderRadius: widget.borderRadius,
              border: _border != null ? Border.fromBorderSide(_border!) : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
