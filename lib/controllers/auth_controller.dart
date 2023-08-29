import 'package:book_story/models/app_user.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthController{
  // Amplify 초기화
  void configureAmplify();
  // 로그인 로그 저장
  Future<void> recordLogin(String userEmail);
  // 회원가입 로그 저장
  Future<void> recordSignUp(String userEmail);
  // 회원가입 요청
  Future<String> onSignUp(AppUser data);
  // 로그인 요청
  Future<String> onLogin(AppUser data);
  // 로그아웃 요청
  Future<bool> onLogout(String userEmail);
  // 이메일 인증 요청
  Future<String> verifyCode(AppUser data, String code);
  // 현재 로그인 상태 요청
  Future<bool> checkAuthState();
  // 유효한 이메일 형식인지 검사
  bool isEmailValid(String email);
  // 유효한 비밀번호 형식인지 검사
  String isPasswordValid(String password);
  // 로그인 문자열 검증 절차 진행 - 이 문자열(email,pw)로 Cognito에 로그인/회원가입을 시도해 봐도 되는가를 확인함
  Future<Map<String, dynamic>?> stringValidCheckProcess(BuildContext context, AppUser appUserData);
  // 로그인 절차 진행
  Future<Map<String, dynamic>?> loginProcess(AppUser appUserData);
  // 회원가입 절차 진행
  Future<Map<String, dynamic>?> signUpProcess(AppUser appUserData);
}