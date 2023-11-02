import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:book_story/pages/popups/book_story_dialog.dart';
import 'package:book_story/pages/screens/login_screen.dart';
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
  final AuthController _authController = AuthControllerImpl();

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
        content: SizedBox(
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
                style: const TextStyle(
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
            child: const Text("취소"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text("확인"),
            onPressed: () async {
              // 만료 정보 받아오기
              bool sessionIsExpired = await _authController.checkUserSessionIsExpired(context);
              // '평가하기' 버튼에 대해서도 해당 처리가 들어가지만 여기에서 한번 더 사용하는 이유는,
              // 평가를 작성하는 도중에 세션이 끝났을 경우, 아래 작성된 세션 만료 처리에서 로그인을 하지 않은 경우,
              // 여기서 로그인해야 평가를 올릴 수 있도록 잡아내기 위함이다.
              if(HomeDrawer.isLogin == false){
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('로그인하세요'),
                      content: const Text('로그인 후 이용 가능해요.'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('로그인'),
                          onPressed: (){
                            Navigator.of(context).pop(); // 대화 상자 닫기
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => const LoginScreen(),
                              ),
                            ).then((value) => setState(() {}));
                          },
                        ),
                        ElevatedButton(
                          child: const Text('닫기'),
                          onPressed: () {
                            Navigator.of(context).pop(); // 대화 상자 닫기
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              // 만약, 세션이 만료되었다면, 사용자에게 알리고 자동 로그아웃 시키기
              else if(sessionIsExpired == true){
                _authController.onLogout(context);
                HomeDrawer.isLogin = false;
                HomeDrawer.userID = 'Guest User';
                BookStoryDialog.showDialogBoxSessionExpired(context);
              }
              else{
                Navigator.of(context).pop(_currentRating);
              }
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