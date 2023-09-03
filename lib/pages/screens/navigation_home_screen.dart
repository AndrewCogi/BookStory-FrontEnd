import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
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
    drawerIndex = DrawerIndex.home;
    screenView = const HomeScreen();
    super.initState();
    _asyncTask();
  }

  void _asyncTask() async {
    String? result = await _authController.configureAmplify();
    // 오류가 있을 시, 재 로그인 시키기 (ex. refreshToken 만료)
    if(result != null){
      // ignore: use_build_context_synchronously
      HelperFunctions.showLoginExpirationDialog(context);
      setState(() {
        HomeDrawer.isLogin = false;
        HomeDrawer.userEmail = "";
      });
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
            drawerWidth: MediaQuery.of(context).size.width * 0.70,
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
            // screenView = LibraryScreen();
          });
          break;
        case DrawerIndex.favorite:
          setState(() {
            // screenView = FavoriteScreen();
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