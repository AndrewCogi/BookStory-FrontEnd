import 'dart:io';

import 'package:book_story/theme/book_story_app_theme.dart';
import 'package:flutter/material.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({Key? key}) : super(key: key);

  @override
  _VoiceScreenState createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  double _progressValue = 0.0;

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    // for fixed web height
    var screenHeight;
    final webScreenHeight = 1000;
    try{
      if(Platform.isIOS || Platform.isAndroid){
        screenHeight = MediaQuery.of(context).size.height*1;
      } else{
        screenHeight = webScreenHeight;
      }
    } catch(e){
      screenHeight = webScreenHeight;
    }

    void _updateProgress() {
      setState(() {
        _progressValue += 0.01;
        if (_progressValue >= 1.0) {
          _progressValue = 0.0;
        }
      });
    }

    return Container(
      color: isLightMode ? BookStoryAppTheme.nearlyWhite : BookStoryAppTheme.nearlyBlack,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              getAppBarUI(),
              Expanded(
                child: Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                              child: LinearProgressIndicator(
                                value: _progressValue,
                              ),
                            ),
                            // ElevatedButton( // TODO: 이 버튼 누르면 progressbar가 1%씩 올라감
                            //   child: Text('Processing...'),
                            //   onPressed: null,
                            //   // onPressed: _updateProgress,
                            // ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '1 / 100',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 34.0,
                              fontWeight: FontWeight.bold,
                              color: isLightMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),

                        ),
                        SizedBox(height: 40),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                          child: Container(
                            height: 150,
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26, // Add a shadow effect
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.center,
                                child: Text(
                                  '동해물과 백두산이 마르고 우리나라 길이 보전하세',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24.0),
                                ),
                            )

                          ),
                        ),
                        SizedBox(height: 25),
                        Icon( // TODO : 위 아래 텍스트가 같다면 체크표시하고 다음 단어로 넘어가기. 다르다면 계속 ... 나타내기
                          // Icons.done_outlined,
                          Icons.more_horiz,
                          color: BookStoryAppTheme.nearlyBlue,
                          size: 50,
                        ),
                        SizedBox(height: 25),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                          child: Container(
                            height: 150,
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26, // Add a shadow effect
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '동해물과 백두산이 마르하세',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24.0),
                              ),
                            )
                          ),
                        ),

                      ],
                    ),

                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: InkWell(
                    onTap: test(),
                    child: FloatingActionButton.large(
                      onPressed: () {}, // to avoid conflict InkWell:onTap
                      child: Icon(false ? Icons.stop : Icons.mic),
                    ),
                  ),
                ),

                // Container(
                //   height: screenHeight,
                //   child: Column(
                //     children: <Widget>[
                //
                //     ],
                //   ),
                // ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Book Story',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: BookStoryAppTheme.grey,
                  ),
                ),
                Text(
                  'Record Your Voice',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: BookStoryAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            child: Image.asset('assets/images/userImage_default.png'),
          )
        ],
      ),
    );
  }

  test() {}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Linear Progress Indicator Example'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           LinearProgressIndicator(
  //             value: _progressValue,
  //           ),
  //           SizedBox(height: 20),
  //           ElevatedButton(
  //             child: Text('Update Progress'),
  //             onPressed: _updateProgress,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}