import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/enums/drawer_index.dart';
import 'package:book_story/pages/custom_drawer/drawer_user_controller.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:book_story/pages/popups/record_tips_popup.dart';
import 'package:book_story/pages/screens/feedback_screen.dart';
import 'package:book_story/pages/screens/home_screen.dart';
import 'package:book_story/pages/screens/voice_screen.dart';
import 'package:book_story/utils/helper_functions.dart';
import 'package:book_story/utils/main_app_theme.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState(){
    drawerIndex = DrawerIndex.HOME;
    screenView = const HomeScreen();
    super.initState();
    // 비동기 작업 수행
    _asyncTask();
  }

  void _asyncTask() async {
    // 인터넷 연결 확인
    if(await HelperFunctions.internetConnectionIsAlive(context, true)){
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
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            // TODO : 300보다 작으면 메뉴판이 계속 열리는 문제 발생함..
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
        case DrawerIndex.HOME:
          setState(() {
            screenView = const HomeScreen();
          });
          break;
        case DrawerIndex.LIBRARY:
          setState(() {
            // screenView = LibraryScreen();
          });
          break;
        case DrawerIndex.FAVORITE:
          setState(() {
            // screenView = FavoriteScreen();
          });
          break;
        case DrawerIndex.VOICE:
          setState(() {
            screenView = const VoiceScreen();
            showDialog(context: context, builder: (BuildContext context){
              return const RecordTipsPopup();
            });
          });
          break;
        case DrawerIndex.FEEDBACK:
          setState(() {
            screenView = const FeedbackScreen();
          });
          break;
        case DrawerIndex.RATE:
          setState(() {
            // screenView = RateScreen();
          });
          break;
        case DrawerIndex.ABOUT:
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