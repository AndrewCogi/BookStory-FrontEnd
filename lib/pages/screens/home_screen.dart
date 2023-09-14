import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/pages/list_views/category_list_view.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/pages/list_views/popular_book_list_view.dart';
import 'package:book_story/main.dart';
import 'package:book_story/pages/list_views/recent_book_list_view.dart';
import 'package:book_story/pages/screens/book_info_screen.dart';
import 'package:book_story/provider/app_data_provider.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static CategoryType categoryType = CategoryType.AGE_4_PLUS;
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

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
                  child: Column(
                    children: <Widget>[
                      getSearchBarUI(),
                      getCategoryUI(),
                      getRecentUI(),
                      getPopularBookUI(),
                    ],
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
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Category',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25,
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
                getButtonUI(CategoryType.AGE_4_PLUS, HomeScreen.categoryType == CategoryType.AGE_4_PLUS),
                const SizedBox(
                  width: 16,
                ),
                // 6세 이상
                getButtonUI(CategoryType.AGE_6_PLUS, HomeScreen.categoryType == CategoryType.AGE_6_PLUS),
                const SizedBox(
                  width: 16,
                ),
                // 창작
                getButtonUI(
                    CategoryType.CREATIVE, HomeScreen.categoryType == CategoryType.CREATIVE),
                const SizedBox(
                  width: 16,
                ),
                // 생활
                getButtonUI(
                    CategoryType.LIFE_STYLE, HomeScreen.categoryType == CategoryType.LIFE_STYLE),
                const SizedBox(
                  width: 16,
                ),
                // 학습
                getButtonUI(
                    CategoryType.LEARNING, HomeScreen.categoryType == CategoryType.LEARNING),
                const SizedBox(
                  width: 16,
                ),
                // 문화/예술
                getButtonUI(
                    CategoryType.CULTURE, HomeScreen.categoryType == CategoryType.CULTURE),
                const SizedBox(
                  width: 16,
                ),
                // 사회/역사
                getButtonUI(
                    CategoryType.SOCIETY, HomeScreen.categoryType == CategoryType.SOCIETY),
                const SizedBox(
                  width: 16,
                ),
                // 자연/과학
                getButtonUI(
                    CategoryType.NATURAL, HomeScreen.categoryType == CategoryType.NATURAL),
              ],
            ),
          )
        ),
        const SizedBox(
          height: 10,
        ),
        CategoryListView(
          callBack: (Book c) {
            moveTo(c);
          },
        ),
      ],
    );
  }

  Widget getRecentUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'New Books',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  letterSpacing: 0.27,
                  color: isLightMode ? BookStoryAppTheme.darkText : BookStoryAppTheme.lightText,
                ),
              ),
              InkWell(
                onTap:() {
                  safePrint('More Info - Recent Books');
                },
                child: const Icon(
                  Icons.add,
                  color:
                  Colors.grey,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 270,
          child: RecentBookListView(
            callBack: (Book c) {
              moveTo(c);
            },
          ),
        ),
      ],
    );
  }

  Widget getPopularBookUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Popular Books',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    letterSpacing: 0.27,
                    color: isLightMode ? BookStoryAppTheme.darkerText : BookStoryAppTheme.lightText,
                  ),
                ),
                InkWell(
                  onTap:() {
                    safePrint('More Info - Popular Books');
                  },
                  child: const Icon(
                    Icons.add,
                    color:
                    Colors.grey,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 400,
            child: PopularBookListView(
              callBack: (Book c) {
                moveTo(c);
              },
            ),
          )
        ],
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
    String nowCategory = '';
    if (CategoryType.AGE_4_PLUS == categoryTypeData) {
      nowCategory = '4세 이상';
    } else if (CategoryType.AGE_6_PLUS == categoryTypeData) {
      nowCategory = '6세 이상';
    } else if (CategoryType.CREATIVE == categoryTypeData) {
      nowCategory = '창작';
    } else if (CategoryType.LIFE_STYLE == categoryTypeData) {
      nowCategory = '생활';
    } else if (CategoryType.LEARNING == categoryTypeData) {
      nowCategory = '학습';
    } else if (CategoryType.CULTURE == categoryTypeData || CategoryType.ART == categoryTypeData) {
      nowCategory = '문화/예술';
    } else if (CategoryType.SOCIETY == categoryTypeData || CategoryType.HISTORY == categoryTypeData) {
      nowCategory = '사회/역사';
    } else if (CategoryType.NATURAL == categoryTypeData || CategoryType.SCIENCE == categoryTypeData) {
      nowCategory = '자연/과학';
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
              safePrint('$nowCategory clicked.');
              Provider.of<AppDataProvider>(context, listen: false)
                  .get5BooksByCategory(categoryTypeData)
                  .then((bookList) {
                    safePrint('[Home - Category] query result: [${bookList!.map((book) => book.title).toList().join(' / ')}]');
                    setState(() {
                      HomeScreen.categoryType = categoryTypeData;
                    });
              });
              CategoryListView.scrollToStart();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  nowCategory,
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
