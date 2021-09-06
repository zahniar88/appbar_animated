import 'package:flutter/material.dart';

typedef AppBarBuilder = Widget Function(
  BuildContext context,
  Color backgroundColor,
  Color color,
);

class AppBarColorAnimated extends StatefulWidget {
  const AppBarColorAnimated({
    Key? key,
    required this.backgroundColor,
    required this.color,
    this.duration = const Duration(milliseconds: 100),
    required this.appBarBuilder,
    required this.body,
    this.appBarHeight = 100,
  }) : super(key: key);

  final Duration duration;

  /// Example:
  /// ```
  /// ColorTween(begin: Colors.transparent, end: Colors.white)
  /// ```
  final ColorTween backgroundColor;

  /// Example:
  /// ```
  /// ColorTween(begin: Colors.white, end: Colors.blue)
  /// ```
  final ColorTween color;
  final Widget body;
  final AppBarBuilder appBarBuilder;
  final double appBarHeight;

  @override
  _AppBarColorAnimatedState createState() => _AppBarColorAnimatedState();
}

class _AppBarColorAnimatedState extends State<AppBarColorAnimated>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation bgColor, textColor;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    bgColor = widget.backgroundColor.animate(animationController);
    textColor = widget.color.animate(animationController);
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
                return _builder(context, bgColor.value, textColor.value);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _builder(BuildContext context, Color bgColor, Color color) {
    return widget.appBarBuilder(context, bgColor, color);
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
