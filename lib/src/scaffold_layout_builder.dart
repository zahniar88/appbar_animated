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
  final Color end;

  const ColorBuilder(this.start, this.end);
}

class ScaffoldLayoutBuilder extends StatefulWidget {
  const ScaffoldLayoutBuilder({
    Key? key,
    required this.backgroundColorAppBar,
    required this.textColorAppBar,
    this.duration = const Duration(milliseconds: 100),
    required this.appBarBuilder,
    required this.body,
    this.appBarHeight = 100,
  }) : super(key: key);

  final Duration duration;

  /// Example:
  /// ```
  /// ColorBuilder(Colors.transparent, Colors.white)
  /// ```
  final ColorBuilder backgroundColorAppBar;

  /// Example:
  /// ```
  /// ColorBuilder(Colors.white, Colors.blue)
  /// ```
  final ColorBuilder textColorAppBar;
  final Widget body;
  final AppBarAnimatedBuilder appBarBuilder;
  final double appBarHeight;

  @override
  _ScaffoldLayoutBuilderState createState() => _ScaffoldLayoutBuilderState();
}

class _ScaffoldLayoutBuilderState extends State<ScaffoldLayoutBuilder>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation background, color;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Set background color
    background = ColorTween(
      begin: widget.backgroundColorAppBar.start,
      end: widget.backgroundColorAppBar.end,
    ).animate(animationController);

    // Set text color
    color = ColorTween(
      begin: widget.textColorAppBar.start,
      end: widget.textColorAppBar.end,
    ).animate(animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _scrollNotification,
      child: Stack(
        children: [
          widget.body,
          Container(
            height: widget.appBarHeight,
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
