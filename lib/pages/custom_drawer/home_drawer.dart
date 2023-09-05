import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/models/drawer_menu_model.dart';
import 'package:book_story/pages/screens/login_screen.dart';
import 'package:book_story/utils/main_app_theme.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key? key,
        this.screenIndex,
        this.iconAnimationController,
        this.callBackIndex})
      : super(key: key);

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;
  static bool? isLogin;

  @override
  HomeDrawerState createState() => HomeDrawerState();
}

class HomeDrawerState extends State<HomeDrawer> {
  final AuthController _authController = AuthControllerImpl();
  List<DrawerMenu>? drawerList;

  @override
  void initState() {
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerMenu>[
      DrawerMenu(
        index: DrawerIndex.home,
        labelName: 'Home',
        icon: const Icon(Icons.home),
      ),
      DrawerMenu(
        index: DrawerIndex.library,
        labelName: 'Library',
        isAssetsImage: true,
        imageName: 'assets/icons/libraryIcon.png',
      ),
      DrawerMenu(
        index: DrawerIndex.favorite,
        labelName: 'My Favorite',
        icon: const Icon(Icons.favorite_border),
      ),
      DrawerMenu(
        index: DrawerIndex.voice,
        labelName: 'Voice',
        icon: const Icon(Icons.record_voice_over_outlined),
      ),
      DrawerMenu(
        index: DrawerIndex.feedback,
        labelName: 'FeedBack',
        icon: const Icon(Icons.help),
      ),
      DrawerMenu(
        index: DrawerIndex.rate,
        labelName: 'Rate this app',
        icon: const Icon(Icons.share),
      ),
      DrawerMenu(
        index: DrawerIndex.about,
        labelName: 'About Us',
        icon: const Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(1.0 -
                            (widget.iconAnimationController!.value) * 0.5),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                              begin: 0.0, end: 24.0)
                              .animate(CurvedAnimation(
                              parent: widget.iconAnimationController!,
                              curve: Curves.fastOutSlowIn))
                              .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(60.0)),
                              child: Image.asset('assets/images/userImage_default.png'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 13),
                    child: Text(
                      'DalMuDee',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isLightMode ? AppTheme.grey : AppTheme.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(1.0),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(1.0),
          ),
          Column(
            children: <Widget>[
              makeSignButton(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget makeSignButton() {
    if(HomeDrawer.isLogin == false) {
      return ListTile(
        title: const Text(
          'Sign in / Sign up',
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.darkText,
          ),
          textAlign: TextAlign.left,
        ),
        trailing: const Icon(
          Icons.power_settings_new,
          color: Colors.green,
          // color: Colors.red,
        ),
        onTap: () {
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const LoginScreen(),
            ),
          );
        },
      );
    }
    else if(HomeDrawer.isLogin == true){
      return ListTile(
        title: const Text(
          'Sign out',
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.darkText,
          ),
          textAlign: TextAlign.left,
        ),
        trailing: const Icon(
          Icons.power_settings_new,
          color: Colors.red,
        ),
        onTap: () {
          _authController.onLogout();
          setState(() {
            HomeDrawer.isLogin = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logout Complete')));
        },
      );
    }
    else {
      return ListTile(
        title: const Text(
          'Check Authentication...',
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.darkText,
          ),
          textAlign: TextAlign.left,
        ),
        trailing: const Icon(
          Icons.power_settings_new,
          color: Colors.yellow,
          // color: Colors.red,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wait a second Plz..')));
        },
      );
    }
  }

  Widget inkwell(DrawerMenu listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () async {
          safePrint('[User Token]: ${await _authController.getCurrentUserToken()}'); // TODO : 테스트용
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    decoration: BoxDecoration(
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset(listData.imageName,
                        color: widget.screenIndex == listData.index
                            ? Colors.blue
                            : AppTheme.nearlyBlack),
                  )
                      : Icon(listData.icon?.icon,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.black
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
              animation: widget.iconAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      (MediaQuery.of(context).size.width * 0.75 - 64) *
                          (1.0 -
                              widget.iconAnimationController!.value -
                              1.0),
                      0.0,
                      0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width * 0.75 - 64,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(28),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

enum DrawerIndex {
  home,
  library,
  favorite,
  voice,
  feedback,
  rate,
  about,
  login,
}
