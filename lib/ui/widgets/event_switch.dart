import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/my_colors.dart';


class CustomEventSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomEventSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomEventSwitchState createState() => _CustomEventSwitchState();
}

class _CustomEventSwitchState extends State<CustomEventSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 44.0,
            height: 24.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: _circleAnimation!.value == Alignment.centerLeft
                  ? MyColors.grey_A9B9CC
                  : MyColors.green_016938,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 3.0, bottom: 3.0, right: 3.0, left: 3.0),
              child: Container(
                alignment:
                widget.value ? Alignment.centerRight : Alignment.centerLeft,
                child: widget.value ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 3),
                     ),
                  Container(
                    width: 18.0,
                    height: 18.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),],):Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}