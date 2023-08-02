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
      imagePath: 'assets/design_course/interFace3.png',
      title: 'App Design Course',
      description: '12',
      playTime: '0',
      playCount: 8,
    ),
    Category(
      imagePath: 'assets/design_course/interFace4.png',
      title: 'Web Design Course',
      description: '28',
      playTime: '0',
      playCount: 9,
    ),
    Category(
      imagePath: 'assets/design_course/interFace3.png',
      title: 'App Design Course',
      description: '12',
      playTime: '0',
      playCount: 8,
    ),
    Category(
      imagePath: 'assets/design_course/interFace4.png',
      title: 'Web Design Course',
      description: '28',
      playTime: '0',
      playCount: 9,
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
