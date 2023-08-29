import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/datasource/dummy_data_source.dart';
import 'package:book_story/datasource/temp_db.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/main.dart';
import 'package:book_story/pages/screens/home_screen.dart';
import 'package:book_story/provider/app_data_provider.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:book_story/utils/constants.dart';
import 'package:book_story/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({Key? key, this.callBack}) : super(key: key);

  final Function(Book)? callBack;
  @override
  CategoryListViewState createState() => CategoryListViewState();
}

class CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final DataSource _dataSource = DummyDataSource();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: SizedBox(
        height: 134,
        width: double.infinity,
        child: FutureBuilder<List<Book>?>(
          future: Provider.of<AppDataProvider>(context, listen: false)
              .getBooksByCategory(HomeScreen.categoryType),
          builder: (BuildContext context, AsyncSnapshot<List<Book>?> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              List<Book> bookList = snapshot.data!;
              safePrint(bookList);
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: getBooksByCategoryItemCount,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  const int count = getBooksByCategoryItemCount > 10
                      ? 10
                      : getBooksByCategoryItemCount;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();
                  return CategoryView(
                    category: bookList[index],
                    animation: animation,
                    animationController: animationController,
                    callback: widget.callBack,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key? key,
      required this.category,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final void Function(Book)? callback;
  final Book category;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: (){
                callback?.call(category);
              },
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 48,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor('#F8FAFB'),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(16.0)),
                            ),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(
                                  width: 60,
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16, right: 25),
                                        child: FittedBox(
                                          child: Text(
                                            category.title,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              letterSpacing: 0.27,
                                              color: BookStoryAppTheme
                                                  .darkerText,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 16, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              HelperFunctions.makeBookInfo(category.categoryAge,category.categoryType,1,category.bookPage),
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: BookStoryAppTheme
                                                    .grey,
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                const Icon(
                                                  Icons.play_circle,
                                                  color:
                                                      BookStoryAppTheme
                                                          .nearlyBlue,
                                                  size: 12,
                                                ),
                                                Text(
                                                  '${category.playCount}',
                                                  textAlign:
                                                  TextAlign.left,
                                                  style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color:
                                                    BookStoryAppTheme
                                                        .grey,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 16, right: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              category.playTime,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                letterSpacing: 0.27,
                                                color: BookStoryAppTheme
                                                    .nearlyBlue,
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: BookStoryAppTheme
                                                    .nearlyBlue,
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            8.0)),
                                              ),
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.all(
                                                        4.0),
                                                child: Icon(
                                                  Icons.add,
                                                  color:
                                                      BookStoryAppTheme
                                                          .nearlyWhite,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 24, left: 16),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.asset(category.imagePath)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
