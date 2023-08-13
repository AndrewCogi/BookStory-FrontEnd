import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TimeService {
  static String getKoreanDateTime(){
    initializeDateFormatting('ko_KR', null);
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 9)); // Adding 9 hours for Korean time
    String formattedDate = DateFormat.yMMMMd('ko_KR').format(now);
    String formattedTime = DateFormat.Hms('ko_KR').format(now);
    return '[$formattedDate $formattedTime]';
  }
}