import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/pages/popups/rating_popup.dart';
import 'package:book_story/provider/app_data_provider.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
import 'package:book_story/utils/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

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
  int maxX=0;

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
    // userEmail을 받아놓기
    userEmail = await _authController.getCurrentUserEmail();
    // 리뷰 최대값 계산해두기
    maxX = bardata.map((data) => data.jumlah.toInt()).reduce((a, b) => a > b ? a : b);

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
                  aspectRatio: 1.5,
                  child: CachedNetworkImage(
                    placeholder: null,
                    imageUrl: widget.book.imagePath,
                    errorWidget: (context, url, error) => const Icon(Icons.cancel_outlined),
                  ),
                ),
              ],
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
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 10),
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
                                  children: [
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
                          const Divider(thickness: 1),
                          Expanded(
                            child: Card(
                              elevation: 2,
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
                                              Tab(child: Text('책 소개',style: TextStyle(color: Colors.black))),
                                              Tab(child: Text('출판사 리뷰',style: TextStyle(color: Colors.black))),
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
                                                        FittedBox(
                                                          child: Text(
                                                            "책 소개",
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              letterSpacing: 0.27,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          widget.book.description,
                                                          textAlign: TextAlign.justify,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w200,
                                                            fontSize: 16,
                                                            letterSpacing: 0.27,
                                                            color: BookStoryAppTheme.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 40),
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
                                                        SizedBox(height: 10),
                                                        Text(
                                                          '저자 김정민은 어릴 땐 책을 많이 읽지 않았어요. '
                                                          '재미없다고 생각했거든요. 어른이 되고 나서야 책 맛을 알았어요. '
                                                          '그리고 그림에책 빠져들었어요. 그림책 속에는 많은 이야기가 숨어 있었어요. '
                                                          '위로해 주기도 하고, 하하하 웃게도 해주고, 내가 주인공이라면 어떻게 할까민 고하게 하기도 했지요. '
                                                          '그림책을 만난 일이 제게는 정말 행복한 일이었어요. 그래서 그림책 작가가 되기로 했어요. '
                                                          '위로가 되어주고, 웃게 해주고, 때로는 고민하게도 하는, 그런 그림책을 만들고 싶습니다.',
                                                          textAlign: TextAlign.justify,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w200,
                                                            fontSize: 16,
                                                            letterSpacing: 0.27,
                                                            color: BookStoryAppTheme.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 30)
                                                      ],
                                                    )
                                                  ),
                                                ),
                                                Center(
                                                  child: SingleChildScrollView(
                                                    child: Padding(
                                                        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              FittedBox(
                                                                child: Text(
                                                                  "책의 즐거움을 알려주는 그림책",
                                                                  textAlign: TextAlign.start,
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 18,
                                                                    letterSpacing: 0.27,
                                                                    color: Colors.grey,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Text(
                                                                '책을 읽다가 어느새 두세 시간이 지나가 있는 것을 알고 깜짝 놀란 적이 있나요? '
                                                                '집중을 잘하지 못하는 어린이들도 재미있는 책을 읽으면 깜짝 놀랄 만큼 집중하게 됩니다. '
                                                                '친구들이나 가족들이 뭐라고 해도 들리지 않습니다. 『곰곰아, 괜찮아?』는 어린이들에게 책의 즐거움을 알려줍니다.',
                                                                textAlign: TextAlign.justify,
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w200,
                                                                  fontSize: 15,
                                                                  letterSpacing: 0.23,
                                                                  color: BookStoryAppTheme.grey,
                                                                ),
                                                              ),
                                                              SizedBox(height: 40),
                                                              FittedBox(
                                                                child: Text(
                                                                  "아픈 친구를 병원으로 데려가는 모험 그림책",
                                                                  textAlign: TextAlign.start,
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 18,
                                                                    letterSpacing: 0.27,
                                                                    color: Colors.grey,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Text(
                                                                '곰곰이가 넘어지자 토끼 콩콩이가 나타나 괜찮냐고 묻습니다. '
                                                                '어려움에 처한 친구를 돕는 일은 아름답습니다. 하지만 쉽지만은 않습니다. '
                                                                '곰곰이가 너무 무거워서 씽씽이가 부러져버립니다. '
                                                                '이제부터 곰곰이를 병원에 데려가기 위한 모험이 펼쳐집니다. '
                                                                '과연 친구들은 곰곰이를 병원에 무사히 데려갈 수 있을까요?',
                                                                textAlign: TextAlign.justify,
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w200,
                                                                  fontSize: 15,
                                                                  letterSpacing: 0.23,
                                                                  color: BookStoryAppTheme.grey,
                                                                ),
                                                              ),
                                                              SizedBox(height: 40),
                                                              FittedBox(
                                                                child: Text(
                                                                  "그림 속에 숨겨진 또 다른 모험을 찾아보세요!",
                                                                  textAlign: TextAlign.start,
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 18,
                                                                    letterSpacing: 0.27,
                                                                    color: Colors.grey,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Text(
                                                                '언뜻 보면 『곰곰아, 괜찮아?』에는 두 가지 모험이 그려지고 있습니다. '
                                                                    '바로 곰곰이가 읽는 책 속의 모험 이야기와 곰곰이를 병원에 데려가는 친구들의 모험 이야기입니다. '
                                                                    '하지만 그림책 자세히 보면 또 다른 등장인물의 모험이 담겨 있습니다. '
                                                                    '동물 친구들의 이야기 외에도 작은 이야기가 숨어있습니다. '
                                                                    '김정민 작가가 독자들에게 선사하는 세 번째 모험 이야기를 찾아보세요!',
                                                                textAlign: TextAlign.justify,
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w200,
                                                                  fontSize: 15,
                                                                  letterSpacing: 0.23,
                                                                  color: BookStoryAppTheme.grey,
                                                                ),
                                                              ),
                                                              SizedBox(height: 40),
                                                              FittedBox(
                                                                child: Text(
                                                                  "신인 김정민 작가의 재기 넘치는 그림책",
                                                                  textAlign: TextAlign.start,
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 18,
                                                                    letterSpacing: 0.27,
                                                                    color: Colors.grey,
                                                                  ),
                                                                ),
                                                              ),

                                                              SizedBox(height: 10),
                                                              Text(
                                                                '곰곰이는 어떤 상황에서도 손에서 책을 놓지 않습니다. '
                                                                '친구들은 넘어져서 아무 말도 못하고 울다가 찡그리다가 웃기도 하는 곰곰이가 걱정됩니다. '
                                                                '분명 같은 공간에 있는데 서로의 생각이 다릅니다. '
                                                                '김정민 작가는 그 생각의 차이에서 나오는 웃음에 주목해서 한 편의 멋진 그림책을 완성했습니다.',
                                                                textAlign: TextAlign.justify,
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w200,
                                                                  fontSize: 15,
                                                                  letterSpacing: 0.23,
                                                                  color: BookStoryAppTheme.grey,
                                                                ),
                                                              ),
                                                              SizedBox(height: 40),
                                                              FittedBox(
                                                                child: Text(
                                                                  "제11회 서울와우북페스티벌 상상만찬 일러스트展 당선작가",
                                                                  textAlign: TextAlign.start,
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 18,
                                                                    letterSpacing: 0.27,
                                                                    color: Colors.grey,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Text(
                                                                '김정민 작가는 11회 서울와우북페스티벌 상상만찬 일러스트展에 당선되면서 북극곰과 인연을 맺었습니다. '
                                                                '당선 작가들의 전시회에서 북극곰 이루리 편집장이 『곰곰아, 괜찮아?』의 더미북을 보고 첫눈에 반한 것입니다. '
                                                                '늦깎이 작가 김정민의 신선한 활약을 기대해 봅니다.',
                                                                // textAlign: TextAlign.justify,
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w200,
                                                                  fontSize: 15,
                                                                  letterSpacing: 0.23,
                                                                  color: BookStoryAppTheme.grey,
                                                                ),
                                                              ),
                                                              SizedBox(height: 40),
                                                              Text(
                                                                "전 세계 독자들을 위한 영문 페이지",
                                                                textAlign: TextAlign.start,
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 18,
                                                                  letterSpacing: 0.27,
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Text(
                                                                '『곰곰아, 괜찮아?』에는 본문이 끝나면 썸네일 이미지와 함께 영문 텍스트가 실려 있습니다. '
                                                                '전 세계 독자들과 소통하기 위해 북극곰이 정성껏 마련한 지면입니다. '
                                                                '이미 북극곰이 출간한 많은 도서가 세계인의 사랑을 받고 있습니다. '
                                                                'BGC ENGLISH PICTUREBOOK 이라고 이름 지어진 영문 페이지를 통해 '
                                                                '온 세상 부모들과 어린이들의 마음이 더욱 가깝게 이어지기를 희망합니다.',
                                                                textAlign: TextAlign.justify,
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w200,
                                                                  fontSize: 15,
                                                                  letterSpacing: 0.23,
                                                                  color: BookStoryAppTheme.grey,
                                                                ),
                                                              ),
                                                              SizedBox(height: 30),
                                                            ],
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
                                                            Center(
                                                              child: SizedBox(
                                                                  width: MediaQuery.of(context).size.width * 0.1,
                                                                  child: Center(
                                                                    child: Text(
                                                                      _calculateWeightedAverage(bardata).toString().substring(0,3),
                                                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.06),
                                                                    ),
                                                                  )
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: _buildGraph(bardata),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(thickness: 1),
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                                            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                                            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.grey), // 글씨 색상 설정
                                                          ),
                                                          child: const Text(
                                                            "Rate book",
                                                            style: TextStyle(
                                                              decorationThickness: 1,
                                                              decoration: TextDecoration.underline, // 밑줄 추가
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            final result = await showDialog<double>(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return const RatingPopup();
                                                              },
                                                            );
                                                            if (result != null) {
                                                              // 팝업에서 반환된 점수를 사용합니다.
                                                              print("Selected Rating: $result");
                                                            }
                                                          },
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
            Provider.of<AppDataProvider>(context, listen: false).updateFavorite(userEmail, widget.book.bookId, 'add').then((result) => {
              if(result == true){
                setState(() {}),
                safePrint('Add Favorite!')
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
            Provider.of<AppDataProvider>(context, listen: false).updateFavorite(userEmail, widget.book.bookId, 'remove').then((result) => {
              if(result == true){
                setState(() {}),
                safePrint('Remove Favorite!')
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
      return Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)),
        elevation: 10.0,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: (){
            safePrint('Unknown.. Loading..?');
          },
          child: const SizedBox(
            width: 60,
            height: 60,
            child: Center(),
          ),
        ),
      );
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
          tooltip: "${maxX}+", // 툴팁도 수정할 수 있습니다.
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

  List<VBarChartModel> bardata = [
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
}
