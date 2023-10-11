import 'package:book_story/enums/user_status.dart';

class User {
  String userEmail;
  String password;
  UserStatus? userStatus;
  DateTime? lastStatusUpdateTime;

  User({
    required this.userEmail,
    required this.password,
  });
}