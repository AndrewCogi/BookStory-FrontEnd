import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
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

class PlusListView extends StatefulWidget {
  const PlusListView({Key? key, this.callBack, this.categoryTypes, required this.whichPlus}) : super(key: key);
  final Function(Book)? callBack;
  final List<CategoryType>? categoryTypes;
  final String whichPlus;
  @override
  PlusListViewState createState() => PlusListViewState();
}

class PlusListViewState extends State<PlusListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: FutureBuilder<List<Book>?>(
          future: (){
            switch(widget.whichPlus.toLowerCase()){
              case 'new': // TODO : 최신순으로 책 20권 받아오도록 함
                return Provider.of<AppDataProvider>(context, listen: false)
                    .get10BooksByPlayCount();
              case 'popular': // TODO : 재생빈도순으로 책 100권 받아오도록 함
                return Provider.of<AppDataProvider>(context, listen: false)
                    .get10BooksByPlayCount();
              case 'category': // 카테고리별 100권의 책을 받아옵니다.
                return Provider.of<AppDataProvider>(context, listen: false)
                    .getBooksByCategory(widget.categoryTypes!, 100);
              default:
                return null;
            }
          }(),
          builder: (BuildContext context, AsyncSnapshot<List<Book>?> snapshot) {
            if(snapshot.data == null && snapshot.connectionState == ConnectionState.done) return const Center(child: Text('잘못된 인자입니다.'));
            if(snapshot.hasData){
              List<Book> bookList = snapshot.data!;
              if(bookList.isEmpty) {
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index){
                    return const Center(child: Text('책장이 비어있어요.'));
                  }
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: bookList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  int count = bookList.length;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.ease)));
                  animationController!.forward();
                  return CategoryView(
                    book: bookList[index],
                    animation: animation,
                    animationController: animationController,
                    callback: widget.callBack,
                  );
                },
              );
            }
            if(snapshot.hasError){
              return const Center(child: Text('Failed to fetch data'));
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
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: AnimatedBuilder(
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
                  callback?.call(book);
                },
                child: SizedBox(
                  width: 270,
                  child: Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // 그림자 색상
                                    spreadRadius: 1, // 그림자 확산 범위
                                    blurRadius: 1, // 그림자 흐림 정도
                                    offset: const Offset(1, 1), // 그림자의 위치 (가로, 세로)
                                  ),
                                ],
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
                                              book.title,
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
                                                HelperFunction.makeBookInfo(book.categoryAge,book.categoryType,1,book.bookPage),
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
                                                    '${book.playCount}',
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
                                                HelperFunction.formatSecondsToMinutesAndSeconds(book.playTime),
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
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 25, left: 16),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                              child: ClipRRect(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const SizedBox(),
                                    imageUrl: book.imagePath,
                                    errorWidget: (context, url, error) => const Icon(Icons.cancel_outlined),
                                  ),
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
