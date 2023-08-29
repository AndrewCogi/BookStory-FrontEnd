import 'package:book_story/pages/screens/home_screen.dart';

class Book {
  int? id;
  String title;
  String drawer;
  String writer;
  String bookType;
  List<CategoryType> categoryType;
  String playTime;
  int favorite;
  int playCount;
  double rate;
  String imagePath;
  String description;

  Book({
    this.id,
    this.title = '',
    this.drawer = '',
    this.writer = '',
    this.imagePath = '',
    this.bookType = '',
    this.categoryType = const [CategoryType.none],
    this.playTime = '0',
    this.favorite = 0,
    this.rate = 0.0,
    this.playCount = 0,
    this.description = '',
  });
}
