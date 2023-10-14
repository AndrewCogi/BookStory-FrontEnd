import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ChewieVideoPlayer(),
    );

        // floatingactionbutton: floatingactionbutton(
        //   onpressed: () {
        //     duration currentposition = _controller.value.position;
        //     duration targetposition = currentposition + const duration(seconds: 10);
        //     _controller.seekto(targetposition);
        //   },
        //   child: const icon(
        //     icons.arrow_forward,
        //   ),
        // ),
  }
}

class ChewieVideoPlayer extends StatefulWidget {
  @override
  _ChewieVideoPlayerState createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    // VideoPlayerController를 초기화하고 비디오 파일의 경로를 설정합니다.
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'));

    // ChewieController를 초기화하고 VideoPlayerController를 전달합니다.
    chewieController = ChewieController(
      fullScreenByDefault: true,
      autoPlay: true,
      allowedScreenSleep: false,
      allowFullScreen: true,
      // 전체화면 해제 시 세로로 고정
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
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
    chewieController.addListener(() {
      GestureDetector(
        onHorizontalDragStart: (details) {videoPlayerController.pause();},
        behavior: HitTestBehavior.translucent,
        onDoubleTap: () {safePrint("HELLO - onDoubleTap");},
        onTapDown: (_) {
          safePrint("HELLO - onTapDown");
        },
        onTapUp: (details) {
          print('hello');
          if(details.localPosition.direction > 1.0){
            print("left");
          }
          if(details.localPosition.direction < 1.0){
            print("right");
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return
    //   Scaffold(
    //   appBar: AppBar(
    //     title: Text('Chewie Video Player Example'),
    //   ),
    //   body: Chewie(
    //     controller: chewieController,
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: (){
    //       Duration currentPosition = videoPlayerController.value.position;
    //       Duration targetPosition = currentPosition + const Duration(seconds: 10);
    //       videoPlayerController.seekTo(targetPosition);
    //     },
    //     child: const Icon(
    //       Icons.arrow_forward,
    //     )
    //   ),
    // );
    Scaffold(
      body: GestureDetector(
        onHorizontalDragStart: (details) {videoPlayerController.pause();},
        behavior: HitTestBehavior.translucent,
        onDoubleTap: () {safePrint("HELLO - onDoubleTap");},
        onTapDown: (_) {
          safePrint("HELLO - onTapDown");
        },
        onTapUp: (details) {
          print('hello');
          if(details.localPosition.direction > 1.0){
            print("left");
          }
          if(details.localPosition.direction < 1.0){
            print("right");
          }
        },
        child: Chewie(
          controller: chewieController,
        ),
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