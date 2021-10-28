import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityPictureWidget extends StatefulWidget {
  final String _picUrl;
  final EdgeInsets? _margin;

  ActivityPictureWidget({EdgeInsets? margin, required String picUrl})
      : _picUrl = picUrl,
        _margin = margin;

  @override
  _ActivityPictureWidgetState createState() => _ActivityPictureWidgetState();
}

class _ActivityPictureWidgetState extends State<ActivityPictureWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget._margin,
      decoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          const BoxShadow(
            blurRadius: 2,
            spreadRadius: 0.2,
            color: Colors.black54,
            offset: Offset(0.5, 0.5),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          'assets/random_pics/' + widget._picUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}