import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';

class AppDataSource extends DataSource{
  final String baseUrl = 'http://sgm.cloudsoft-bookstory.com/api/';

  Map<String, String> get header => {
    'Content-Type' : 'application/json'
  };

  @override
  Future<List<Book>?> get10BooksByPlayCount() {
    // TODO: implement get10BooksByPlayCount
    throw UnimplementedError();
  }

  @override
  Future<List<Book>?> get5BooksByCategory(CategoryType categoryType) {
    // TODO: implement get5BooksByCategory
    throw UnimplementedError();
  }
}