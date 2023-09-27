import 'package:book_story/datasource/app_data_source.dart';
import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/datasource/dummy_data_source.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';
import 'package:flutter/cupertino.dart';

class AppDataProvider extends ChangeNotifier {
  // final DataSource _dataSource =DummyDataSource();
  final DataSource _dataSource =AppDataSource();
  Future<List<Book>> getBooksByCategory(List<CategoryType> categoryTypes, int limit) {
    return _dataSource.getBooksByCategory(categoryTypes, limit);
  }
  Future<List<Book>> getBooksByUserEmailFavorite(String userEmail){
    return _dataSource.getBooksByUserEmailFavorite(userEmail);
  }
  Future<List<Book>> get10BooksByPlayCount(){
    return _dataSource.get10BooksByPlayCount();
  }
  Future<bool> updateUser(String cmd, String userEmail){
    return _dataSource.updateUser(cmd, userEmail);
  }
  Future<bool?> getIsBookFavorite(String userEmail, int bookId){
    return _dataSource.getIsBookFavorite(userEmail, bookId);
  }
  Future<bool> updateFavorite(String userEmail, int bookId, String cmd){
    return _dataSource.updateFavorite(userEmail, bookId, cmd);
  }
}