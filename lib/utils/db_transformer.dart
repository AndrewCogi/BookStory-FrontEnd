import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/datasource/temp_db.dart';

// TempDB 값을 json 형태로 변환 & 출력 역할

void main() {
  safePrint(jsonEncode(TempDB.bookList));
}