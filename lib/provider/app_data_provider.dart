import 'package:book_story/datasource/app_data_source.dart';
import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/datasource/dummy_data_source.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';
import 'package:flutter/cupertino.dart';

class AppDataProvider extends ChangeNotifier {
  // final DataSource _dataSource =DummyDataSource();
  final DataSource _dataSource =AppDataSource();
  Future<List<Book>> get5BooksByCategory(CategoryType categoryType) {
    return _dataSource.get5BooksByCategory(categoryType);
  }
  Future<List<Book>> get10BooksByPlayCount(){
    return _dataSource.get10BooksByPlayCount();
  }
}