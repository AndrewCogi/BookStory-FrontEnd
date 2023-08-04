import 'package:book_story/screens/home_screen.dart';
import 'package:book_story/theme/main_app_theme.dart';
import 'package:book_story/custom_drawer/drawer_user_controller.dart';
import 'package:book_story/custom_drawer/home_drawer.dart';
import 'package:book_story/screens/feedback_screen.dart';
import 'package:flutter/material.dart';

class NavigationHomeScreen extends StatefulWidget{
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen>{
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState(){
    drawerIndex = DrawerIndex.HOME;
    screenView = HomeScreen();
    super.initState();
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
        case DrawerIndex.HOME:
          setState(() {
            screenView = HomeScreen();
          });
          break;
        case DrawerIndex.Library:
          setState(() {
            // screenView = LibraryScreen();
          });
          break;
        case DrawerIndex.Favorite:
          setState(() {
            // screenView = FavoriteScreen();
          });
          break;
        case DrawerIndex.Voice:
          setState(() {
            // screenView = VoiceScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = FeedbackScreen();
          });
          break;
        case DrawerIndex.Rate:
          setState(() {
            // screenView = RateScreen();
          });
          break;
        case DrawerIndex.About:
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