import 'package:book_story/pages/popups/internet_check_popup.dart';
import 'package:book_story/utils/book_story_app_theme.dart';
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

  // 인터넷 연결 확인
  static Future<bool> internetConnectionCheck() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // 인터넷 없음 팝업
  static void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const InternetCheckPopup();
      },
    );
  }
}