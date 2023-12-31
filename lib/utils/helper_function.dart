import 'package:book_story/enums/category_type.dart';
import 'package:book_story/pages/popups/delete_account_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HelperFunction {
  // 한국 시간 받아오기
  static String getKoreanDateTime(){
    initializeDateFormatting('ko_KR', null);
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 9)); // Adding 9 hours for Korean time
    String formattedDate = DateFormat.yMMMMd('ko_KR').format(now);
    String formattedTime = DateFormat.Hms('ko_KR').format(now);
    return '[$formattedDate $formattedTime]';
  }

  // 계정탈퇴 팝업
  static void showConfirmDeleteAccount(BuildContext context, String text){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountPopup(text);
      },
    );
  }

  // 책 카테고리를 받아서 하나의 문자열로 만들어 줌
  static String makeBookCategoryToString(List<CategoryType> categoryType, int takeCount){
    List<String> typeList = categoryType.map((type) => categoryDescriptions[type] ?? '').take(takeCount).toList();
    String typeString = typeList.join('/');
    return typeString;
  }

  // 책 추천 나이, 카테고리, 페이지를 받아서 하나의 문자열로 만들어 줌
  // ex : '4+ | 동화/창작 | 32p'
  static String makeBookInfo(CategoryType categoryAge, List<CategoryType> categoryType, int takeCount, int page){
    return "${categoryDescriptions[categoryAge]} | ${makeBookCategoryToString(categoryType, takeCount)} | ${page}p";
  }

  // 책에 대한 playTime(초)을 받아서, "xx:yy" 문자열로 만들어 줌
  static String formatSecondsToMinutesAndSeconds(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedMinutes = minutes < 10 ? '0$minutes' : '$minutes';
    String formattedSeconds = remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';

    return '$formattedMinutes:$formattedSeconds';
  }

  // CategoryType 리스트를 받아서 이름만 ,로 구분지어 반환하는 함수
  static String getCategoryNames(List<CategoryType> categoryTypes) {
    List<String> categoryNames = [];
    for (CategoryType category in categoryTypes) {
      categoryNames.add(category.toString().split('.').last);
    }
    return categoryNames.join(', ');
  }

  // 다크모드, 라이트모드 시스템 오버레이 스타일 바꿔주는 함수
  static void setSystemUIOverlayStyle(context){
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if(isLightMode) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    }
  }
  //
  // static Future<bool> saveLoginTime(int time) async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.setInt(loginTime, time);
  // }
  //
  // static Future<int> getLoginTime() async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.getInt(loginTime) ?? 0;
  // }
  //
  // static Future<bool> saveExpirationDuration(int duration) async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.setInt(expirationDuration, duration);
  // }
  //
  // static Future<int> getExpirationDuration() async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.getInt(expirationDuration) ?? 0;
  // }
  //
  // static Future<bool> hasTokenExpired() async {
  //   final loginTime = await getLoginTime();
  //   final expDuration = await getExpirationDuration();
  //   return DateTime.now().millisecondsSinceEpoch - loginTime > expDuration;
  // }
}