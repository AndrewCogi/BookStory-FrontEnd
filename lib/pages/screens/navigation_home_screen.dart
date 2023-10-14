import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/enums/drawer_index.dart';
import 'package:book_story/pages/custom_drawer/drawer_user_controller.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:book_story/pages/popups/record_tips_popup.dart';
import 'package:book_story/pages/screens/favorite_screen.dart';
import 'package:book_story/pages/screens/feedback_screen.dart';
import 'package:book_story/pages/screens/home_screen.dart';
import 'package:book_story/pages/screens/library_screen.dart';
import 'package:book_story/pages/screens/voice_screen.dart';
import 'package:book_story/utils/main_app_theme.dart';
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
    _asyncTask();
  }

  checkConnectivity({bool terminate = true}) async {
    safePrint('Check Connectivity...');
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected && isAlertSet == false) {
      showDialogBox(terminate);
      setState(() => isAlertSet = true);
      if(terminate == true) FlutterNativeSplash.remove(); // 강제종료할거라면 splash_screen 없애기.
    }
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
              safePrint('Get Connectivity...');
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox(false);
            setState(() => isAlertSet = true);
          }
        },
      );

  showDialogBox(bool terminate) => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('No Internet Connection'),
      content: const Text('Please check your internet connectivity'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if(terminate == true) SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox(terminate);
              setState(() => isAlertSet = true);
            }
          },
          child: terminate==true ? const Text('Exit',style: TextStyle(fontSize: 17)) : const Text('Retry',style: TextStyle(fontSize: 17)),
        ),
      ],
    ),
  );

  void _asyncTask() async {
    await checkConnectivity(); // 인터넷 연결확인
    await getConnectivity(); // 인터넷 상태받기
    // 인터넷 확인 후, splash screen 해제
    FlutterNativeSplash.remove();
    // Amplify 구성하기
    String? result = await _authController.configureAmplify();
    setState(() {
      HomeDrawer.isLogin = HomeDrawer.isLogin;
      safePrint('[isLogin] : ${HomeDrawer.isLogin}');
    });
    if(result != null){
      // 오류 발생 원인 출력
      safePrint('[ERROR _asyncTask()] : $result');
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
          body: DrawerUserController(
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

  void changeIndex(DrawerIndex drawerIndexData){
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
  }
}