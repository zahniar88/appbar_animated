import 'dart:io';

import 'package:flutter/material.dart';

typedef AppBarAnimatedBuilder = Widget Function(
  BuildContext context,
  ColorAnimated colorAnimated,
);

class ColorAnimated {
  final Color background;
  final Color color;

  const ColorAnimated({required this.background, required this.color});
}

class ColorBuilder {
  final Color start;
  final Color? end;

  const ColorBuilder(this.start, [this.end]);
}

class ScaffoldLayoutBuilder extends StatefulWidget {
  const ScaffoldLayoutBuilder({
    Key? key,
    required this.backgroundColorAppBar,
    required this.textColorAppBar,
    this.duration = const Duration(milliseconds: 200),
    required this.appBarBuilder,
    this.appBarHeight,
    this.child,
  }) : super(key: key);

  final Duration duration;

  /// Example:
  /// ```
  /// // * Start Color
  /// // * End Color
  /// ColorBuilder(Colors.transparent, Colors.white)
  /// ```
  ///
  /// if end color is null, then the end color will be the same as the start color
  final ColorBuilder backgroundColorAppBar;

  /// Example:
  /// ```
  /// // * Start Color
  /// // * End Color
  /// ColorBuilder(Colors.white, Colors.blue)
  /// ```
  ///
  /// if end color is null, then the end color will be the same as the start color
  final ColorBuilder textColorAppBar;
  final Widget? child;
  final AppBarAnimatedBuilder appBarBuilder;
  final double? appBarHeight;

  @override
  _ScaffoldLayoutBuilderState createState() => _ScaffoldLayoutBuilderState();
}

class _ScaffoldLayoutBuilderState extends State<ScaffoldLayoutBuilder>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation background, color;
  late double appBarHeight;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Set background color
    background = ColorTween(
      begin: widget.backgroundColorAppBar.start,
      end: widget.backgroundColorAppBar.end ??
          widget.backgroundColorAppBar.start,
    ).animate(animationController);

    // Set text color
    color = ColorTween(
      begin: widget.textColorAppBar.start,
      end: widget.textColorAppBar.end ?? widget.textColorAppBar.start,
    ).animate(animationController);

    if (widget.appBarHeight == null) {
      appBarHeight = Platform.isAndroid ? 90 : 100;
    } else {
      appBarHeight = widget.appBarHeight!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _scrollNotification,
      child: Stack(
        children: [
          if (widget.child != null) widget.child!,
          SizedBox(
            height: appBarHeight,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, _) {
                return _builder(
                  context,
                  ColorAnimated(
                    background: background.value,
                    color: color.value,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _builder(BuildContext context, ColorAnimated colorAnimated) {
    return widget.appBarBuilder(
      context,
      ColorAnimated(
        background: colorAnimated.background,
        color: colorAnimated.color,
      ),
    );
  }

  bool _scrollNotification(ScrollNotification notification) {
    bool scroll = false;
    if (notification.metrics.axis == Axis.vertical) {
      animationController.animateTo(notification.metrics.pixels / 80);
    }

    return scroll;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
