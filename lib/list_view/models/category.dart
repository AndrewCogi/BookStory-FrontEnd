import 'package:book_story/screens/home_screen.dart';

class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.description = '',
    this.playTime = '0',
    this.playCount = 0,
  });

  String title;
  String description;
  String playTime;
  int playCount;
  String imagePath;


  static List<Category> categoryList = <Category>[
    Category(
      imagePath: 'assets/books/age_4_plus/book1.png',
      title: '곰곰아, 괜찮아?',
      description: '4+ | 창작 | 32p',
      playTime: '02:17',
      playCount: 36082,
    ),
    Category(
      imagePath: 'assets/books/age_4_plus/book2.png',
      title: '나 아기 안할래',
      description: '4+ | 창작 | 34p',
      playTime: '04:44',
      playCount: 28953,
    ),
    Category(
      imagePath: 'assets/books/age_4_plus/book3.png',
      title: '파란 물고기',
      description: '4+ | 창작 | 36p',
      playTime: '04:11',
      playCount: 24393,
    ),
    Category(
      imagePath: 'assets/books/age_4_plus/book4.png',
      title: '생각하는 ㄱㄴㄷ',
      description: '4+ | 창작 | 36p',
      playTime: '08:30',
      playCount: 21480,
    ),
    Category(
      imagePath: 'assets/books/age_4_plus/book5.png',
      title: '허수아비의 비밀',
      description: '4+ | 창작 | 48p',
      playTime: '07:27',
      playCount: 10244,
    ),
  ];

  static List<Category> popularBookList = <Category>[
    Category(
      imagePath: 'assets/books/popular/book1.png',
      title: '깨끗 공주와 깔끔 왕자',
      description: '~6 | 생활/습관 | 28p',
      playTime: '06:59',
      playCount: 63427,
    ),
    Category(
      imagePath: 'assets/books/popular/book2.png',
      title: '고요한 나라를 찾아서',
      description: '4+ | 동화/창작 | 40p',
      playTime: '03:04',
      playCount: 58473,
    ),
    Category(
      imagePath: 'assets/books/popular/book3.png',
      title: '도시락 도둑',
      description: '8+ | 동화/창작 | 40p',
      playTime: '08:44',
      playCount: 55126,
    ),
    Category(
      imagePath: 'assets/books/popular/book4.png',
      title: '치과의사 치카뿡',
      description: '4+ | 자연/과학 | 26p',
      playTime: '08:07',
      playCount: 52940,
    ),
    Category(
      imagePath: 'assets/books/popular/book5.png',
      title: '인절미 시집가는 날',
      description: '4+ | 사회/문화 | 40p',
      playTime: '08:24',
      playCount: 47542,
    ),
    Category(
      imagePath: 'assets/books/popular/book6.png',
      title: '고마워, 기역도깨비야',
      description: '~6 | 교양/학습 | 34p',
      playTime: '05:02',
      playCount: 45671,
    ),
    Category(
      imagePath: 'assets/books/popular/book7.png',
      title: '올리와 바람',
      description: '~6 | 동화/창작 | 40p',
      playTime: '04:25',
      playCount: 42122,
    ),
    Category(
      imagePath: 'assets/books/popular/book8.png',
      title: '틀린게 아니라 다른거야',
      description: '8+ | 사회/문화 | 38p',
      playTime: '06:09',
      playCount: 40004,
    ),
    Category(
      imagePath: 'assets/books/popular/book9.png',
      title: '공주양말',
      description: '4+ | 생활/습관 | 28p',
      playTime: '04:10',
      playCount: 34102,
    ),
    Category(
      imagePath: 'assets/books/popular/book10.png',
      title: '피가 붉다고?',
      description: '4+ | 자연/과학 | 26p',
      playTime: '03:45',
      playCount: 34879,
    ),
  ];


  static void setCategory(CategoryType categoryTypeData){
    if(categoryTypeData == CategoryType.age_4_plus){
      categoryList = <Category>[
        Category(
          imagePath: 'assets/books/age_4_plus/book1.png',
          title: '곰곰아, 괜찮아?',
          description: '4+ | 창작 | 32p',
          playTime: '02:17',
          playCount: 36082,
        ),
        Category(
          imagePath: 'assets/books/age_4_plus/book2.png',
          title: '나 아기 안할래',
          description: '4+ | 창작 | 34p',
          playTime: '04:44',
          playCount: 28953,
        ),
        Category(
          imagePath: 'assets/books/age_4_plus/book3.png',
          title: '파란 물고기',
          description: '4+ | 창작 | 36p',
          playTime: '04:11',
          playCount: 24393,
        ),
        Category(
          imagePath: 'assets/books/age_4_plus/book4.png',
          title: '생각하는 ㄱㄴㄷ',
          description: '4+ | 창작 | 36p',
          playTime: '08:30',
          playCount: 21480,
        ),
        Category(
          imagePath: 'assets/books/age_4_plus/book5.png',
          title: '허수아비의 비밀',
          description: '4+ | 창작 | 48p',
          playTime: '07:27',
          playCount: 10244,
        ),
      ];
    } else if(categoryTypeData == CategoryType.age_6_plus){
      categoryList = <Category>[
        Category(
          imagePath: 'assets/books/age_6_plus/book1.png',
          title: '내 마음대로',
          description: '6+ | 창작 | 36p',
          playTime: '04:01',
          playCount: 43700,
        ),
        Category(
          imagePath: 'assets/books/age_6_plus/book2.png',
          title: '보송이의 작은 모험',
          description: '6+ | 창작 | 36p',
          playTime: '08:20',
          playCount: 33861,
        ),
        Category(
          imagePath: 'assets/books/age_6_plus/book3.png',
          title: '별나라에서 온 공주',
          description: '6+ | 창작 | 36p',
          playTime: '05:11',
          playCount: 32338,
        ),
        Category(
          imagePath: 'assets/books/age_6_plus/book4.png',
          title: '아빠 쉬는 날',
          description: '6+ | 창작 | 36p',
          playTime: '05:21',
          playCount: 25078,
        ),
        Category(
          imagePath: 'assets/books/age_6_plus/book5.png',
          title: '솔비가 태어났어요',
          description: '6+ | 문화 | 36p',
          playTime: '06:49',
          playCount: 12682,
        ),
      ];
    } else if(categoryTypeData == CategoryType.creative){

    } else if(categoryTypeData == CategoryType.learning){

    } else if(categoryTypeData == CategoryType.culture_art){

    } else if(categoryTypeData == CategoryType.society_history){

    } else if(categoryTypeData == CategoryType.natural_science){

    }
  }
}
