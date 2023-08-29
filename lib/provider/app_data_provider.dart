import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/datasource/dummy_data_source.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/pages/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';

class AppDataProvider extends ChangeNotifier {
  final DataSource _dataSource =DummyDataSource();
  Future<List<Book>?> getBooksByCategory(CategoryType categoryType) {
    return _dataSource.getBooksByCategory(categoryType);
  }
}