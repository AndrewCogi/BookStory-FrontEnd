import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:book_story/amplifyconfiguration.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/models/user_model.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:book_story/provider/app_data_provider.dart';
import 'package:book_story/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthControllerImpl implements AuthController {
  // final AppDataSource _appDataSource = AppDataSource();

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
  Future<String> onSignUp(User data) async {
    try {
      await Amplify.Auth.signUp(
          username: data.userEmail,
          password: data.password,
          options: SignUpOptions(
              userAttributes: {CognitoUserAttributeKey.email: data.userEmail})
      );
      await recordSignUp(data.userEmail); // TODO : 이메일 인증까지 완료하고 호출하도록 변경하기
      safePrint('[onSignUp Result] : SUCCESS!');
      return '';
    } on AuthException catch (e) {
      safePrint('[onSignUp Result] : $e');
      return e.message;
    }
  }

  @override
  Future<String> onLogin(User data) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
          username: data.userEmail, password: data.password);

      bool isSignedIn = res.isSignedIn;
      safePrint('Successfully Login? : $isSignedIn');

      // 정상적인 로그인으로 확인되지 않음.
      if(isSignedIn == false){
        throw Exception('Unconfirmed.');
      }
      // 정상적으로 로그인이 확인됨
      await recordLogin(data.userEmail);
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
  Future<bool> onLogout(BuildContext context) async {
    // TODO : DB에 로그아웃 알림
    Provider.of<AppDataProvider>(context, listen: false).updateUser('logout',await getCurrentUserEmail()).then((_) => {
      Amplify.Auth.signOut().then((_) {
      return true;
      })
    });
    return false;
  }

  @override
  Future<bool> onDeleteAccount(BuildContext context) async {
    // TODO : DB에 회원탈퇴 알림
    Provider.of<AppDataProvider>(context, listen: false).updateUser('remove',await getCurrentUserEmail()).then((_) => {
      Amplify.Auth.deleteUser().then((_) {
        return true;
      })
    });
    return false;
  }

  @override
  Future<String> verifyCode(User data, String code) async {
    safePrint('email: ${data.userEmail}, code: "+$code');
    String result = "Unknown Error. Try again.";
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: data.userEmail, confirmationCode: code);

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
  Future<String> getCurrentUserEmail() async {
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      final signInDetails = authUser.signInDetails as CognitoSignInDetailsApiBased;
      final username = signInDetails.username;
      safePrint('aa: $username');
      if (authUser != null) {
        return username;
      }
    } catch (e) {
      print("Error fetching current user: $e");
    }
    return "";
  }

  @override
  Future<String?> getCurrentUserAccessToken() async {
    final result = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions());
    // String? idToken = (result as CognitoAuthSession).userPoolTokensResult.valueOrNull?.idToken.raw;
    // safePrint('[IdToken]: $idToken');
    String? accessToken = (result as CognitoAuthSession).userPoolTokensResult.valueOrNull?.accessToken.raw;
    safePrint('[AccessToken]: $accessToken');
    // String? refreshToken = (result as CognitoAuthSession).userPoolTokensResult.valueOrNull?.refreshToken;
    // safePrint('[RefreshToken]: $refreshToken');

    return accessToken;
  }

  // @override
  // Future<void> validateToken(String accessToken) async {
  //   final url = Uri.parse('http://sgm.cloudsoft-bookstory.com/api/auth/validate-token');
  //   final response = await http.post(url, body: json.encode({'accessToken': accessToken}), headers: {
  //     'Content-Type': 'application/json',
  //   });
  //
  //   safePrint('[response]: ${response.body}');
  //
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final message = data['message'];
  //     final username = data['username'];
  //     print('Message: $message');
  //     if (message == 'Token is valid') {
  //       print('Authenticated user: $username');
  //     } else {
  //       print('Token validation failed.');
  //     }
  //   } else {
  //     print('Failed to validate token.');
  //   }
  // }

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
  Future<Map<String, dynamic>?> verificationProcessIDPW(BuildContext context, User appUserData) async {
    // errorMessage 2쌍을 저장해서 반환할 결과
    Map<String, dynamic> result = {
      'errorMessageEmail': "",
      'errorMessagePassword': "",
    };
    // check
    safePrint("email: ${appUserData.userEmail}, pw: ${appUserData.password}");
    // ID/PW가 하나라도 비어있는 경우
    if(appUserData.userEmail == "" || appUserData.password == ""){
      // ID is empty
      if (appUserData.userEmail == "") {
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
    if (isEmailValid(appUserData.userEmail) == false ||
        isPasswordValidResult != "") {
      // 이메일 형식 체크
      if (isEmailValid(appUserData.userEmail) == false) {
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
  Future<Map<String, dynamic>?> signUpProcess(User appUserData, BuildContext context) async {
    // errorMessage 2쌍을 저장해서 반환할 결과
    Map<String, dynamic> result = {
      'errorMessageEmail': "",
      'errorMessagePassword': "",
    };

    safePrint('AUTH!');
    String signUpResult = await onSignUp(appUserData);
    // 회원가입 성공
    if(signUpResult == '') {
      // TODO : DB에 회원가입 알림
      Provider.of<AppDataProvider>(context, listen: false).updateUser('add',appUserData.userEmail);
      return null;
    }
    // 회원가입 실패. 사유 작성해서 반환.
    else {
      result['errorMessageEmail'] = signUpResult;
      return result;
    }
  }

  @override
  Future<Map<String, dynamic>?> loginProcess(User appUserData, BuildContext context) async {
    // errorMessage 2쌍을 저장해서 반환할 결과
    Map<String, dynamic> result = {
      'errorMessageEmail': "",
      'errorMessagePassword': "",
    };

    safePrint('LOGIN!');
    String loginResult = await  onLogin(appUserData);
    // 로그인 성공
    if (loginResult == '') {
      // TODO : DB에 로그인 알림
      Provider.of<AppDataProvider>(context, listen: false).updateUser('login',appUserData.userEmail);
      return null;
    }
    // 로그인 실패. 사유 작성해서 반환.
    else {
      result['errorMessageEmail'] = loginResult;
      return result;
    }
  }
}