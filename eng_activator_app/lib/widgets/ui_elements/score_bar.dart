import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/material.dart';

class ScoreBarWidget extends StatelessWidget {
  final double _score;

  const ScoreBarWidget({Key? key, required double score})
      : _score = score,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(AppColors.grey), width: 1),
                    color: Color(AppColors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: _score / 5,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(AppColors.green), width: 1),
                      color: Color(AppColors.green),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Text(_score.toStringAsFixed(2)),
        ],
      ),
    );
  }
}
