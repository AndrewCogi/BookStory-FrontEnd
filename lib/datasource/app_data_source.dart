import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/datasource/temp_db.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/utils/helper_function.dart';
import 'package:http/http.dart' as http;

class AppDataSource extends DataSource{
  final AuthController _authController = AuthControllerImpl();
  final String baseUrl = 'http://sgm.cloudsoft-bookstory.com/api/';

  Map<String, String> get header => {
    'Content-Type' : 'application/json',
  };

  Future<Map<String, String>> get authHeader async => {
    'Content-Type' : 'application/json',
    'Authorization' : 'Bearer ${await _authController.getCurrentUserAccessToken()}',
  };

  @override
  Future<List<Book>> getBooksByCategory(List<CategoryType> categoryTypes, int limit) async {
    final String url;
    final String categoryTypeStr = HelperFunction.getCategoryNames(categoryTypes);
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
      safePrint("1. response.body: ${response.body}");
      safePrint("2. response.statusCode: ${response.statusCode}");
      if(response.statusCode == 200){
        final Map<String, dynamic> jsonData = json.decode(const Utf8Decoder().convert(response.bodyBytes));
        final List<Map<String, dynamic>> responseList = List<Map<String, dynamic>>.from(jsonData['response']);
        final List<Book> books = responseList.map((map) => Book.fromJson(map)).toList();
        return books;
      }
      else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    }catch(error){
      safePrint(error.toString());
      rethrow;
    }
  }


  @override
  Future<List<Book>> getBooksByTitle(String title) async {
    final url = '$baseUrl${'book'}/$title';
    safePrint(url);
    try{
      final response = await http.get(
        Uri.parse(url),
        headers: header
      );
      safePrint("1. response.body: ${response.body}");
      safePrint("2. response.statusCode: ${response.statusCode}");
      if(response.statusCode == 200){
        final Map<String, dynamic> jsonData = json.decode(const Utf8Decoder().convert(response.bodyBytes));
        final List<Map<String, dynamic>> responseList = List<Map<String, dynamic>>.from(jsonData['response']);
        final List<Book> books = responseList.map((map) => Book.fromJson(map)).toList();
        return books;
      }
      else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
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

      response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode({'userEmail': userEmail})
      );

      safePrint("1. response.body: ${response.body}");
      safePrint("2. response.statusCode: ${response.statusCode}");
      if(response.statusCode == 200){
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
    final headers = await authHeader;
    safePrint(url);
    try{
      final http.Response response;
        response = await http.get(
            Uri.parse(url),
            headers: headers,
        );

      safePrint("1. response.body: ${response.body}");
      safePrint("2. response.statusCode: ${response.statusCode}");
      // JSON 문자열을 Map으로 파싱
      Map<String, dynamic> parsedJson = json.decode(response.body);
      safePrint("3. response.statusCode in parsedJson: ${parsedJson['statusCode']}");
      if(parsedJson['statusCode'] == 200){
        bool responseValue = parsedJson['response'];
        safePrint("responseValue: $responseValue");
        return responseValue;
      }
      safePrint("[getIsBookFavorite]: UnAuthorized");
      return null;
    }catch(error){
      safePrint(error.toString());
      rethrow;
    }
  }

  @override
  Future<int> updateFavorite(String userEmail, int bookId, String cmd) async {
    final String url = '$baseUrl${'favorite/'}$cmd';
    safePrint(url);
    try{
      final http.Response response;
      response = await http.post(
        Uri.parse(url),
        headers: await authHeader,
        body: json.encode({'user':{'userEmail':userEmail}, 'book':{'bookId':bookId}})
      );
      safePrint("1. response.body: ${response.body}");
      safePrint("2. response.statusCode: ${response.statusCode}"); // TODO : 서버 고쳐서 모든 response.body를 response.statusCode와 맞춤..ㅠㅠ 확인하기!
      return response.statusCode;
    }catch(error){
      safePrint(error.toString());
      rethrow;
    }
  }

  @override
  Future<String> getDescription(String descriptionPath) async {
    final String url = descriptionPath;
    safePrint(url);
    try{
      return utf8.decode(await http.readBytes(Uri.parse(url)));
    }catch(error){
      return "Failed to fetch data";
    }
  }
}