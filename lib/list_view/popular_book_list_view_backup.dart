import 'package:book_story/list_view/data/category.dart';
import 'package:book_story/main.dart';
import 'package:book_story/theme/book_story_app_theme.dart';
import 'package:flutter/material.dart';

class PopularBookListView extends StatefulWidget {
  const PopularBookListView({Key? key, this.callBack}) : super(key: key);

  final Function()? callBack;
  @override
  _PopularBookListViewState createState() => _PopularBookListViewState();
}

class _PopularBookListViewState extends State<PopularBookListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return GridView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List<Widget>.generate(
                CategoryBook.popularBookList.length,
                (int index) {
                  final int count = CategoryBook.popularBookList.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController?.forward();
                  return CategoryView(
                    callback: widget.callBack,
                    category: CategoryBook.popularBookList[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 1.0,
              ),
            );
          }
        },
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key? key,
      this.category,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback? callback;
  final CategoryBook? category;
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
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: SizedBox(
                height: 280,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      height: 206,
                      decoration: BoxDecoration(
                        color: HexColor('#F8FAFB'),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(16.0)),
                        // border: new Border.all(
                        //     color: BookStoryAppTheme.notWhite),
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 24, right: 16, left: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: BookStoryAppTheme.grey
                                      .withOpacity(0.2),
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 6.0),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                                aspectRatio: 1.28,
                                child: Image.asset(category!.imagePath)),
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   child: Column(
                    //     children: <Widget>[
                    //       Expanded(
                    //         child: Container(
                    //           child: Column(
                    //             children: <Widget>[
                    //               Expanded(
                    //                 child: Container(
                    //                   child: Column(
                    //                     children: <Widget>[
                    //                       Padding(
                    //                         padding: const EdgeInsets.only(
                    //                              left: 16, right: 16),
                    //                         child: Text(
                    //                           category!.title,
                    //                           textAlign: TextAlign.left,
                    //                           style: TextStyle(
                    //                             fontWeight: FontWeight.w600,
                    //                             fontSize: 16,
                    //                             letterSpacing: 0.27,
                    //                             color: BookStoryAppTheme
                    //                                 .darkerText,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       Padding(
                    //                         padding: const EdgeInsets.only(
                    //                             top: 40, //TODO BottomOverflow 해결하기
                    //                             left: 16,
                    //                             right: 16,
                    //                             bottom: 8),
                    //                         child: Row(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment
                    //                                   .spaceBetween,
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.center,
                    //                           children: <Widget>[
                    //                             Text(
                    //                               '${category!.description}',
                    //                               textAlign: TextAlign.left,
                    //                               style: TextStyle(
                    //                                 fontWeight: FontWeight.w200,
                    //                                 fontSize: 12,
                    //                                 letterSpacing: 0.27,
                    //                                 color: BookStoryAppTheme
                    //                                     .grey,
                    //                               ),
                    //                             ),
                    //                             Container(
                    //                               child: Row(
                    //                                 children: <Widget>[
                    //                                   Text(
                    //                                     '${category!.playCount}',
                    //                                     textAlign:
                    //                                         TextAlign.left,
                    //                                     style: TextStyle(
                    //                                       fontWeight:
                    //                                           FontWeight.w200,
                    //                                       fontSize: 18,
                    //                                       letterSpacing: 0.27,
                    //                                       color:
                    //                                           BookStoryAppTheme
                    //                                               .grey,
                    //                                     ),
                    //                                   ),
                    //                                   Icon(
                    //                                     Icons.star,
                    //                                     color:
                    //                                         BookStoryAppTheme
                    //                                             .nearlyBlue,
                    //                                     size: 20,
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             )
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //               const SizedBox(
                    //                 width: 48,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 48,
                    //       ),
                    //     ],
                    //   ),
                    // ),

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
