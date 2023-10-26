import 'package:book_story/models/user_model.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthController{
  // Amplify 초기화
  Future<String?> configureAmplify();
  // User session 확인
  Future<bool> checkUserSessionIsExpired(BuildContext context);
  // 로그인 로그 저장
  Future<void> recordLogin(String userEmail);
  // 회원가입 로그 저장
  Future<void> recordSignUp(String userEmail);
  // 회원가입 요청
  Future<String> onSignUp(User data, BuildContext context);
  // 로그인 요청
  Future<String> onLogin(User data, BuildContext context);
  // 로그아웃 요청
  Future<String> onLogout(BuildContext context);
  // 계정 삭제 요청
  Future<String> onDeleteAccount(BuildContext context);
  // 이메일 인증 요청
  Future<String> verifyCode(User data, String code, BuildContext context);
  // 현재 로그인 상태 확인.
  Future<bool> checkAuthState();
  // 로그인한 유저 email 반환. 로그인 정보가 없다면 "" 반환
  Future<String> getCurrentUserEmail();
  // 로그인한 유저 token 반환. Token에는 사용자 정보들이 왕창 들어있음! TODO : 백엔드에서 이 token과 비교해서 로그인한 사람을 찾을 예정!
  Future<String?> getCurrentUserAccessToken();
  // 유효한 이메일 형식인지 검사
  bool isEmailValid(String email);
  // 유효한 비밀번호 형식인지 검사
  String isPasswordValid(String password);
  // 로그인 문자열 검증 절차 진행 - 이 문자열(email,pw)로 Cognito에 로그인/회원가입을 시도해 봐도 되는가를 확인함
  Future<Map<String, dynamic>?> verificationProcessIDPW(BuildContext context, User appUserData);
  // 로그인 절차 진행
  Future<Map<String, dynamic>?> loginProcess(User appUserData, BuildContext context);
  // 회원가입 절차 진행
  Future<Map<String, dynamic>?> signUpProcess(User appUserData, BuildContext context);
  // 사용자 토큰 유효성 검사
  Future<bool> tokenIsValid(String userEmail);
}