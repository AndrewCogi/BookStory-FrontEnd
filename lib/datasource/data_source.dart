import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';

abstract class DataSource {
  Future<List<Book>> get5BooksByCategory(CategoryType categoryType);
  Future<List<Book>> get10BooksByPlayCount();
}