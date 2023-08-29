import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/pages/list_views/category_list_view.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/pages/list_views/popular_book_list_view.dart';
import 'package:book_story/main.dart';
import 'package:book_story/pages/screens/book_info_screen.dart';
import 'package:book_story/provider/app_data_provider.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static CategoryType categoryType = CategoryType.age4plus;
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

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
                // 4세 이상
                getButtonUI(CategoryType.age4plus, HomeScreen.categoryType == CategoryType.age4plus),
                const SizedBox(
                  width: 16,
                ),
                // 6세 이상
                getButtonUI(CategoryType.age6plus, HomeScreen.categoryType == CategoryType.age6plus),
                const SizedBox(
                  width: 16,
                ),
                // 창작
                getButtonUI(
                    CategoryType.creative, HomeScreen.categoryType == CategoryType.creative),
                const SizedBox(
                  width: 16,
                ),
                // 생활
                getButtonUI(
                    CategoryType.living, HomeScreen.categoryType == CategoryType.living),
                const SizedBox(
                  width: 16,
                ),
                // 학습
                getButtonUI(
                    CategoryType.learning, HomeScreen.categoryType == CategoryType.learning),
                const SizedBox(
                  width: 16,
                ),
                // 문화/예술
                getButtonUI(
                    CategoryType.culture, HomeScreen.categoryType == CategoryType.culture),
                const SizedBox(
                  width: 16,
                ),
                // 사회/역사
                getButtonUI(
                    CategoryType.society, HomeScreen.categoryType == CategoryType.society),
                const SizedBox(
                  width: 16,
                ),
                // 자연/과학
                getButtonUI(
                    CategoryType.natural, HomeScreen.categoryType == CategoryType.natural),
              ],
            ),
          )
        ),
        const SizedBox(
          height: 16,
        ),
        CategoryListView(
          callBack: (Book c) {
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
              callBack: (Book c) {
                moveTo(c);
              },
            ),
          )
        ],
      ),
    );
  }

  void moveTo(Book category) {
    safePrint('${category.title} selected.');
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => BookInfoScreen(category),
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    String txt = '';
    if (CategoryType.age4plus == categoryTypeData) {
      txt = '4세 이상';
    } else if (CategoryType.age6plus == categoryTypeData) {
      txt = '6세 이상';
    } else if (CategoryType.creative == categoryTypeData) {
      txt = '창작';
    } else if (CategoryType.living == categoryTypeData) {
      txt = '생활';
    } else if (CategoryType.learning == categoryTypeData) {
      txt = '학습';
    } else if (CategoryType.culture == categoryTypeData || CategoryType.art == categoryTypeData) {
      txt = '문화/예술';
    } else if (CategoryType.society == categoryTypeData || CategoryType.history == categoryTypeData) {
      txt = '사회/역사';
    } else if (CategoryType.natural == categoryTypeData || CategoryType.science == categoryTypeData) {
      txt = '자연/과학';
    }
    return Container(
        width: 110,
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
              // TempDB.setCategory(categoryType);
              Provider.of<AppDataProvider>(context, listen: false)
                  .getBooksByCategory(categoryTypeData)
                  .then((bookList) {
                    safePrint('query result: ${bookList!.map((book) => book.title).toList()}');
                    setState(() {
                      HomeScreen.categoryType = categoryTypeData;
                    });
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
  age4plus, // 4세 이상
  age6plus, // 6세 이상
  age8plus, // 8세 이상
  upto4age, // 4세 까지
  upto6age, // 6세 까지
  creative, // 창작
  living,   // 생활
  learning, // 학습
  culture,  // 문화
  art,      // 예술
  society,  // 사회
  history,  // 역사
  natural,  // 자연
  science,  // 과학
  none,     // unknown
}
