import 'package:book_story/enums/category_type.dart';

class Book {
  int? id;
  String title;
  String drawer;
  String writer;
  int bookPage;
  CategoryType categoryAge;
  List<CategoryType> categoryType;
  String playTime;
  int favorite;
  int playCount;
  double rate;
  String imagePath;
  String description;

  Book({
    this.id,
    required this.title,
    required this.drawer,
    required this.writer,
    required this.imagePath,
    required this.bookPage,
    required this.categoryAge,
    required this.categoryType,
    required this.playTime,
    required this.favorite,
    required this.rate,
    required this.playCount,
    required this.description,
  });
}
