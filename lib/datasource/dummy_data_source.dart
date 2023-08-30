import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/datasource/temp_db.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';

class DummyDataSource implements DataSource {
  @override
  Future<List<Book>?> get5BooksByCategory(CategoryType categoryType) async {
    List<Book>? categoryList;
    try {
      // 해당 카테고리에 있는 책 검색
      categoryList = TempDB.bookList.where((book) {
        return book.categoryType.contains(categoryType) || book.categoryAge==categoryType;
      }).toList();
      // playCount 순으로 정렬
      categoryList.sort((a, b) => b.playCount.compareTo(a.playCount));
      // 상위 5개의 책 선택
      categoryList = categoryList.take(5).toList();
      // 반환
      return categoryList;
    } on StateError catch (error) {
      return null;
    }
  }

  @override
  Future<List<Book>?> get10BooksByPlayCount() async {
    List<Book>? popularList;
    try{
      // 모든 책 검색
      popularList = TempDB.bookList;
      // playCount 순으로 정렬
      popularList.sort((a, b) => b.playCount.compareTo(a.playCount));
      // 상위 10개의 책 선택
      popularList = popularList.take(10).toList();
      // 반환
      return popularList;
    } on StateError catch (error) {
      return null;
    }
  }
}