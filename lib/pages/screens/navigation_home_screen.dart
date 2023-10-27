import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/enums/drawer_index.dart';
import 'package:book_story/pages/custom_drawer/home_drawer_user_controller.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:book_story/pages/popups/book_story_dialog.dart';
import 'package:book_story/pages/popups/record_tips_popup.dart';
import 'package:book_story/pages/screens/favorite_screen.dart';
import 'package:book_story/pages/screens/feedback_screen.dart';
import 'package:book_story/pages/screens/home_screen.dart';
import 'package:book_story/pages/screens/library_screen.dart';
import 'package:book_story/pages/screens/voice_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class NavigationHomeScreen extends StatefulWidget{
  const NavigationHomeScreen({super.key});

  @override
  NavigationHomeScreenState createState() => NavigationHomeScreenState();
}

class NavigationHomeScreenState extends State<NavigationHomeScreen>{
  Widget? screenView;
  DrawerIndex? drawerIndex;
  bool? isLogin;
  final AuthController _authController = AuthControllerImpl();

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState(){
    drawerIndex = DrawerIndex.home;
    screenView = const HomeScreen();
    super.initState();
    // 비동기 작업 수행
    _asyncTask(context);
  }

  checkConnectivity({bool terminate = true}) async {
    safePrint('Check Connectivity...');
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected && isAlertSet == false) {
      setState(() => isAlertSet = true);
      if(terminate == true) FlutterNativeSplash.remove(); // 강제종료할거라면 splash_screen 없애기.
      await showDialogBoxNoInternetConnection(terminate);
    }
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
              safePrint('Get Connectivity...');
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            setState(() => isAlertSet = true);
            await showDialogBoxNoInternetConnection(false);
          }
        },
      );

  showDialogBoxNoInternetConnection(bool terminate) => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('인터넷 연결 없음'),
      content: const Text('인터넷에 연결할 수 없습니다.\n인터넷을 확인해 주세요.'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if(terminate == true) SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              setState(() => isAlertSet = true);
              await showDialogBoxNoInternetConnection(terminate);
            }
          },
          child: terminate==true ? const Text('Exit',style: TextStyle(fontSize: 17)) : const Text('Retry',style: TextStyle(fontSize: 17)),
        ),
      ],
    ),
  );

  showDialogBoxConfigureAmplifyFailed() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('로그인 구성 실패'),
      content: const Text('로그인 구성에 실패했습니다.\n앱을 다시 시작해 주세요.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Exit',style: TextStyle(fontSize: 17)),
        ),
      ],
    ),
  );

  void _asyncTask(BuildContext context) async {
    await checkConnectivity(); // 인터넷 연결확인
    await getConnectivity(); // 인터넷 상태받기
    // 인터넷 확인 후, splash screen 해제
    FlutterNativeSplash.remove();
    // 1. Amplify 구성하기
    String? amplifyResult = await _authController.configureAmplify();
    setState(() {
      HomeDrawer.isLogin = HomeDrawer.isLogin;
      safePrint('[isLogin] : ${HomeDrawer.isLogin}');
    });
    if(amplifyResult != null){
      // 오류 발생 원인 출력
      safePrint('[ERROR _asyncTask()] : $amplifyResult');
      await showDialogBoxConfigureAmplifyFailed(); // 여기서 앱 종료되기 때문에 return 필요없음
    }
    // 2. 유저 세션 확인하기 (세션이 만료되었다면 true, 그 이외는 false)
    bool sessionIsExpired = await _authController.checkUserSessionIsExpired(context);
    // 세션이 만료되었다면, 로그아웃시키고 로그인하도록 팝업 띄우기
    if(sessionIsExpired == true) {
      _authController.onLogout(context);
      setState(() {
        HomeDrawer.isLogin = false;
        HomeDrawer.userID = 'Guest User';
      });
      BookStoryDialog.showDialogBoxSessionExpired(context);
    }
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: HomeDrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width < 411 ? MediaQuery.of(context).size.width * 0.70 : 300, // 전체 화면의 x% 사용, 가로길이 450 넘어가면 고정 300 사용
            onDrawerCall: (DrawerIndex drawerIndexData){
              changeIndex(drawerIndexData);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexData) async {
    if(drawerIndex != drawerIndexData){
      drawerIndex = drawerIndexData;
      switch(drawerIndex){
        case DrawerIndex.home:
          setState(() {
            screenView = const HomeScreen();
          });
          break;
        case DrawerIndex.library:
          setState(() {
            screenView = const LibraryScreen();
          });
          break;
        case DrawerIndex.favorite:
          setState(() {
            screenView = const FavoriteScreen();
          });
          break;
        case DrawerIndex.voice:
          setState(() {
            screenView = const VoiceScreen();
            showDialog(context: context, builder: (BuildContext context){
              return const RecordTipsPopup();
            });
          });
          break;
        case DrawerIndex.feedback:
          setState(() {
            screenView = const FeedbackScreen();
          });
          break;
        case DrawerIndex.rate:
          setState(() {
            // screenView = RateScreen();
          });
          break;
        case DrawerIndex.about:
          setState(() {
            // screenView = AboutScreen();
          });
          break;
        default:
          break;
      }
    }

    // 만약, 세션이 만료되었다면, 사용자에게 알리고 자동 로그아웃 시키기
    bool sessionIsExpired = await _authController.checkUserSessionIsExpired(context);
    if(sessionIsExpired == true){
      _authController.onLogout(context);
      HomeDrawer.isLogin = false;
      HomeDrawer.userID = 'Guest User';
      BookStoryDialog.showDialogBoxSessionExpired(context);
    }
  }
}