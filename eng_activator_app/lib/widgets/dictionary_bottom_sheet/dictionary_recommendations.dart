import 'package:flutter/material.dart';

class DictionaryRecommendations extends StatelessWidget {
  final List<String> _recommendations;

  DictionaryRecommendations({required List<String> recommendations})
      : _recommendations = recommendations,
        super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Did you mean?",
              style: TextStyle(fontSize: 16),
            ),
          ),
          ..._recommendations.map((e) => Text(e)).toList(),
        ],
      ),
    );
  }
}