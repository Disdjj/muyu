import 'package:flutter/material.dart';

class BubbleWidget extends StatefulWidget {
  final AnimationController controller;

  BubbleWidget({required this.controller, Key? key}) : super(key: key);

  @override
  _BubbleWidgetState createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> {
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _opacityAnimation = Tween<double>(begin: 2.0, end: 0.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          0.0,
          0.7,
          curve: Curves.ease,
        ),
      ),
    );

    _moveAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, -1)).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    widget.controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _moveAnimation,
        child: Text("+1", style: TextStyle(color: Colors.white, fontSize: 100)),
      ),
    );
  }
}
