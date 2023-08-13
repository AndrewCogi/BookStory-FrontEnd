import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:book_story/screens/home_screen.dart';
import 'package:book_story/popup/record_tips_popup.dart';
import 'package:book_story/screens/voice_screen.dart';
import 'package:book_story/theme/main_app_theme.dart';
import 'package:book_story/custom_drawer/drawer_user_controller.dart';
import 'package:book_story/custom_drawer/home_drawer.dart';
import 'package:book_story/screens/feedback_screen.dart';
import 'package:book_story/utils/auth_service.dart';
import 'package:flutter/material.dart';
import '../amplifyconfiguration.dart';

class NavigationHomeScreen extends StatefulWidget{
  const NavigationHomeScreen({super.key});

  @override
  NavigationHomeScreenState createState() => NavigationHomeScreenState();
}

class NavigationHomeScreenState extends State<NavigationHomeScreen>{
  Widget? screenView;
  DrawerIndex? drawerIndex;
  bool? isLogin;

  @override
  void initState(){
    drawerIndex = DrawerIndex.home;
    screenView = const HomeScreen();
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    bool configured = false;
    final auth = AmplifyAuthCognito();
    final analytics = AmplifyAnalyticsPinpoint();

    try{
      Amplify.addPlugins([auth, analytics]);
      await Amplify.configure(amplifyconfig);
      configured = true;
    } catch(e) {
      safePrint(e);
    }

    if(configured){
      safePrint('Successfully configured Amplify!');
      safePrint('Check auth state...');
      HomeDrawer.isLogin = await checkAuthState();
      safePrint("HomeDrawer.isLogin : ${HomeDrawer.isLogin}");
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