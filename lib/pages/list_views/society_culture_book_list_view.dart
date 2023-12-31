import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/main.dart';
import 'package:book_story/provider/app_data_provider.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:book_story/utils/constants.dart';
import 'package:book_story/utils/helper_function.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocietyCultureBookListView extends StatefulWidget {
  const SocietyCultureBookListView({Key? key, this.callBack}) : super(key: key);

  final Function(Book)? callBack;
  @override
  SocietyCultureBookListViewState createState() => SocietyCultureBookListViewState();
}

class SocietyCultureBookListViewState extends State<SocietyCultureBookListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose(){
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<List<Book>>(
        future: Provider.of<AppDataProvider>(context, listen: false)
            .getBooksByCategory([CategoryType.society,CategoryType.culture], 10),
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.hasData) {
            List<Book> bookList = snapshot.data!;
            if(bookList.isEmpty) return const Center(child: Text('책장이 비어있어요.'));
            return GridView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 30.0,
                childAspectRatio: 1.0,
              ),
              children: List<Widget>.generate(
                bookList.length,
                    (int index) {
                  final int count = bookList.length;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.ease),
                    ),
                  );
                  animationController?.forward();
                  return CategoryView(
                    callback: widget.callBack,
                    book: bookList[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            );
          }
          if(snapshot.hasError){
            return Center(child: Text('Failed to fetch data. (${snapshot.error})'));
          }
          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  FutureBuilder<bool>(
                    future: Future<bool>.delayed(const Duration(seconds: stillTryingTextSeconds), () => true),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return const Text("Poor internet connection. Still trying..");
                      } else {
                        return const SizedBox(); // 아무 것도 표시하지 않음
                      }
                    },
                  ),
                ],
              )
          );
        },
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key? key,
        required this.book,
        this.animationController,
        this.animation,
        this.callback})
      : super(key: key);

  final void Function(Book)? callback;
  final Book book;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 50 * (1.0 - animation!.value), 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: (){
                  callback?.call(book);
                },
                child: SizedBox(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              width: 170,
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // 그림자 색상
                                    spreadRadius: 0.5, // 그림자 확산 범위
                                    blurRadius: 1, // 그림자 흐림 정도
                                    offset: const Offset(2, 2), // 그림자의 위치 (가로, 세로)
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16, left: 16, right: 16),
                                          child: FittedBox(
                                            child: Text(
                                              book.title,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                letterSpacing: 0.27,
                                                color: BookStoryAppTheme
                                                    .darkerText,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 1,
                                              left: 16,
                                              right: 16,
                                              bottom: 8),
                                          child: FittedBox(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  HelperFunction.makeBookInfo(book.categoryAge,book.categoryType,1,book.bookPage),
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 9,
                                                    letterSpacing: 0.27,
                                                    color: BookStoryAppTheme
                                                        .grey,
                                                  ),
                                                ),
                                                const SizedBox(width: 30),
                                                const Icon(
                                                  Icons.play_circle,
                                                  color:
                                                  BookStoryAppTheme
                                                      .nearlyBlue,
                                                  size: 12,
                                                ),
                                                Text(
                                                  '${book.playCount}',
                                                  textAlign:
                                                  TextAlign.left,
                                                  style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize: 10,
                                                    letterSpacing: 0.27,
                                                    color:
                                                    BookStoryAppTheme
                                                        .grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 48,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 24, right: 16, left: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: BookStoryAppTheme.grey
                                      .withOpacity(0.08),
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 6.0),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                              aspectRatio: 1.28,
                              child: CachedNetworkImage(
                                placeholder: null,
                                imageUrl: book.imagePath,
                                errorWidget: (context, url, error) => const Icon(Icons.cancel_outlined),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
