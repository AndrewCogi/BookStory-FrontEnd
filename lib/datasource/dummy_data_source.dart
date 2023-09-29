import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/datasource/temp_db.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';

class DummyDataSource implements DataSource {
  @override
  Future<List<Book>> getBooksByCategory(List<CategoryType> categoryTypes, int limit) async {
    List<Book>? categoryList;
    try {
      // 해당 카테고리에 있는 책 검색
      categoryList = TempDB.bookList.where((book) {
        return book.categoryType.contains(categoryTypes) || book.categoryAge==categoryTypes; // TODO : 형식에 맞게 고쳐야 함
      }).toList();
      // playCount 순으로 정렬
      categoryList.sort((a, b) => b.playCount.compareTo(a.playCount));
      // 상위 5개의 책 선택
      categoryList = categoryList.take(limit).toList();
      // 반환
      return categoryList;
    } on StateError {
      return [];
    }
  }

  @override
  Future<List<Book>> get10BooksByPlayCount() async {
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
    } on StateError {
      return [];
    }
  }

  @override
  Future<List<Book>> getBooksByUserEmailFavorite(String userEmail) async {
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
    } on StateError {
      return [];
    }
  }

  @override
  Future<bool> updateUser(String cmd, String userEmail) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<bool> getIsBookFavorite(String userEmail, int bookId) {
    // TODO: implement getIsBookFavorite
    throw UnimplementedError();
  }

  @override
  Future<bool> updateFavorite(String userEmail, int bookId, String cmd) {
    // TODO: implement updateFavorite
    throw UnimplementedError();
  }

  @override
  Future<String> getDescription(String descriptionPath) {
    // TODO: implement getDescription
    throw UnimplementedError();
  }
}