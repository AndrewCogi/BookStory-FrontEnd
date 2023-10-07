import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/main.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/pages/list_views/fairy_tale_creative_book_list_view.dart';
import 'package:book_story/pages/list_views/life_style_habits_book_list_view.dart';
import 'package:book_story/pages/list_views/masterpiece_classic_book_list_view.dart';
import 'package:book_story/pages/list_views/natural_science_book_list_view.dart';
import 'package:book_story/pages/list_views/society_culture_book_list_view.dart';
import 'package:book_story/pages/list_views/sophistication_learning_book_list_view.dart';
import 'package:book_story/pages/list_views/today_book_list_view.dart';
import 'package:book_story/pages/screens/book_info_screen.dart';
import 'package:book_story/pages/screens/search_result_screen.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  static CategoryType categoryType = CategoryType.age4plus;
  const LibraryScreen({super.key});

  @override
  LibraryScreenState createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {
  final searchController = TextEditingController();

  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
  }
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
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      getTodayBookUI(),                   // 오늘의 책 추천
                      getFairyTaleCreativeBookUI(),       // 동화/창작
                      getSophisticationLearningBookUI(),  // 교양/학습
                      getLifeStyleHabitsBookUI(),         // 생활/습관
                      getSocietyCultureBookUI(),          // 사회/문화
                      getMasterpieceClassicBookUI(),      // 명작/고전
                      getNaturalScienceBookUI(),          // 자연/과학
                      const SizedBox(
                        height: 32,
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

  Widget getTodayBookUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 32,
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
                'Today Books',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                  letterSpacing: 0.27,
                  color: isLightMode ? BookStoryAppTheme.darkText : BookStoryAppTheme.lightText,
                ),
              ),
              InkWell(
                onTap:() {
                  safePrint('More Info - Today Books');
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
          height: 230,
          child: TodayBookListView(
            callBack: (Book c) {
              moveTo(c);
            },
          ),
        ),
      ],
    );
  }

  Widget getFairyTaleCreativeBookUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 32,
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
                '동화/창작 Books',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                  letterSpacing: 0.27,
                  color: isLightMode ? BookStoryAppTheme.darkerText : BookStoryAppTheme.lightText,
                ),
              ),
              InkWell(
                onTap:() {
                  safePrint('More Info - 동화/창작 Books');
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
          height: 170,
          child: FairyTaleCreativeBookListView(
            callBack: (Book c) {
              moveTo(c);
            },
          ),
        )
      ],
    );
  }

  Widget getSophisticationLearningBookUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 32,
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
                '교양/학습 Books',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                  letterSpacing: 0.27,
                  color: isLightMode ? BookStoryAppTheme.darkerText : BookStoryAppTheme.lightText,
                ),
              ),
              InkWell(
                onTap:() {
                  safePrint('More Info - 교양/학습 Books');
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
          height: 170,
          child: SophisticationLearningBookListView(
            callBack: (Book c) {
              moveTo(c);
            },
          ),
        )
      ],
    );
  }

  Widget getLifeStyleHabitsBookUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 32,
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
                '생활/습관 Books',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                  letterSpacing: 0.27,
                  color: isLightMode ? BookStoryAppTheme.darkerText : BookStoryAppTheme.lightText,
                ),
              ),
              InkWell(
                onTap:() {
                  safePrint('More Info - 생활/습관 Books');
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
          height: 170,
          child: LifeStyleHabitsBookListView(
            callBack: (Book c) {
              moveTo(c);
            },
          ),
        )
      ],
    );
  }

  Widget getSocietyCultureBookUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 32,
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
                '사회/문화 Books',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                  letterSpacing: 0.27,
                  color: isLightMode ? BookStoryAppTheme.darkerText : BookStoryAppTheme.lightText,
                ),
              ),
              InkWell(
                onTap:() {
                  safePrint('More Info - 사회/문화 Books');
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
          height: 170,
          child: SocietyCultureBookListView(
            callBack: (Book c) {
              moveTo(c);
            },
          ),
        )
      ],
    );
  }

  Widget getMasterpieceClassicBookUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 32,
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
                '명작/고전 Books',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                  letterSpacing: 0.27,
                  color: isLightMode ? BookStoryAppTheme.darkerText : BookStoryAppTheme.lightText,
                ),
              ),
              InkWell(
                onTap:() {
                  safePrint('More Info - 명작/고전 Books');
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
          height: 170,
          child: MasterpieceClassicBookListView(
            callBack: (Book c) {
              moveTo(c);
            },
          ),
        )
      ],
    );
  }

  Widget getNaturalScienceBookUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 32,
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
                '자연/과학 Books',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                  letterSpacing: 0.27,
                  color: isLightMode ? BookStoryAppTheme.darkerText : BookStoryAppTheme.lightText,
                ),
              ),
              InkWell(
                onTap:() {
                  safePrint('More Info - 자연/과학 Books');
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
          height: 170,
          child: NaturalScienceBookListView(
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
                            labelText: 'Search for book title',
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
                          onEditingComplete: () {
                            String title = searchController.text;
                            safePrint('Searching(LibScreen)...$title');
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => SearchResultScreen(title),
                              ),
                            );
                            searchController.clear();
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        String title = searchController.text;
                        safePrint('Searching(LibScreen)...(icon)...$title');
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => SearchResultScreen(title),
                          ),
                        );
                        searchController.clear();
                      },
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.search,
                          color: HexColor('#B9BABC'),
                        ),
                      ),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 18, right: 18),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Welcome to the',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        letterSpacing: 0.2,
                        color: BookStoryAppTheme.grey,
                      ),
                    ),
                    Text(
                      'Kid\'s Library',
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
        ),
        getSearchBarUI(),
      ],
    );
  }
}
