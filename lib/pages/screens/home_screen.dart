import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/pages/list_views/category_list_view.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/pages/list_views/popular_book_list_view.dart';
import 'package:book_story/main.dart';
import 'package:book_story/pages/list_views/new_book_list_view.dart';
import 'package:book_story/pages/list_views/search_result_list_view.dart';
import 'package:book_story/pages/screens/book_info_screen.dart';
import 'package:book_story/pages/screens/search_result_screen.dart';
import 'package:book_story/provider/app_data_provider.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static CategoryType categoryType = CategoryType.age4plus;
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
                      getSearchBarUI(),
                      getCategoryUI(),
                      getNewBookUI(),
                      getPopularBookUI(),
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

  Widget getCategoryUI() {
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
          child: Text(
            'Category',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 23,
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
                // 동화/창작
                getButtonUI(
                    CategoryType.fairyTale, HomeScreen.categoryType == CategoryType.fairyTale),
                const SizedBox(
                  width: 16,
                ),
                // 교양/학습
                getButtonUI(
                    CategoryType.sophistication, HomeScreen.categoryType == CategoryType.sophistication),
                const SizedBox(
                  width: 16,
                ),
                // 생활/습관
                getButtonUI(
                    CategoryType.lifeStyle, HomeScreen.categoryType == CategoryType.lifeStyle),
                const SizedBox(
                  width: 16,
                ),
                // 사회/문화
                getButtonUI(
                    CategoryType.society, HomeScreen.categoryType == CategoryType.society),
                const SizedBox(
                  width: 16,
                ),
                // 명작/고전
                getButtonUI(
                    CategoryType.masterpiece, HomeScreen.categoryType == CategoryType.masterpiece),
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

  Widget getNewBookUI() {
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
                'New Books',
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
                  safePrint('More Info - New Books');
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
          height: 250,
          child: NewBookListView(
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
                  'Popular Books',
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
    if (CategoryType.age4plus == categoryTypeData) {
      nowCategory = '4세 이상';
    } else if (CategoryType.age6plus == categoryTypeData) {
      nowCategory = '6세 이상';
    } else if (CategoryType.fairyTale == categoryTypeData || CategoryType.creative == categoryTypeData) {
      nowCategory = '동화/창작';
    } else if (CategoryType.sophistication == categoryTypeData || CategoryType.learning == categoryTypeData) {
      nowCategory = '교양/학습';
    } else if (CategoryType.lifeStyle == categoryTypeData || CategoryType.habits == categoryTypeData) {
      nowCategory = '생활/습관';
    } else if (CategoryType.society == categoryTypeData || CategoryType.culture == categoryTypeData) {
      nowCategory = '사회/문화';
    } else if (CategoryType.masterpiece == categoryTypeData || CategoryType.classic == categoryTypeData) {
      nowCategory = '명작/고전';
    } else if (CategoryType.natural == categoryTypeData || CategoryType.science == categoryTypeData) {
      nowCategory = '자연/과학';
    }
    return Container(
        width: 105,
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
                  .getBooksByCategory([categoryTypeData], 5)
                  .then((bookList) {
                    safePrint('[Home - Category] query result: [${bookList.map((book) => book.title).toList().join(' / ')}]');
                    if(HomeScreen.categoryType != categoryTypeData){
                      CategoryListView.scrollToStartChange();
                    } else {
                      CategoryListView.scrollToStartSame();
                    }
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
            // height: MediaQuery.of(context).size.height * 0.09,
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
                          controller: searchController,
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
                            safePrint('Searching(HomeScreen)...$title');
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
                        safePrint('Searching(HomeScreen)...(icon)...$title');
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
