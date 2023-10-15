import 'package:book_story/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';


class VideoPlayerScreen extends StatefulWidget {
  String bookTitle;
  VideoPlayerScreen(this.bookTitle, {super.key});

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'));

    // ChewieController를 초기화하고 VideoPlayerController를 전달합니다.
    chewieController = ChewieController( // TODO : autoPlay 안쓰고 자동재생 방법 찾아보기. autoPlay랑 fullScreenByDefault를 같이 쓰니까 전체화면 해제를 두번 눌러야 하는 문제가 발생함..
      fullScreenByDefault: true, // TODO : 비디오 플레이어를 빠져나왔을 때, statusBar의 아이콘이 안돌아옴.. 계속 흰색으로 되어있음. 해결하기
      autoPlay: true,
      showControlsOnInitialize: true,
      allowedScreenSleep: false,
      allowFullScreen: true,
      looping: true,
      // 전체화면 해제 시 세로로 고정
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
      videoPlayerController: videoPlayerController,
      aspectRatio: 16/9,
      autoInitialize: true,
      showControls: true,
    );
    chewieController.addListener(() {
      if (chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.bookTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: Chewie(
        controller: chewieController,
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}