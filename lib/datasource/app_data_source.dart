import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/datasource/temp_db.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/utils/helper_functions.dart';
import 'package:http/http.dart' as http;

class AppDataSource extends DataSource{
  final AuthController _authController = AuthControllerImpl();
  final String baseUrl = 'http://sgm.cloudsoft-bookstory.com/api/';

  Map<String, String> get header => {
    'Content-Type' : 'application/json'
  };

  // TODO : 나중에 로그인 후 사용 가능한 서비스 이용할 때 사용
  Future<Map<String, String>> get authHeader async => {
    'Content-Type' : 'application/json',
    'Authorization' : 'Bearer ${await _authController.getCurrentUserAccessToken()}',
  };

  @override
  Future<List<Book>> getBooksByCategory(List<CategoryType> categoryTypes, int limit) async {
    final String url;
    final String categoryTypeStr = HelperFunctions.getCategoryNames(categoryTypes);
    safePrint('categoryTypeStr: $categoryTypeStr');
    // CategoryAge 인지 체크
    if(categoryTypeStr.contains("age")){
      url = '$baseUrl${'book/getBooksByCategoryAge'}/$categoryTypeStr?limit=$limit';
    }
    // CategoryAge가 아니라면 CategoryType 실시
    else {
      url = '$baseUrl${'book/getBooksByCategoryType'}/$categoryTypeStr?limit=$limit';
    }
    try{
      final response = await http.get(
          Uri.parse(url),
          headers: header
      );
      if(response.statusCode == 200){
        final mapList = json.decode(const Utf8Decoder().convert(response.bodyBytes)) as List;
        return List.generate(mapList.length, (index) => Book.fromJson(mapList[index]));
      }
      return [];
    }catch(error){
      safePrint(error.toString());
      rethrow;
    }
  }

  @override
  Future<List<Book>> getBooksByUserEmailFavorite(String userEmail) async {
    final String url = '$baseUrl${'favorite/'}$userEmail';
    safePrint(url);
    try{
      final response = await http.get(
          Uri.parse(url),
          headers: await authHeader
      );
      if(response.statusCode == 200){
        final mapList = json.decode(const Utf8Decoder().convert(response.bodyBytes)) as List;
        final List<Book> books = mapList.map((map) {
          final bookMap = map['book'];
          return Book.fromJson(bookMap);
        }).toList();
        return books;
      }
      return [];
    }catch(error){
      safePrint(error.toString());
      rethrow;
    }
  }

  @override
  Future<bool> updateUser(String cmd, String userEmail) async {
    final String url = '$baseUrl${'auth/'}$cmd';
    safePrint(url);
    try{
      final http.Response response;
      if(cmd != "remove") {
        response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode({'userEmail': userEmail})
      );
      } else {
        response = await http.post(
            Uri.parse(url),
            headers: await authHeader,
            body: json.encode({'userEmail': userEmail})
        );
      }
      safePrint("response.body: ${response.body}");
      if(response.statusCode == 200){
        safePrint(response.body);
        return true;
      }
      return false;
    }catch(error){
      safePrint(error.toString());
      rethrow;
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
  Future<bool?> getIsBookFavorite(String userEmail, int bookId) async {
    final String url = '$baseUrl${'favorite/'}$userEmail/$bookId';
    safePrint(url);
    try{
      final http.Response response;
        response = await http.get(
            Uri.parse(url),
            headers: await authHeader
        );

      safePrint("response.body: ${response.body}");
      if(response.statusCode == 200){
        // JSON 문자열을 Map으로 파싱
        Map<String, dynamic> parsedJson = json.decode(response.body);
        bool responseValue = parsedJson['response'];
        safePrint(responseValue);
        return responseValue;
      }
      safePrint("[getIsBookFavorite]: UnAuthorized");
      return null;
    }catch(error){
      safePrint(error.toString());
      rethrow;
    }
  }

  // @override
  // Future<bool> getIsBookFavorite(String userEmail, String bookId) {
  //   final String url = '$baseUrl${'auth/'}$cmd';
  //   safePrint(url);
  //   try{
  //     final http.Response response;
  //     if(cmd != "remove") {
  //       response = await http.post(
  //           Uri.parse(url),
  //           headers: header,
  //           body: json.encode({'userEmail': userEmail})
  //       );
  //     } else {
  //       response = await http.post(
  //           Uri.parse(url),
  //           headers: await authHeader,
  //           body: json.encode({'userEmail': userEmail})
  //       );
  //     }
  //     safePrint("response.body: ${response.body}");
  //     if(response.statusCode == 200){
  //       safePrint(response.body);
  //       return true;
  //     }
  //     return false;
  //   }catch(error){
  //     safePrint(error.toString());
  //     rethrow;
  //   }
  // }
}