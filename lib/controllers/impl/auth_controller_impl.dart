import 'dart:convert';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:book_story/amplifyconfiguration.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/models/app_user.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:book_story/utils/helper_functions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthControllerImpl implements AuthController {

  @override
  Future<String?> configureAmplify() async {
    bool configured = false;
    final auth = AmplifyAuthCognito();
    final analytics = AmplifyAnalyticsPinpoint();

    try{
      Amplify.addPlugins([auth, analytics]);
      await Amplify.configure(amplifyconfig);
      configured = true;
    } on UnknownException catch(e) {
      safePrint(e);
      return e.message;
    }

    if(configured){
      safePrint('Successfully configured Amplify!');
      safePrint('Check auth state...');
      HomeDrawer.isLogin = await checkAuthState();
      safePrint("HomeDrawer.isLogin : ${HomeDrawer.isLogin}");
    }
    return null;
  }

  @override
  Future<void> recordLogin(String userEmail) async {
    AnalyticsEvent event = AnalyticsEvent("UserLogin");
    event.customProperties.addStringProperty(
        userEmail, HelperFunctions.getKoreanDateTime());
    // Log login event to analytics
    try {
      await Amplify.Analytics.recordEvent(event: event);
      Amplify.Analytics.flushEvents();
      safePrint("[LOG]: Login - $userEmail");
    } on AuthException catch (e) {
      safePrint("MESSAGE: ${e.message}");
    }
  }

  @override
  Future<void> recordSignUp(String userEmail) async {
    AnalyticsEvent event = AnalyticsEvent("UserSignUp");
    event.customProperties.addStringProperty(
        userEmail, HelperFunctions.getKoreanDateTime());
    // Log signup event to analytics
    try {
      await Amplify.Analytics.recordEvent(event: event);
      Amplify.Analytics.flushEvents();
      safePrint("[LOG]: SignUp - $userEmail");
    } on AuthException catch (e) {
      safePrint("MESSAGE: ${e.message}");
    }
  }

  @override
  Future<String> onSignUp(AppUser data) async {
    try {
      await Amplify.Auth.signUp(
          username: data.email,
          password: data.password,
          options: SignUpOptions(
              userAttributes: {CognitoUserAttributeKey.email: data.email})
      );
      await recordSignUp(data.email);
      safePrint('[onSignUp Result] : SUCCESS!');
      return '';
    } on AuthException catch (e) {
      safePrint('[onSignUp Result] : $e');
      return e.message;
    }
  }

  @override
  Future<String> onLogin(AppUser data) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
          username: data.email, password: data.password);

      bool isSignedIn = res.isSignedIn;
      safePrint('Successfully Login? : $isSignedIn');

      // 정상적인 로그인으로 확인되지 않음.
      if(isSignedIn == false){
        throw Exception('Unconfirmed.');
      }
      // 정상적으로 로그인이 확인됨
      await recordLogin(data.email);
      safePrint('[onLogin Result] : SUCCESS!');
      return '';
    } on AuthException catch (e) {
      safePrint('[onLogin Result] : $e');
      return e.message;
    } on Exception catch (e) {
      safePrint('[onLogin Result] : $e');
      return e.toString();
    }
  }

  @override
  Future<bool> onLogout() async {
    Amplify.Auth.signOut().then((_) {
      return true;
    });
    return false;
  }

  @override
  Future<String> verifyCode(AppUser data, String code) async {
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

  @override
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

  @override
  Future<String?> getCurrentUserToken() async {
    final result = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions());
    String? idToken = (result as CognitoAuthSession).userPoolTokensResult.valueOrNull?.idToken.raw;
    safePrint('[IdToken]: $idToken');
    String? accessToken = result.userPoolTokensResult.valueOrNull?.accessToken.raw;
    safePrint('[AccessToken]: $accessToken');
    String? refreshToken = result.userPoolTokensResult.valueOrNull?.refreshToken;
    safePrint('[RefreshToken]: $refreshToken');

    validateToken(accessToken!);
    return 'testing';
  }

  @override
  Future<void> validateToken(String accessToken) async {
    final url = Uri.parse('http://sgm.cloudsoft-bookstory.com/validate-token');
    final response = await http.post(url, body: json.encode({'accessToken': accessToken}), headers: {
      'Content-Type': 'application/json',
    });

    safePrint('[response]: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final message = data['message'];
      final username = data['username'];
      print('Message: $message');
      if (message == 'Token is valid') {
        print('Authenticated user: $username');
      } else {
        print('Token validation failed.');
      }
    } else {
      print('Failed to validate token.');
    }
  }

  @override
  bool isEmailValid(String email) {
    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');
    return emailRegExp.hasMatch(email);
  }

  @override
  String isPasswordValid(String password) {
    if (password.length < 8) {
      return "Password must be at least 8 characters long.";
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return "Password must contain at least 1 number.";
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Password must contain at least 1 special character.";
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return "Password must contain at least 1 uppercase letter.";
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return "Password must contain at least 1 lowercase letter.";
    }
    return ""; // Password is valid
  }

  @override
  Future<Map<String, dynamic>?> verificationProcessIDPW(BuildContext context, AppUser appUserData) async {
    // errorMessage 2쌍을 저장해서 반환할 결과
    Map<String, dynamic> result = {
      'errorMessageEmail': "",
      'errorMessagePassword': "",
    };
    // check
    safePrint("email: ${appUserData.email}, pw: ${appUserData.password}");
    // ID/PW가 하나라도 비어있는 경우
    if(appUserData.email == "" || appUserData.password == ""){
      // ID is empty
      if (appUserData.email == "") {
        result['errorMessageEmail'] = "Enter Email.";
      }
      // PW is empty
      if (appUserData.password == "") {
        result['errorMessagePassword'] = "Enter Password.";
      }
      return result;
    }
    // 비어있지 않은 경우 형식 검증 진행
    String isPasswordValidResult = isPasswordValid(appUserData.password);
    if (isEmailValid(appUserData.email) == false ||
        isPasswordValidResult != "") {
      // 이메일 형식 체크
      if (isEmailValid(appUserData.email) == false) {
        result['errorMessageEmail'] = "Check your email format.";
      }
      // 비번 형식 체크
      if (isPasswordValidResult != "") {
        result['errorMessagePassword'] = isPasswordValidResult;
      }
      return result;
    }
    // go!
    return null;
  }

  @override
  Future<Map<String, dynamic>?> signUpProcess(AppUser appUserData) async {
    // errorMessage 2쌍을 저장해서 반환할 결과
    Map<String, dynamic> result = {
      'errorMessageEmail': "",
      'errorMessagePassword': "",
    };

    safePrint('AUTH!');
    String signUpResult = await onSignUp(appUserData);
    // 회원가입 성공
    if(signUpResult == '') {
      return null;
    }
    // 회원가입 실패. 사유 작성해서 반환.
    else {
      result['errorMessageEmail'] = signUpResult;
      return result;
    }
  }

  @override
  Future<Map<String, dynamic>?> loginProcess(AppUser appUserData) async {
    // errorMessage 2쌍을 저장해서 반환할 결과
    Map<String, dynamic> result = {
      'errorMessageEmail': "",
      'errorMessagePassword': "",
    };

    safePrint('LOGIN!');
    String loginResult = await onLogin(appUserData);
    // 로그인 성공
    if (loginResult == '') {
      return null;
    }
    // 로그인 실패. 사유 작성해서 반환.
    else {
      result['errorMessageEmail'] = loginResult;
      return result;
    }
  }
}