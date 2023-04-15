import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sada/model/color_model.dart';

class BeautifulCircularProgressIndicator extends StatefulWidget {
  const BeautifulCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  _BeautifulCircularProgressIndicatorState createState() => _BeautifulCircularProgressIndicatorState();
}

class _BeautifulCircularProgressIndicatorState extends State<BeautifulCircularProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: ColorsModel.ColorTherdLite,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value * 2 * 3.14,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  valueColor: AlwaysStoppedAnimation<Color>(ColorsModel.ColorsMineLite),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
showUpdateProgress(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) {
        return  BeautifulCircularProgressIndicator();
      }
  );
}