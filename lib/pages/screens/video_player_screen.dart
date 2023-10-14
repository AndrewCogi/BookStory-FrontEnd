// import 'package:amplify_core/amplify_core.dart';
// import 'package:appinio_video_player/appinio_video_player.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class VideoPlayerScreen extends StatefulWidget {
//   const VideoPlayerScreen({Key? key}) : super(key: key);
//
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   bool exitButtonClicked = false;
//   late VideoPlayerController _videoPlayerController,
//       _videoPlayerController2,
//       _videoPlayerController3;
//
//   late CustomVideoPlayerController _customVideoPlayerController;
//   late CustomVideoPlayerWebController _customVideoPlayerWebController;
//
//   CustomVideoPlayerSettings _customVideoPlayerSettings(BuildContext context) {
//     return CustomVideoPlayerSettings(
//       showSeekButtons: false,
//       enterFullscreenOnStart: true,
//       exitFullscreenOnEnd: true,
//       exitFullscreenButton: ElevatedButton(
//         child: const Icon(Icons.exit_to_app),
//         onPressed: () async {
//           if(exitButtonClicked) return;
//           exitButtonClicked = true;
//
//           _customVideoPlayerController.setFullscreen(false);
//           _customVideoPlayerController.videoPlayerController.pause();
//
//           // 라이브러리 오류로 회전이 안되는 경우가 있어, 강제적 회전을 위해 while을 사용함..
//           while(MediaQuery.of(context).orientation != Orientation.portrait){
//             safePrint('--------------------------------');
//             await SystemChrome.setPreferredOrientations([
//               DeviceOrientation.portraitUp,
//               DeviceOrientation.portraitDown,
//             ]).then((_) => safePrint('------------------------------------------------------------------'));
//           }
//
//           Navigator.of(context).pop();
//           exitButtonClicked = false;
//         },
//       ),
//     );
//   }
//
//   // final CustomVideoPlayerSettings _customVideoPlayerSettings =
//   // const CustomVideoPlayerSettings(
//   //   showSeekButtons: false,
//   //   enterFullscreenOnStart: false,
//   // );
//
//   final CustomVideoPlayerWebSettings _customVideoPlayerWebSettings =
//   CustomVideoPlayerWebSettings(
//     src: video720,
//   );
//
//   @override
//   void initState() {
//
//     _videoPlayerController = VideoPlayerController.network(
//       video720,
//     )..initialize().then((value) => setState(() {}));
//     _videoPlayerController2 = VideoPlayerController.network(video240);
//     _videoPlayerController3 = VideoPlayerController.network(video480);
//     _customVideoPlayerController = CustomVideoPlayerController(
//       context: context,
//       videoPlayerController: _videoPlayerController,
//       customVideoPlayerSettings: _customVideoPlayerSettings(context),
//       // customVideoPlayerSettings: _customVideoPlayerSettings,
//       additionalVideoSources: {
//         "240p": _videoPlayerController2,
//         "480p": _videoPlayerController3,
//         "720p": _videoPlayerController,
//       },
//     );
//
//     _customVideoPlayerWebController = CustomVideoPlayerWebController(
//       webVideoPlayerSettings: _customVideoPlayerWebSettings,
//     );
//     super.initState();
//
//     // TODO : 왜 이렇게 해야 전체화면되고 실행되는지 모르겠지만.. 아무튼 된다..ㅎ
//     _customVideoPlayerController.setFullscreen(false);
//     _customVideoPlayerController.videoPlayerController.play();
//   }
//
//   @override
//   void dispose() {
//     _customVideoPlayerController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       backgroundColor: Colors.black,
//       navigationBar: const CupertinoNavigationBar(
//         backgroundColor: Colors.transparent,
//         middle: Text(""),
//       ),
//       child:  SafeArea(
//         child: ListView(
//           children: [
//             kIsWeb
//                 ? Expanded(
//               child: CustomVideoPlayerWeb(
//                 customVideoPlayerWebController:
//                 _customVideoPlayerWebController,
//               ),
//             )
//                 : CustomVideoPlayer(
//               customVideoPlayerController: _customVideoPlayerController,
//             ),
//             // CupertinoButton(
//             //   child: const Text("Play Fullscreen"),
//             //   onPressed: () {
//             //     if (kIsWeb) {
//             //       _customVideoPlayerWebController.setFullscreen(true);
//             //       _customVideoPlayerWebController.play();
//             //     } else {
//             //       _customVideoPlayerController.setFullscreen(true);
//             //       _customVideoPlayerController.videoPlayerController.play();
//             //     }
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // String videoUrlLandscape =
// //     "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
// // String videoUrlPortrait =
// //     'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
// // String longVideo =
// // "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
//
// String video720 =
//     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
//
// String video480 =
//     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
//
// String video240 =
//     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";





import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';


class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

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
    chewieController = ChewieController(
      fullScreenByDefault: true,
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
        title: Text('곰곰아, 괜찮아?'),
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