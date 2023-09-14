import 'package:book_story/enums/category_type.dart';
import 'package:book_story/pages/popups/delete_account_popup.dart';
import 'package:book_story/pages/popups/internet_check_popup.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HelperFunctions {
  // 한국 시간 받아오기
  static String getKoreanDateTime(){
    initializeDateFormatting('ko_KR', null);
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 9)); // Adding 9 hours for Korean time
    String formattedDate = DateFormat.yMMMMd('ko_KR').format(now);
    String formattedTime = DateFormat.Hms('ko_KR').format(now);
    return '[$formattedDate $formattedTime]';
  }

  // 인터넷 연결 확인 TODO: 나중에 인터넷 연결 없음에 대한 해결방안 잘 생각하기
  static Future<bool> internetConnectionIsAlive(BuildContext context, bool terminate) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if(connectivityResult == ConnectivityResult.none){
      // ignore: use_build_context_synchronously
      _showNoInternetDialog(context, terminate);
      return false;
    }
    else{
      return true;
    }
  }

  // 인터넷 없음 팝업 / terminate에 따라 확인 눌렀을 때 종료 여부 결정
  static void _showNoInternetDialog(BuildContext context, bool terminate) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return InternetCheckPopup(terminate);
      },
    );
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
}