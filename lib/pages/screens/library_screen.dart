import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/main.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/pages/list_views/creative_book_list_view.dart';
import 'package:book_story/pages/list_views/today_book_list_view.dart';
import 'package:book_story/pages/screens/book_info_screen.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  static CategoryType categoryType = CategoryType.age4plus;
  const LibraryScreen({super.key});

  @override
  LibraryScreenState createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {

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
                    getTodayBookUI(),
                    getCreativeBookUI(),
                    getCreativeBookUI(),
                    getCreativeBookUI(),
                    getCreativeBookUI(),
                    getCreativeBookUI(),
                    getCreativeBookUI(),
                    getCreativeBookUI(),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
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
          height: 250,
          child: TodayBookListView(
            callBack: (Book c) {
              moveTo(c);
            },
          ),
        ),
      ],
    );
  }

  Widget getCreativeBookUI() {
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
                'Creative Books',
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
                  safePrint('More Info - Creative Books');
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
          height: 200,
          child: CreativeBookListView(
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
