import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/pages/popups/book_story_dialog.dart';
import 'package:book_story/pages/popups/rating_popup.dart';
import 'package:book_story/pages/screens/video_player_screen.dart';
import 'package:book_story/provider/app_data_provider.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:book_story/utils/constants.dart';
import 'package:book_story/utils/helper_function.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

import '../custom_drawer/home_drawer.dart';
import 'login_screen.dart';

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
  double opacityOrg = 0.0;
  double opacity0 = 0.0;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  final AuthController _authController = AuthControllerImpl();
  String userEmail = "";
  String bookDescription = "";
  String writerDescription = "";
  String publisherDescription = "";
  List<String> imageList = List.generate(imageListSize, (index) => '');
  int maxX = 0;
  bool isComplete = true;

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

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  Future<void> setData() async {
    // 사진 보여주기
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    setState(() {opacityOrg = 1.0;});
    // 책 미리보기 이미지 경로 세팅
    imageList = getImages(widget.book.bookId);
    // userEmail 받아놓기
    userEmail = await _authController.getCurrentUserEmail();
    // 리뷰 최대값 계산해두기
    maxX = bardata.map((data) => data.jumlah.toInt()).reduce((a, b) => a > b ? a : b);
    // bookDescription 받아두기
    bookDescription = await Provider.of<AppDataProvider>(context, listen: false).getDescription(widget.book.bookDescriptionPath);
    // writerDescription 받아두기
    writerDescription = await Provider.of<AppDataProvider>(context, listen: false).getDescription(widget.book.writerDescriptionPath);
    // publisherDescription 받아두기
    publisherDescription = await Provider.of<AppDataProvider>(context, listen: false).getDescription(widget.book.publisherDescriptionPath);

    animationController?.forward();
    setState(() {
      opacity0 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 400));
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
        (MediaQuery.of(context).size.width / 1.5) +
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
                    aspectRatio: 1.6,
                  child: Swiper(
                    autoplay: true,
                    itemCount: imageList.length,
                    pagination: const SwiperPagination(
                      alignment: Alignment.topCenter,
                      builder: DotSwiperPaginationBuilder(
                        size: 8,
                        activeSize: 10,
                        color: Colors.grey,
                        activeColor: BookStoryAppTheme.nearlyBlue
                      ),
                    ),
                    duration: 1000,
                    autoplayDelay: 5000,
                    control: const SwiperControl(
                      color: Colors.transparent
                    ),
                    itemBuilder: (BuildContext context,int index){
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: opacityOrg,
                        child: CachedNetworkImage(
                          placeholder: null,
                          imageUrl: imageList[index],
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) => const Icon(Icons.cancel_outlined),
                        ),
                      );

                    },
                  ),
                ),
              ]
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.5) - 24.0,
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
                        color: BookStoryAppTheme.grey.withOpacity(0.5),
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
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 18, right: 16),
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
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  HelperFunction.formatSecondsToMinutesAndSeconds(widget.book.playTime),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: BookStoryAppTheme.nearlyBlue,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.grey), // 글씨 색상 설정
                                          ),
                                          child: const Text(
                                            "평가하기",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              decorationThickness: 1,
                                              decoration: TextDecoration.underline, // 밑줄 추가
                                            ),
                                          ),
                                          onPressed: () async {
                                            if(HomeDrawer.isLogin == false){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('로그인하세요'),
                                                    content: const Text('로그인 후 이용 가능해요.'),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        child: const Text('로그인'),
                                                        onPressed: (){
                                                          Navigator.of(context).pop(); // 대화 상자 닫기
                                                          Navigator.push<dynamic>(
                                                            context,
                                                            MaterialPageRoute<dynamic>(
                                                              builder: (BuildContext context) => const LoginScreen(),
                                                            ),
                                                          ).then((value) => setState(() {}));
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                        child: const Text('닫기'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop(); // 대화 상자 닫기
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              return;
                                            }
                                            final result = await showDialog<double>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const RatingPopup();
                                              },
                                            );
                                            if (result != null) {
                                              // 팝업에서 반환된 점수를 사용
                                              print("Selected Rating: $result");
                                            }
                                          },
                                        ),
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
                              ],
                            ),
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
                                    getBookInfoBoxUI(HelperFunction.makeBookCategoryToString(widget.book.categoryType, widget.book.categoryType.length), 'Category'),
                                    widget.book.writer == widget.book.drawer ?
                                      getBookInfoBoxUI(widget.book.writer, 'Writer/Drawer') :
                                      getBookInfoBoxUI('${widget.book.writer}/${widget.book.drawer}', 'Writer/Drawer'),
                                    getBookInfoBoxUI('${widget.book.bookPage}', 'Page'),
                                  ],
                                ),
                              ),

                            ),
                          ),
                          const Divider(thickness: 1),
                          Expanded(
                            child: Card(
                              elevation: 1,
                              child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: opacity2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: DefaultTabController(
                                      length: 3, // TabBar에 표시될 탭 수
                                      child: Column(
                                        children: <Widget>[
                                          const TabBar(
                                            tabs: <Widget>[
                                              Tab(child: Text('작품 소개',style: TextStyle(color: Colors.black))),
                                              Tab(child: Text('출판사 서평',style: TextStyle(color: Colors.black))),
                                              Tab(child: Text('평가 n개',style: TextStyle(color: Colors.black))),
                                            ],
                                            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                                            unselectedLabelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                                            indicatorColor: BookStoryAppTheme.nearlyBlue,
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15, right: 15, top: 15),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        const FittedBox(
                                                          child: Text(
                                                            "책 소개",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              letterSpacing: 0.27,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Text(
                                                          bookDescription,
                                                          textAlign: TextAlign.justify,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w200,
                                                            fontSize: 16,
                                                            letterSpacing: 0.27,
                                                            color: BookStoryAppTheme.grey,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 40),
                                                        FittedBox(
                                                          child: Text(
                                                            "저자 소개 (${widget.book.writer})",
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              letterSpacing: 0.27,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Text(
                                                          writerDescription,
                                                          textAlign: TextAlign.justify,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w200,
                                                            fontSize: 16,
                                                            letterSpacing: 0.27,
                                                            color: BookStoryAppTheme.grey,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 30)
                                                      ],
                                                    )
                                                  ),
                                                ),
                                                Center(
                                                  child: SingleChildScrollView(
                                                    child: Padding(
                                                        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: makePublisherText(publisherDescription)
                                                          ),
                                                        )
                                                    ),
                                                  )
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 16, right: 16, top: 8, bottom: 8),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Column(
                                                              children: [
                                                                const Icon(
                                                                  Icons.star,
                                                                  color: Colors.yellow,
                                                                  size: 40,
                                                                ),
                                                                Center(
                                                                  child: SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.1,
                                                                      child: Center(
                                                                        child: Text(
                                                                          _calculateWeightedAverage(bardata).toString().substring(0,3),
                                                                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03+10, fontWeight: FontWeight.bold),
                                                                        ),
                                                                      )
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            Expanded(
                                                              child: _buildGraph(bardata),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(thickness: 1),
                                                          Column(
                                                            children: [
                                                              // TODO : 댓글 리스트 만들기
                                                              const Text('내 댓글'),
                                                              const Divider(thickness: 1),
                                                              const Text('댓글 리스트'),
                                                            ],
                                                          ),
                                                      ],
                                                    )
                                                  )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                                      onTap: () async {
                                        safePrint('addView in DB...'); // 게스트 유저의 경우, userEmail="" 으로 view에 저장됨
                                        setState(() {isComplete = false;});
                                        int resultStatusCode = await Provider.of<AppDataProvider>(context, listen: false)
                                            .addView(userEmail, widget.book.bookId);
                                        if(resultStatusCode != 200) {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(content: Text('DB err. Maybe USER_NOT_FOUND')));
                                        }
                                        else{
                                          safePrint('Play Story');
                                          // ignore: use_build_context_synchronously
                                          Navigator.push<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) => VideoPlayerScreen(widget.book.title),
                                            ),
                                          ).then((_) => setState(() {}));
                                        }
                                        setState(() {isComplete = true;});
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
              top: (MediaQuery.of(context).size.width / 1.5) - 24.0 - 35,
              right: 35,
                child: FutureBuilder<bool?>(
                  future: Provider.of<AppDataProvider>(context, listen: false)
                      .getIsBookFavorite(userEmail, widget.book.bookId),
                  builder: (context, AsyncSnapshot<bool?> snapshot) {
                    safePrint('snapshot: $snapshot');
                    if(snapshot.data == null) {
                      animationController!.reset();
                      animationController!.forward();
                      return const SizedBox();
                    }
                  return ScaleTransition(
                    alignment: Alignment.center,
                    scale: CurvedAnimation(
                        parent: animationController!, curve: Curves.fastOutSlowIn),
                    child: _buildHeartIcon(snapshot),
                  );
                }
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
            ),
            if(isComplete == false)
              Container(
                color: Colors.black.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
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

  Widget _buildHeartIcon(AsyncSnapshot<bool?> snapshot) {
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
            Provider.of<AppDataProvider>(context, listen: false).updateFavorite(userEmail, widget.book.bookId, 'add').then((resultCode) => {
              safePrint('Add Favorite Result : $resultCode'),
              if(resultCode == 200){ // 정상적으로 추가가 되었을 때
                setState(() {}),
                safePrint('Add Favorite!')
              }else if(resultCode == 400){ // 중복로그인한 누군가가 이미 추가했을 때
                // 최신화만 진행
                setState(() {}),
              }
              else{
                safePrint('[Add Favorite button] : Login first!'),
                _authController.onLogout(context),
                setState(() {
                  HomeDrawer.isLogin = false;
                  HomeDrawer.userID = 'Guest User';
                }),
                BookStoryDialog.showDialogBoxSessionExpired(context)
              }
            });
          },
          child: const SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: Icon(
                Icons.favorite,
                color: Colors.white,
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
            Provider.of<AppDataProvider>(context, listen: false).updateFavorite(userEmail, widget.book.bookId, 'remove').then((resultCode) => {
              safePrint('Remove Favorite Result : $resultCode'),
              if(resultCode == 200){ // 정상적으로 삭제가 되었을 때
                setState(() {}),
                safePrint('Remove Favorite!')
              }else if(resultCode == 400){ // 중복로그인한 누군가가 이미 삭제했을 때 (삭제할게 없을 때)
                // 최신화만 진행
                setState(() {}),
              }
              else{
                safePrint('[Remove Favorite button] : Login first!'),
                _authController.onLogout(context),
                setState(() {
                  HomeDrawer.isLogin = false;
                  HomeDrawer.userID = 'Guest User';
                }),
                BookStoryDialog.showDialogBoxSessionExpired(context)
              }
            });
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
    // 셋 다 아닌 상태. 로딩중 등
    else {
      return const SizedBox();
    }
  }

  Widget _buildGraph(List<VBarChartModel> bardata) {
    // bardata를 수정하여 maxX 값을 초과하는 값을 처리합니다.
    bardata = bardata.map((data) {
      if (data.jumlah <= maxX) {
        return data;
      } else {
        return VBarChartModel(
          index: data.index,
          label: data.label,
          colors: data.colors,
          jumlah: maxX.toDouble(), // maxX 값을 초과하는 값을 maxX로 수정
          tooltip: "$maxX+", // 툴팁도 수정할 수 있습니다.
        );
      }
    }).toList();

    // labelSizeFactor 구하기
    double x = MediaQuery.of(context).size.width;
    double m = -0.13 / 489;
    double b = 0.26 + (0.13 / 489) * 411;
    double labelSizeFactor = m * x + b;

    return VerticalBarchart(
      labelSizeFactor: labelSizeFactor,
      showBackdrop: true,
      background: Colors.transparent,
      labelColor: Color(0xff283137),
      tooltipColor: Color(0xff8e97a0),
      maxX: maxX.toDouble(),
      data: bardata,
      barStyle: BarStyle.DEFAULT,
    );
  }

  double _calculateWeightedAverage(List<VBarChartModel> data) {
    if (data.isEmpty) return 0.0;

    double totalScore = 0.0;
    int totalReviews = 0;

    for (var item in data) {
      double score = double.tryParse(item.label ?? '0.0') ?? 0.0;
      totalScore += score * item.jumlah;
      totalReviews += item.jumlah.toInt();
    }

    if (totalReviews == 0) return 0.0;

    return totalScore / totalReviews;
  }

  List<String> getImages(int bookId){
    String url = 'https://d1uuv72cpfayuq.cloudfront.net/books/images/';
    List<String> imageList = [];
    imageList.add('$url$bookId.png');
    for(int i=1; i<=this.imageList.length-1; i++){
      imageList.add('$url$bookId-$i.png');
    }
    return imageList;
  }

  List<VBarChartModel> bardata = [ // TODO : barData 서버에서 가져오도록 하기
    VBarChartModel(
      index: 0,
      label: "5.0",
      colors: [Color(0xfff93f5b), Color(0xfff93f5b)],
      jumlah: 179,
      tooltip: "179개",
    ),
    VBarChartModel(
      index: 1,
      label: "4.0",
      colors: [Color(0xfff93f5b), Color(0xfff93f5b)],
      jumlah: 123,
      tooltip: "123개",
    ),
    VBarChartModel(
      index: 2,
      label: "3.0",
      colors: [Color(0xfff93f5b), Color(0xfff93f5b)],
      jumlah: 121,
      tooltip: "121개",
    ),
    VBarChartModel(
      index: 3,
      label: "2.0",
      colors: [Color(0xfff93f5b), Color(0xfff93f5b)],
      jumlah: 4,
      tooltip: "4개",
    ),
    VBarChartModel(
      index: 4,
      label: "1.0",
      colors: [Color(0xfff93f5b), Color(0xfff93f5b)],
      jumlah: 7,
      tooltip: "7개",
    ),
  ];


  List<Widget> makePublisherText(String publisherDescription) {
    List<Widget> widgets = [];
    List<String> texts = publisherDescription.split("###");
    int length = texts.length;

    for(int i=0; i<length; i++){
      // 제목
      if(i%2==0){
        widgets.add(
          FittedBox(
            child: Text(
              texts[i],
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 0.27,
                color: Colors.grey,
              ),
            ),
          )
        );
        widgets.add(
          const SizedBox(height: 10)
        );
      }
      // 글
      else{
        widgets.add(
          Text(
            texts[i],
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 15,
              letterSpacing: 0.23,
              color: BookStoryAppTheme.grey,
            ),
          )
        );
        if(i-1==length) {
          widgets.add(
            const SizedBox(height: 30)
          );
        } else {
          widgets.add(
            const SizedBox(height: 40)
          );
        }
      }
    }

    return widgets;
  }
}
