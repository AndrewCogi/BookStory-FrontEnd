import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:book_story/pages/list_views/favorite_list_view.dart';
import 'package:book_story/pages/list_views/plus_list_view.dart';
import 'package:book_story/pages/popups/book_story_dialog.dart';
import 'package:book_story/pages/screens/book_info_screen.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:flutter/material.dart';

class PlusScreen extends StatefulWidget {
  const PlusScreen({super.key, required this.whichPlus, this.categoryTypes});
  final String whichPlus;
  final List<CategoryType>? categoryTypes;

  @override
  PlusScreenState createState() => PlusScreenState();
}

class PlusScreenState extends State<PlusScreen> {
  final AuthController _authController = AuthControllerImpl();

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    return Container(
      color: isLightMode ? BookStoryAppTheme.nearlyWhite : BookStoryAppTheme.nearlyBlack,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                getAppBarUI(),
                Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: getPlusUI(),
                    )
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                    BorderRadius.circular(AppBar().preferredSize.height),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: BookStoryAppTheme.nearlyBlack,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget getPlusUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: PlusListView(
            whichPlus: widget.whichPlus,
            categoryTypes: widget.categoryTypes,
            callBack: (Book c) {
              moveTo(c);
            },
          ),
        )
      ],
    );
  }

  void moveTo(Book category) async {
    safePrint('${category.title} selected.');
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => BookInfoScreen(category),
      ),
    ).then((_) => setState(() {}));

    // 만약, 세션이 만료되었다면, 사용자에게 알리고 자동 로그아웃 시키기
    bool sessionIsExpired = await _authController.checkUserSessionIsExpired(context);
    if(sessionIsExpired == true){
      _authController.onLogout(context);
      HomeDrawer.isLogin = false;
      HomeDrawer.userID = 'Guest User';
      BookStoryDialog.showDialogBoxSessionExpired(context);
    }
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Want more books?',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: BookStoryAppTheme.grey,
                  ),
                ),
                Text(
                  'More Books',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: 0.27,
                    color: BookStoryAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset('assets/images/userImage_default.png'),
          )
        ],
      ),
    );
  }
}
