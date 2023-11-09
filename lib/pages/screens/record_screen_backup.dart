import 'package:book_story/datasource/voice_sentence_data.dart';
import 'package:book_story/utils/speech_to_text_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  State<RecordScreen> createState() { // Avoid using private types in public APIs.
    return _RecordScreenState();
  }
}

class _RecordScreenState extends State<RecordScreen> {
  int recordCount = 0;
  bool isRecorded = false;
  String progressText = "0 / 12";
  String plainText = "";
  String speechText = "";
  VoiceSentenceData voiceSentenceList = VoiceSentenceData();
  SpeechToTextUtils speechToTextUtils = SpeechToTextUtils();

  void recogniseSpeech(SpeechRecognitionResult result){
    setState(() {
      speechText = result.recognizedWords;
    });
  }

  @override
  void initState(){
    plainText = voiceSentenceList.getSentence(0);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await speechToTextUtils.initialize();
    });
  }

  @override
  void dispose() {
    speechToTextUtils.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    void updateProgress() {
      setState(() {
        plainText = voiceSentenceList.getSentence(0);
        speechText = "";
        progressText = "$recordCount / 12";
      });
    }

    return Container(
        color: isLightMode ? BookStoryAppTheme.nearlyWhite : BookStoryAppTheme.nearlyBlack,
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
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
                                  const SizedBox(height: 70),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      progressText,
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
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                                    child: Container(
                                        height: 130,
                                        padding: const EdgeInsets.all(20.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(10.0),
                                          boxShadow: const [
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
                                            plainText,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 24.0),
                                          ),
                                        )

                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  setResultIcon(),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                                    child: Container(
                                      height: 130,
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10.0),
                                        boxShadow: const [
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
                                          speechText,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 24.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.bottomRight,
                                            child: (speechToTextUtils.isListening() == false)&&(speechText.replaceAll(" ", "") == plainText.replaceAll(" ", "")) ?
                                            MaterialButton(
                                                onPressed: () {
                                                  updateProgress();
                                                },
                                                child: const Icon(Icons.arrow_forward_rounded, color: BookStoryAppTheme.nearlyBlue, size: 50)
                                            ) : null
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                            floatingActionButton: InkWell(
                              child: FloatingActionButton.large(
                                onPressed: () async {
                                  // final List<Future<dynamic>> futures = []; // 녹음과 STT 동시 진행

                                  final cacheDir = await getTemporaryDirectory();
                                  String audioFilePath = cacheDir.path + '/audio_recording.wav';
                                  print('AUDIOFILEPATH: $audioFilePath');
                                  // 녹음 시작
                                  // await record.start(const RecordConfig(), path: audioFilePath);
                                  String? text = await speechToTextUtils.startListening(recogniseSpeech);
                                  // await record.stop();
                                  setState(() {
                                    speechText = text ?? "";
                                  });
                                }, // to avoid conflict InkWell:onTap
                                child: speechToTextUtils.isListening() ? const Icon(Icons.stop) : const Icon(Icons.mic),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: SizedBox(
                    width: AppBar().preferredSize.height+10,
                    height: AppBar().preferredSize.height+10,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: BookStoryAppTheme.nearlyBlack,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('녹음 내용이 사라져요!'),
                                content: Text('녹음을 종료하면 현재 녹음 정보가 모두 사라집니다. 정말 종료하실 건가요?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 팝업 닫기
                                      Navigator.of(context).pop(); // 녹음창 닫기
                                    },
                                    child: Text('확인'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 팝업 닫기
                                    },
                                    child: Text('취소'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          const Expanded(
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
                    fontSize: 25,
                    letterSpacing: 0.27,
                    color: BookStoryAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset('assets/images/userImage_default.png'),
          )
        ],
      ),
    );
  }

  Widget setResultIcon() {
    if(speechToTextUtils.isListening()) {
      return const Icon(
          Icons.more_horiz,
          color: BookStoryAppTheme.nearlyBlue,
          size: 50);
    } else {
      if(speechText.replaceAll(" ", "") == plainText.replaceAll(" ", "")) {
        return const Icon(
            Icons.done_outlined,
            color: BookStoryAppTheme.nearlyBlue,
            size: 50
        );
      } else {
        return const Icon(
            Icons.more_horiz,
            color: Colors.grey,
            size: 50
        );
      }
    }
  }
}