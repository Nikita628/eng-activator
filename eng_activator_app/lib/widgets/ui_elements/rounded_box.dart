import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {
  final Widget? _child;
  final EdgeInsets? _margin;
  final Color? _bgColor;
  final EdgeInsets? _padding;

  RoundedBox({Widget? child, EdgeInsets? margin, Color? bgColor, EdgeInsets? padding = const EdgeInsets.all(10)})
      : _child = child,
        _margin = margin,
        _padding = padding,
        _bgColor = bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          const BoxShadow(
            blurRadius: 2,
            spreadRadius: 0.2,
            color: Colors.black54,
            offset: Offset(0.5, 0.5),
          )
        ],
        color: _bgColor,
      ),
      width: double.infinity,
      padding: _padding,
      margin: _margin,
      child: _child,
    );
  }
}
