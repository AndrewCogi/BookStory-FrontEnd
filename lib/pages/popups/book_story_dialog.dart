import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

class BookStoryDialog{
  static showDialogBoxSessionExpired(BuildContext context) => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('세션 만료'),
      content: const Text('세션이 만료되었습니다.\n다시 로그인 해주세요.'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const LoginScreen(),
              ),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Login',style: TextStyle(fontSize: 17)),
        ),
      ],
    ),
  );
}