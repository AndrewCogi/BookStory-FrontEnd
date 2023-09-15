import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/datasource/data_source.dart';
import 'package:book_story/datasource/temp_db.dart';
import 'package:book_story/enums/category_type.dart';
import 'package:book_story/enums/response_status.dart';
import 'package:book_story/models/book_model.dart';
import 'package:book_story/models/error_details_model.dart';
import 'package:book_story/models/response_model.dart';
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
  Future<List<Book>> get5BooksByCategory(CategoryType categoryType) async {
    // final url = '$baseUrl${'book/get5BooksByCategory'}';
    final url = '$baseUrl${'book/all'}';
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        final mapList = json.decode(const Utf8Decoder().convert(response.bodyBytes)) as List;
        return List.generate(mapList.length, (index) => Book.fromJson(mapList[index]));
      }
      return [];
    }catch(error){
      print(error.toString());
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

  Future<ResponseModel> _getResponseModel(http.Response response) async {
    ResponseStatus status = ResponseStatus.none;
    ResponseModel responseModel = ResponseModel();


    // // TODO : 테스트용
    // responseModel = ResponseModel.fromJson(jsonDecode(response.body));
    // safePrint("HH");
    // // 파싱된 데이터를 순회하면서 출력 -> List<Map<String, dynamic>> 말고 Map<String, dynamic>으로 받도록 백프론트 수정해야할듯..
    // for (var key in responseModel.object.keys) {
    //   safePrint('key : '+key+', value: '+responseModel.object[key]);
    // }


    if(response.statusCode == 200){
      status = ResponseStatus.saved;
      responseModel = ResponseModel.fromJson(jsonDecode(response.body));
      responseModel.responseStatus = status;
    } else if(response.statusCode == 401 || response.statusCode == 403){
      if(await HelperFunctions.hasTokenExpired()){
        status = ResponseStatus.expired;
      } else {
        status = ResponseStatus.unauthorized;
      }
      responseModel = ResponseModel(
        responseStatus: status,
        statusCode: 401,
        message: 'Access denied. Please login as admin.',
      );
    } else if(response.statusCode == 500 || response.statusCode == 400){
      final json = jsonDecode(response.body);
      final errorDetails = ErrorDetails.fromJson(json);
      status = ResponseStatus.failed;
      responseModel = ResponseModel(
        responseStatus: status,
        statusCode: 500,
        message: errorDetails.errorMessage,
      );
    }
    return responseModel;
  }
}