import 'package:amplify_core/amplify_core.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      title: 'Appinio Video Player Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _videoPlayerController,
      _videoPlayerController2,
      _videoPlayerController3;

  late CustomVideoPlayerController _customVideoPlayerController;
  late CustomVideoPlayerWebController _customVideoPlayerWebController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
  const CustomVideoPlayerSettings(
    showSeekButtons: false,
    enterFullscreenOnStart: true,
    // exitFullscreenButton: IconButton(
    //   icon: const Icon(Icons.exit_to_app),
    //   onPressed: () => safePrint('Pressed')
    // ),
  );

  final CustomVideoPlayerWebSettings _customVideoPlayerWebSettings =
  CustomVideoPlayerWebSettings(
    src: video720,
  );

  @override
  void initState() {

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(video720),
    )..initialize().then((value) => setState(() {}));
    _videoPlayerController2 = VideoPlayerController.networkUrl(Uri.parse(video240));
    _videoPlayerController3 = VideoPlayerController.networkUrl(Uri.parse(video480));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
      additionalVideoSources: {
        "240p": _videoPlayerController2,
        "480p": _videoPlayerController3,
        "720p": _videoPlayerController,
      },
    );

    _customVideoPlayerWebController = CustomVideoPlayerWebController(
      webVideoPlayerSettings: _customVideoPlayerWebSettings,
    );

    super.initState();

    // TODO : 왜 이렇게 해야 전체화면되고 실행되는지 모르겠지만.. 아무튼 된다..ㅎ
    _customVideoPlayerController.setFullscreen(false);
    _customVideoPlayerController.videoPlayerController.play();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(""),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            kIsWeb
                ? Expanded(
              child: CustomVideoPlayerWeb(
                customVideoPlayerWebController:
                _customVideoPlayerWebController,
              ),
            )
                : CustomVideoPlayer(
              customVideoPlayerController: _customVideoPlayerController,
            ),
            // CupertinoButton(
            //   child: const Text("Play Fullscreen"),
            //   onPressed: () {
            //     if (kIsWeb) {
            //       _customVideoPlayerWebController.setFullscreen(true);
            //       _customVideoPlayerWebController.play();
            //     } else {
            //       _customVideoPlayerController.setFullscreen(true);
            //       _customVideoPlayerController.videoPlayerController.play();
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

// String videoUrlLandscape =
//     "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
// String videoUrlPortrait =
//     'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
// String longVideo =
    // "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

String video720 =
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

String video480 =
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

String video240 =
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";