import 'package:book_story/enums/user_status.dart';

class User {
  String userEmail;
  String password;
  UserStatus? userStatus;
  DateTime? lastLoginTime;

  User({
    required this.userEmail,
    required this.password,
  });
}