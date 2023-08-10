import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/list_view/category_list_view.dart';
import 'package:book_story/list_view/data/category.dart';
import 'package:book_story/list_view/popular_book_list_view.dart';
import 'package:book_story/main.dart';
import 'package:book_story/screens/book_info_screen.dart';
import 'package:book_story/theme/book_story_app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  CategoryType categoryType = CategoryType.age4plus;

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    // for fixed web height
    double screenHeight;
    const double webScreenHeight = 1000.0;
    try{
      if(Platform.isIOS || Platform.isAndroid){
        screenHeight = MediaQuery.of(context).size.height*1;
      } else{
        screenHeight = webScreenHeight;
      }
    } catch(e){
      screenHeight = webScreenHeight;
    }


    return Container(
      color: isLightMode ? BookStoryAppTheme.nearlyWhite : BookStoryAppTheme.nearlyBlack,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: screenHeight,
                  child: Column(
                    children: <Widget>[
                      getSearchBarUI(),
                      getCategoryUI(),
                      Flexible(
                        child: getPopularBookUI(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoryUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Category',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: isLightMode ? BookStoryAppTheme.darkText : BookStoryAppTheme.lightText,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                getButtonUI(CategoryType.age4plus, categoryType == CategoryType.age4plus, 120),
                const SizedBox(
                  width: 16,
                ),
                getButtonUI(CategoryType.age6plus, categoryType == CategoryType.age6plus, 120),
                const SizedBox(
                  width: 16,
                ),
                getButtonUI(
                    CategoryType.creative, categoryType == CategoryType.creative, 120),
                const SizedBox(
                  width: 16,
                ),
                getButtonUI(
                    CategoryType.learning, categoryType == CategoryType.learning, 120),
                const SizedBox(
                  width: 16,
                ),
                getButtonUI(
                    CategoryType.cultureArt, categoryType == CategoryType.cultureArt, 130),
                const SizedBox(
                  width: 16,
                ),
                getButtonUI(
                    CategoryType.societyHistory, categoryType == CategoryType.societyHistory, 160),
                const SizedBox(
                  width: 16,
                ),
                getButtonUI(
                    CategoryType.naturalScience, categoryType == CategoryType.naturalScience, 160),
              ],
            ),
          )
        ),
        const SizedBox(
          height: 16,
        ),
        CategoryListView(
          callBack: (CategoryBook c) {
            moveTo(c);
          },
        ),
      ],
    );
  }

  Widget getPopularBookUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Popular Books',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: isLightMode ? BookStoryAppTheme.darkerText : BookStoryAppTheme.lightText,
            ),
          ),
          Flexible(
            child: PopularBookListView(
              callBack: (CategoryBook c) {
                moveTo(c);
              },
            ),
          )
        ],
      ),
    );
  }

  void moveTo(CategoryBook category) {
    safePrint('${category.title} selected.');
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => BookInfoScreen(category),
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected, double lengthWidth) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    String txt = '';
    if (CategoryType.age4plus == categoryTypeData) {
      txt = '4+ story';
    } else if (CategoryType.age6plus == categoryTypeData) {
      txt = '6+ story';
    } else if (CategoryType.creative == categoryTypeData) {
      txt = 'creative';
    } else if (CategoryType.learning == categoryTypeData) {
      txt = 'learning';
    } else if (CategoryType.cultureArt == categoryTypeData) {
      txt = 'culture/art';
    } else if (CategoryType.societyHistory == categoryTypeData) {
      txt = 'society/history';
    } else if (CategoryType.naturalScience == categoryTypeData) {
      txt = 'natural/science';
    }
    return Container(
        width: lengthWidth,
        decoration: BoxDecoration(
            color: isSelected
                ? (isLightMode ? BookStoryAppTheme.nearlyBlue : BookStoryAppTheme.grey)
                : (isLightMode ? BookStoryAppTheme.nearlyWhite : BookStoryAppTheme.nearlyBlack),
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: BookStoryAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              safePrint('$txt clicked.');
              setState(() {
                categoryType = categoryTypeData;
                CategoryBook.setCategory(categoryType);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? BookStoryAppTheme.nearlyWhite
                        : BookStoryAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          style: const TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: BookStoryAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Search for book',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: HexColor('#B9BABC'),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                          ),
                          onEditingComplete: () {safePrint('Searching...');},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.search, color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
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
                  'Choose your',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: BookStoryAppTheme.grey,
                  ),
                ),
                Text(
                  'Book Story',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
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

enum CategoryType {
  age4plus,
  age6plus,
  creative,
  living,
  learning,
  cultureArt,
  societyHistory,
  naturalScience
}
