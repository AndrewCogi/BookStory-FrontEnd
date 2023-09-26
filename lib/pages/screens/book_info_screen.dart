import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/provider/app_data_provider.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:book_story/utils/helper_functions.dart';
import 'package:book_story/utils/main_app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookInfoScreen extends StatefulWidget {
  const BookInfoScreen(this.book, {super.key});

  final Book book;

  @override
  BookInfoScreenState createState() => BookInfoScreenState();
}

class BookInfoScreenState extends State<BookInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  final AuthController _authController = AuthControllerImpl();
  String userEmail = "";

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    // userEmail을 받아놓기
    userEmail = await _authController.getCurrentUserEmail();

    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Container(
      color: BookStoryAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: CachedNetworkImage(
                    placeholder: null,
                    imageUrl: widget.book.imagePath,
                    errorWidget: (context, url, error) => const Icon(Icons.cancel_outlined),
                  ),
                ),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: BookStoryAppTheme.nearlyWhite,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: BookStoryAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              widget.book.title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: BookStoryAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8, top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  HelperFunctions.formatSecondsToMinutesAndSeconds(widget.book.playTime),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: BookStoryAppTheme.nearlyBlue,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      // '${widget.book.rate}', TODO : 원상복구하기
                                      '0.0',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 22,
                                        letterSpacing: 0.27,
                                        color: BookStoryAppTheme.grey,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: BookStoryAppTheme.nearlyBlue,
                                      size: 24,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    getBookInfoBoxUI(categoryDescriptionsAge[widget.book.categoryAge]!, 'Target Age'),
                                    getBookInfoBoxUI(HelperFunctions.makeBookCategoryToString(widget.book.categoryType, widget.book.categoryType.length), 'Category'),
                                    widget.book.writer == widget.book.drawer ?
                                      getBookInfoBoxUI(widget.book.writer, 'Writer/Drawer') :
                                      getBookInfoBoxUI('${widget.book.writer}, ${widget.book.drawer}', 'Writer/Drawer'),
                                    getBookInfoBoxUI('${widget.book.bookPage}', 'Page'),
                                  ],
                                ),
                              ),

                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.book.description,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16,
                                      letterSpacing: 0.27,
                                      color: BookStoryAppTheme.grey,
                                    ),
                                  ),
                                ),

                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, bottom: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    child: SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: BookStoryAppTheme.nearlyWhite,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0),
                                          ),
                                          border: Border.all(
                                              color: BookStoryAppTheme.grey
                                                  .withOpacity(0.2)),
                                        ),
                                        child: const Icon(
                                          Icons.record_voice_over,
                                          color: BookStoryAppTheme.nearlyBlue,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      safePrint('Your Voice on!');
                                    },
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      child: Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: BookStoryAppTheme.nearlyBlue,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0),
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: BookStoryAppTheme
                                                    .nearlyBlue
                                                    .withOpacity(0.5),
                                                offset: const Offset(1.1, 1.1),
                                                blurRadius: 10.0),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Jumping into Story',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                              color: BookStoryAppTheme
                                                  .nearlyWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                        safePrint('Play Story');
                                      },
                                    ),

                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
              right: 35,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(
                    parent: animationController!, curve: Curves.fastOutSlowIn),
                child: FutureBuilder<bool?>(
                  future: Provider.of<AppDataProvider>(context, listen: false)
                      .getIsBookFavorite(userEmail, widget.book.bookId),
                  builder: (context, AsyncSnapshot<bool?> snapshot) {
                    safePrint('snapshot: $snapshot');
                    // 하트를 누르지 않은 상태
                    if (snapshot.data == false){
                      return Card(
                        color: BookStoryAppTheme.nearlyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 10.0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: (){
                            // TODO : 하트를 누르게 하기
                            safePrint('Favorite!');
                          },
                          child: const SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(
                              child: Icon(
                                Icons.favorite,
                                color: AppTheme.nearlyWhite,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    // 하트를 누른 상태
                    else if(snapshot.data == true){
                      return Card(
                        color: BookStoryAppTheme.nearlyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 10.0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: (){
                            // TODO : 하트 취소하기
                            safePrint('Favorite!');
                          },
                          child: const SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    // UnAuthorized
                    else if(snapshot.data == null){
                      return Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 10.0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: (){
                            // TODO : 로그인 유도하기
                            safePrint('Login first!');
                          },
                          child: const SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.transparent,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    // 셋 다 아닌 상태. 로딩중 등
                    else {
                      return Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 10.0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: (){
                            safePrint('Favorite!');
                          },
                          child: const SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(),
                          ),
                        ),
                      );
                    }
                  },
                )
                // Card(
                //   // color: BookStoryAppTheme.nearlyBlue,
                //   color: Colors.blueGrey,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(50.0)),
                //   elevation: 10.0,
                //   child: InkWell(
                //     borderRadius: BorderRadius.circular(50),
                //     onTap: (){
                //       safePrint('Favorite!');
                //     },
                //     child: const SizedBox(
                //       width: 60,
                //       height: 60,
                //       child: Center(
                //         child: Icon(
                //           Icons.favorite,
                //           color: BookStoryAppTheme.nearlyWhite,
                //           size: 30,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ),
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
        ),
      ),
    );
  }

  Widget getBookInfoBoxUI(String value, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: BookStoryAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: BookStoryAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: BookStoryAppTheme.nearlyBlue,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: BookStoryAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
