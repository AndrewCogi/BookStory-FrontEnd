import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:book_story/custom_drawer/home_drawer.dart';
import 'package:book_story/utils/time_service.dart';

class AuthService{
  final String email;
  final String password;

  AuthService({required this.email, required this.password});
}

// 로그인 로그 저장
Future<void> _recordLogin(String userEmail) async {
  // Perform login process using Amplify Auth
  AnalyticsEvent event = AnalyticsEvent("UserLoggedIn");
  event.properties.addStringProperty(userEmail, TimeService.getKoreanDateTime());
  // Log login event to analytics
  try{
    await Amplify.Analytics.recordEvent(event: event);
    Amplify.Analytics.flushEvents();
    safePrint("[LOGGED]: LogggedIn - $userEmail");
  } on AuthException catch(e){
    safePrint("MESSAGE"+e.message);
  }
}

// 로그아웃 로그 저장
Future<void> _recordLogout(String userEmail) async {
  // Perform logout process using Amplify Auth
  AnalyticsEvent event = AnalyticsEvent("UserLoggedOut");
  event.properties.addStringProperty(userEmail, TimeService.getKoreanDateTime());
  // Log logout event to analytics
  try{
    await Amplify.Analytics.recordEvent(event: event);
    Amplify.Analytics.flushEvents();
    safePrint("[LOGGED]: LogggedOut - $userEmail");
  } on AuthException catch(e){
    safePrint("MESSAGE"+e.message);
  }
}

// TODO : 회원가입 로그 저장
// TODO : 로그인 실패 로그 저장?

// 회원가입 요청
Future<String> onSignUp(AuthService data) async {
  AuthService loginData = data;
  try{
    await Amplify.Auth.signUp(
      username: loginData.email,
      password: loginData.password,
      options: CognitoSignUpOptions(userAttributes: {CognitoUserAttributeKey.email: loginData.email})
    );
    return '';
  } on AuthException catch(e){
    safePrint(e);
    return '${e.message}\n${e.recoverySuggestion}';
  }
}

// 로그인 요청
Future<String> onLogin(AuthService loginData) async {
  try {
    SignInResult res = await Amplify.Auth.signIn(
        username: loginData.email, password: loginData.password);

    bool isSignedIn = res.isSignedIn;
    safePrint('Login? : $isSignedIn');

    await _recordLogin(loginData.email);
  } on AuthException catch (e) {
    return e.message;
  }
  return '';
}

// 로그아웃 요청
Future<bool> onLogout(String userEmail) async{
  HomeDrawer.isLogin = null;
  await _recordLogout(userEmail);
  Amplify.Auth.signOut().then((_) {
    HomeDrawer.isLogin = false;
    HomeDrawer.userEmail = "";
    return true;
  });
  return false;
}

// 이메일 인증 요청
Future<String> verifyCode(AuthService data, String code) async {
  safePrint('email: ${data.email}, code: "+$code');
  String result = "Unknown Error. Try again.";
  try {
    SignUpResult res = await Amplify.Auth.confirmSignUp(
        username: data.email, confirmationCode: code);

    if (res.isSignUpComplete) {
      // 회원 가입 성공!!
      safePrint('SIGNUP SUCCESS!');
      result = '';
    }
  } on AuthException catch (e) {
    // 에러 핸들링
    result = e.message;
  }
  return result;
}

// 현재 로그인 상태 요청
Future<bool> checkAuthState() async {
  bool isLogin = false;
  try {
    AuthSession session = await Amplify.Auth.fetchAuthSession();
    if (session.isSignedIn) {
      safePrint('User is signed in');
      isLogin = true;
    } else {
      safePrint('User is not signed in');
    }
  } catch (e) {
    safePrint('Error checking auth state: $e');
  }
  return isLogin;
}

