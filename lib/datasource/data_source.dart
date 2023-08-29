import 'package:book_story/models/book_model.dart';
import 'package:book_story/pages/screens/home_screen.dart';

abstract class DataSource {
  Future<List<Book>?> getBooksByCategory(CategoryType categoryType);
}