import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
      constraints: BoxConstraints(minHeight: 100, minWidth: double.infinity, maxHeight: 250),
      decoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Stack(
        children: [
          Center(child: AppSpinner()),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: "${AppConstants.getApiUrlWithPrefix()}/files/randomPics/${widget._picUrl}",
                imageErrorBuilder: (_, _2, _3) => Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: Text("Could not load image")),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
