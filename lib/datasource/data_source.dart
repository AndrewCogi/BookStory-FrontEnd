import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';

abstract class DataSource {
  Future<List<Book>> getBooksByCategory(List<CategoryType> categoryTypes, int limit);
  Future<List<Book>?> getBooksByUserEmailFavorite(String userEmail);
  Future<List<Book>> get10BooksByPlayCount();
  Future<bool> updateUser(String cmd, String userEmail);
  Future<bool?> getIsBookFavorite(String userEmail, int bookId);
  Future<int> updateFavorite(String userEmail, int bookId, String cmd);
  Future<String> getDescription(String descriptionPath);
  Future<List<Book>> getBooksByTitle(String title);
  Future<int> addView(String userEmail, int bookId);
}