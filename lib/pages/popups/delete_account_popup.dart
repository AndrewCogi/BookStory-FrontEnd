import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:flutter/material.dart';

class DeleteAccountPopup extends StatefulWidget {
  final String text;

  const DeleteAccountPopup(this.text, {super.key});

  @override
  DeleteAccountPopupState createState() => DeleteAccountPopupState();
}

class DeleteAccountPopupState extends State<DeleteAccountPopup> {
  final TextEditingController _emailController = TextEditingController();
  final AuthController _authController = AuthControllerImpl();
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkEmail);
  }

  void _checkEmail() {
    setState(() {
      _isEmailValid = _emailController.text == widget.text;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('회원 탈퇴 확인'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('모든 회원 정보가 삭제됩니다. \n회원 탈퇴를 진행하려면 아래에 \'Confirm\'을 입력하세요.'),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Confirm'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // 팝업 닫기
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _isEmailValid
              ? () async {
            String result = 'foo';
            await _authController.onDeleteAccount(context).then((value) => result = value);
            if(result == ''){ // 회원탈퇴 성공
              setState(() {
                HomeDrawer.isLogin = false;
                HomeDrawer.userID = 'Guest User';
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('회원탈퇴 완료')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
            }
            Navigator.of(context).pop(); // 팝업 닫기
            // // text가 일치하는 경우 회원 탈퇴 로직 실행
            // _authController.onDeleteAccount(context);
            // setState(() {
            //   HomeDrawer.isLogin = false;
            // });
            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('회원탈퇴 완료')));
            //
            // Navigator.of(context).pop(); // 팝업 닫기
          }
              : null, // text가 일치하지 않으면 버튼 비활성화
          child: const Text('확인'),
        ),
      ],
    );
  }
}