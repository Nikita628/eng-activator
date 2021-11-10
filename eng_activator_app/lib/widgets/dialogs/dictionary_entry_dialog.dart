import 'package:eng_activator_app/models/word_entry.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class DictionaryEntryDialog extends StatelessWidget {
  final WordEntry _wordEntry;

  DictionaryEntryDialog({required WordEntry wordEntry}) : _wordEntry = wordEntry;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: GestureDetector(
        child: Chip(
          backgroundColor: const Color(AppColors.green),
          labelPadding: const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 10, right: 10),
          deleteIcon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onDeleted: () {
            Navigator.pop(context);
          },
          label: Text(
            _wordEntry.word.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () => Navigator.pop(context),
      ),
      children: [
        Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _wordEntry.meaning,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  _wordEntry.examples[0],
                  style: const TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.only(left: 10, right: 10),
          constraints: const BoxConstraints(maxHeight: 250, minHeight: 250, minWidth: double.infinity),
          child: Stack(
            children: [
              Center(child: AppSpinner()),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: "${AppConstants.getApiUrlWithPrefix()}/files/wordPics/${_wordEntry.pictureUrl}",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
