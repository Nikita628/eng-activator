import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Widget? _child;
  final Function? _onPressed;
  final EdgeInsets? _margin;
  final Color? _bgColor;
  final EdgeInsets? _padding;
  final bool? _disabled;

  RoundedButton({
    Widget? child,
    EdgeInsets? margin,
    Function? onPressed,
    Color? bgColor,
    bool? disabled,
    EdgeInsets? padding = const EdgeInsets.only(top: 5, bottom: 5, left: 30, right: 30),
  })  : _child = child,
        _margin = margin,
        _bgColor = bgColor,
        _padding = padding,
        _disabled = disabled,
        _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _margin,
      child: ElevatedButton(
        onPressed: _disabled == true
            ? null
            : () {
                if (_onPressed != null) {
                  (_onPressed as Function)();
                }
              },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: _bgColor,
          padding: _padding,
        ),
        child: _child,
      ),
    );
  }
}
