import 'package:flutter/material.dart';

class BubblingFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double scaleStart;
  final double scaleEnd;
  final Duration duration;
  final String? tooltip;

  const BubblingFAB({
    Key? key,
    required this.onPressed,
    this.icon = Icons.add,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    this.scaleStart = 1.0,
    this.scaleEnd = 1.2,
    this.tooltip,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _BubblingFABState createState() => _BubblingFABState();
}

class _BubblingFABState extends State<BubblingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation =
        Tween<double>(begin: widget.scaleStart, end: widget.scaleEnd).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Tooltip(
          message: widget.tooltip ?? 'No tooltip',
          child: Transform.scale(
            scale: _animation.value,
            child: FloatingActionButton(
              onPressed: widget.onPressed,
              backgroundColor: widget.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
              child: Icon(widget.icon, color: widget.iconColor),
            ),
          ),
        );
      },
    );
  }
}
