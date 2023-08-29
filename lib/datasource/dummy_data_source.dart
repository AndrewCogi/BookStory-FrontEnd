import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/datasource/temp_db.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/utils/constants.dart';

class DummyDataSource implements DataSource {
  @override
  Future<List<Book>?> getBooksByCategory(CategoryType categoryType) async {
    List<Book>? categoryList;

    try {
      // 해당 카테고리에 있는 책 검색
      categoryList = TempDB.bookList.where((book) {
        return book.categoryType.contains(categoryType) || book.categoryAge==categoryType;
      }).toList();
      // playCount 순으로 정렬
      categoryList.sort((a, b) => b.playCount.compareTo(a.playCount));
      // 상위 5개의 책 선택
      categoryList = categoryList.take(getBooksByCategoryItemCount).toList();
      // 반환
      return categoryList;
    } on StateError catch (error) {
      return null;
    }
  }
}

// if(categoryType == CategoryType.age4plus){
//   categoryList = <Book>[
//     Book(
//       imagePath: 'assets/books/age_4_plus/book1.png',
//       title: '곰곰아, 괜찮아?',
//       drawer: '김정민',
//       writer: '김정민',
//       bookType: '4+ | 창작 | 32p',
//       playTime: '02:17',
//       favorite: 2739,
//       rate: 4.5,
//       playCount: 36082,
//       description: '곰곰이는 책을 좋아해요. 걸어가면서도 책을 읽어요. 어느 날 곰곰이는 돌부리에 걸려 넘어졌어요. '
//           '씽씽이를 타고 가던 콩콩이가 곰곰이에게 괜찮냐고 물어요. 그런데 곰곰이는 아무 말도 하지 않아요. 곰곰이는 정말 '
//           '괜찮을까요? 책을 좋아하는 곰곰이와 곰곰이를 걱정하는 착한 친구들의 이야기를 담은 그림책, 『곰곰아, 괜찮아?』입니다.',
//     ),
//     Book(
//       imagePath: 'assets/books/age_4_plus/book2.png',
//       title: '나 아기 안할래',
//       drawer: '김동영',
//       writer: '김동영',
//       bookType: '4+ | 창작 | 34p',
//       playTime: '04:44',
//       favorite: 2739,
//       rate: 4.5,
//       playCount: 28953,
//       description: '"착하기도 하지, 우리 아기 울지도 않고." '
//           '엄마는 동생만 사랑하는 게 아닐까? 동생에게 엄마의 사랑을 빼앗겨 버렸다고 생각하는 양정이. 양정이는 동생 양양이처럼 기저귀를 '
//           '차고, 유모차를 타고, 장난감이랑 책도 여기저기 마구 어질러 놓습니다. 과연 양정이는 어떤 마음일까요?',
//     ),
//     Book(
//       imagePath: 'assets/books/age_4_plus/book3.png',
//       title: '파란 물고기',
//       drawer: '김릴리',
//       writer: '차인우',
//       bookType: '4+ | 창작 | 36p',
//       playTime: '04:11',
//       favorite: 2739,
//       rate: 4.5,
//       playCount: 24393,
//       description: '파란 물고기가 노란 물고기, 해마, 거북이, 문어, 아귀 등등 많은 친구들을 만나요. 그런데 자기와 통하는 친구를 '
//           '만날 수 있을까요? 콜라주로 표현한 화려한 그림과 상징들을 통해 마음의 평온함을 느껴 보고 파란 물고기가 소통할 수 있는 '
//           '친구를 만날 수 있는지 함께 떠나 볼까요?',
//     ),
//     Book(
//         imagePath: 'assets/books/age_4_plus/book4.png',
//         title: '생각하는 ㄱㄴㄷ',
//         drawer: 'Iwona Chmielewska',
//         writer: 'Iwona Chmielewska',
//         bookType: '4+ | 창작 | 36p',
//         playTime: '08:30',
//         favorite: 2739,
//         rate: 4.5,
//         playCount: 21480,
//         description: '한글 낱자와 뛰어난 상상력의 만남! 재미있게 한글 공부도 하고, 상상력도 키우는 특별한 그림책! '
//             '글자그림책 ㄱA1 시리즈는 ‘한글’과 ‘알파벳’과 ‘숫자’의 각 글자 형태와 의미에 사물을 연결시켜 풀어내는 '
//             '독특한 상상력의 그림책입니다.'
//     ),
//     Book(
//       imagePath: 'assets/books/age_4_plus/book5.png',
//       title: '허수아비의 비밀',
//       drawer: '이초혜',
//       writer: '양승숙',
//       bookType: '4+ | 창작 | 48p',
//       playTime: '07:27',
//       favorite: 2739,
//       rate: 4.5,
//       playCount: 10244,
//       description: '들판에서 참새를 지키던 허수아비가 무료한 나머지 그 동안 바라만 보던 산속으로 간다. '
//           '숲 속의 모든 것이 신기하기만 한 허수아비는 온종일 숲 속을 돌아다니다가 피곤해 숲 속에서 잠이 든다. '
//           '잠에서 깬 허수아비는 부랴부랴 들판으로 달려간다.',
//     ),
//   ];
// } else if(categoryType == CategoryType.age6plus){
//   categoryList = <Book>[
//     Book(
//       imagePath: 'assets/books/age_6_plus/book1.png',
//       title: '내 마음대로',
//       bookType: '6+ | 창작 | 36p',
//       playTime: '04:01',
//       favorite: 2739,
//       rate: 4.5,
//       playCount: 43700,
//     ),
//     Book(
//       imagePath: 'assets/books/age_6_plus/book2.png',
//       title: '보송이의 작은 모험',
//       bookType: '6+ | 창작 | 36p',
//       playTime: '08:20',
//       favorite: 2739,
//       rate: 4.5,
//       playCount: 33861,
//     ),
//     Book(
//       imagePath: 'assets/books/age_6_plus/book3.png',
//       title: '별나라에서 온 공주',
//       bookType: '6+ | 창작 | 36p',
//       playTime: '05:11',
//       favorite: 2739,
//       rate: 4.5,
//       playCount: 32338,
//     ),
//     Book(
//       imagePath: 'assets/books/age_6_plus/book4.png',
//       title: '아빠 쉬는 날',
//       bookType: '6+ | 창작 | 36p',
//       playTime: '05:21',
//       favorite: 2739,
//       rate: 4.5,
//       playCount: 25078,
//     ),
//     Book(
//       imagePath: 'assets/books/age_6_plus/book5.png',
//       title: '솔비가 태어났어요',
//       bookType: '6+ | 문화 | 36p',
//       playTime: '06:49',
//       favorite: 2739,
//       rate: 4.5,
//       playCount: 12682,
//     ),
//   ];
// } else if(categoryType == CategoryType.creative){
//
// } else if(categoryType == CategoryType.learning){
//
// } else if(categoryType == CategoryType.cultureArt){
//
// } else if(categoryType == CategoryType.societyHistory){
//
// } else if(categoryType == CategoryType.naturalScience){
//
// }
//
// return categoryList;