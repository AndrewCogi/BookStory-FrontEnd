import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingPopup extends StatefulWidget {
  const RatingPopup({super.key});

  @override
  RatingPopupState createState() => RatingPopupState();
}

class RatingPopupState extends State<RatingPopup> {
  double _currentRating = 5.0;
  String _ratingText = "Perfect!";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Rate This Book",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RatingBar.builder(
            initialRating: _currentRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _currentRating = rating;
                // 점수에 따라 텍스트 업데이트
                _updateRatingText();
              });
            },
          ),
          const SizedBox(height: 10),
          Text(_ratingText, style: const TextStyle(fontSize: 18)),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text("확인"),
          onPressed: () {
            Navigator.of(context).pop(_currentRating);
          },
        ),
      ],
    );
  }

  // 점수에 따라 텍스트 업데이트 함수
  void _updateRatingText() {
    if (_currentRating <= 1) {
      _ratingText = "Bad";
    } else if (_currentRating <= 2){
      _ratingText = "Poor";
    } else if (_currentRating <= 3){
      _ratingText = "Average";
    } else if (_currentRating <= 4){
      _ratingText = "Good";
    } else {
      _ratingText = "Perfect!";
    }
  }
}