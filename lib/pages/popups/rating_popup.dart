import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingPopup extends StatefulWidget {
  const RatingPopup({super.key});

  @override
  RatingPopupState createState() => RatingPopupState();
}

class RatingPopupState extends State<RatingPopup> {
  double _currentRating = 5.0;
  String _ratingText = "최고에요!";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AlertDialog(
        title: const Text(
          "책을 평가해 주세요",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20
          ),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width*0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RatingBar.builder(
                initialRating: _currentRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
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
              Text(_ratingText, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 40),
              TextFormField(
                maxLength: 200,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '의견을 남겨주세요.',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: BookStoryAppTheme.nearlyBlue,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Arial',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text("확인"),
            onPressed: () {
              Navigator.of(context).pop(_currentRating);
            },
          ),
          ElevatedButton(
            child: Text("취소"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      )
    );

  }

  // 점수에 따라 텍스트 업데이트 함수
  void _updateRatingText() {
    if (_currentRating <= 1) {
      _ratingText = "나빠요";
    } else if (_currentRating <= 2){
      _ratingText = "별로에요";
    } else if (_currentRating <= 3){
      _ratingText = "보통이에요";
    } else if (_currentRating <= 4){
      _ratingText = "좋아요";
    } else {
      _ratingText = "최고에요!";
    }
  }
}