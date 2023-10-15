import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:book_story/amplifyconfiguration.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/models/user_model.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:book_story/provider/app_data_provider.dart';
import 'package:book_story/utils/helper_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AuthControllerImpl implements AuthController {

  Future<Map<String, String>> get authHeader async => {
    'Content-Type' : 'application/json',
    'Authorization' : 'Bearer ${await getCurrentUserAccessToken()}',
  };

  @override
  Future<String?> configureAmplify() async {
    bool configured = false;
    final auth = AmplifyAuthCognito();
    final analytics = AmplifyAnalyticsPinpoint();

    try{
      Amplify.addPlugins([auth,analytics]);
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
      String userEmail = await getCurrentUserEmail();
      String nowUserID = userEmail.split('@')[0];
      nowUserID == "" ? HomeDrawer.userID="Guest User" : HomeDrawer.userID=nowUserID;
      safePrint("HomeDrawer.isLogin : ${HomeDrawer.isLogin}");
      // 로그인 만료 확인
      if(HomeDrawer.isLogin == true && await tokenIsValid(userEmail) == false){
        safePrint("로그인 만료임!");
        // TODO : 만료를 팝업으로 알리고 로그아웃 실시
      } else {safePrint("로그인 만료 아님! 아니면 로그인 안함!");}
    }
    return null;
  }

  @override
  Future<bool> tokenIsValid(String userEmail) async {
    final String url = 'http://sgm.cloudsoft-bookstory.com/api/auth/tokenValid?userEmail=$userEmail';
    safePrint(url);
    try{
      final http.Response response;
      response = await http.get(
          Uri.parse(url),
          headers: await authHeader
      );
      safePrint("1. response.body: ${response.body}");
      safePrint("2. response.statusCode: ${response.statusCode}");
      if(response.statusCode == 200) {
        return (response.body).toLowerCase() != "false";
      }
      return false;
    }catch(error){
      safePrint(error.toString());
      rethrow;
    }
  }

  @override
  Future<void> recordLogin(String userEmail) async {
    AnalyticsEvent event = AnalyticsEvent("UserLogin");
    event.customProperties.addStringProperty(
        userEmail, HelperFunction.getKoreanDateTime());
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
        userEmail, HelperFunction.getKoreanDateTime());
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
  Future<String> onSignUp(User data, BuildContext context) async {
    try {
      await Amplify.Auth.signUp(
          username: data.userEmail,
          password: data.password,
          options: SignUpOptions(
              userAttributes: {CognitoUserAttributeKey.email: data.userEmail})
      );

      // 정상적으로 회원가입이 확인됨
      await recordSignUp(data.userEmail);
      safePrint('[onSignUp Result] : SUCCESS!');
      return '';
    } on AuthException catch (e) {
      safePrint('[onSignUp Result] : $e');
      return e.message;
    }
  }

  @override
  Future<String> onLogin(User data, BuildContext context) async {
    try {
      // 로그인 실시
      SignInResult res = await Amplify.Auth.signIn(
          username: data.userEmail, password: data.password);

      bool isSignedIn = res.isSignedIn;
      safePrint('Successfully Login in Amplify? : $isSignedIn');

      // 정상적인 로그인으로 확인되지 않음.
      if(isSignedIn == false){
        throw Exception('Unconfirmed.');
      }

      // DB에 로그인 등록
      bool saveDB = await Provider.of<AppDataProvider>(context, listen: false).updateUser('login',data.userEmail);

      // 정상적으로 DB에 등록되지 않음.
      if(saveDB == false){
        // cognito에서 로그아웃하고 예외처리
        onLogout(context, onlyAmplify: true);
        throw Exception('Error in DB. Try again.');
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
  Future<String> onLogout(BuildContext context, {bool onlyAmplify = false}) async {
    try{
      bool result = false;
      if(onlyAmplify == false){ // Amplify & DB 둘 다 해야할 때
        result = await Provider.of<AppDataProvider>(context, listen: false).updateUser('logout',await getCurrentUserEmail());
        if(result == false) return 'Err in DB. User Not Found.'; // DB에 문제가 생겼을 때
      }
      await Amplify.Auth.signOut();
      return ''; // 문제가 없다면 여기로 넘어옴
    } catch (error){
      return 'Err in Amplify.'; // Amplify에 문제가 생겼을 때
    }
  }

  @override
  Future<String> onDeleteAccount(BuildContext context) async {
    try{
      bool result = false;
      result = await Provider.of<AppDataProvider>(context, listen: false).updateUser('remove',await getCurrentUserEmail());
      if(result == false) return 'Err in DB. User Not Found.'; // DB에 문제가 생겼을 때

      await Amplify.Auth.deleteUser();
      return ''; // 문제가 없다면 여기로 넘어옴
    } catch (error){
      return 'Err in Amplify.'; // Amplify에 문제가 생겼을 때
    }
  }

  @override
  Future<String> verifyCode(User data, String code, BuildContext context) async {
    safePrint('email: ${data.userEmail}, code: "+$code');
    String result = "Unknown Error. Try again.";
    try {
      // DB에 회원가입 등록
      bool saveDB = await Provider.of<AppDataProvider>(context, listen: false).updateUser('add',data.userEmail);

      // 정상적으로 DB에 등록되지 않음.
      if(saveDB == false){
        // cognito에서 회원탈퇴하고 예외처리
        // onDeleteAccount(context);
        throw Exception('Error in DB. Try again.');
      }

      SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: data.userEmail, confirmationCode: code);

      bool isSignedUp = res.isSignUpComplete;

      if(isSignedUp == false){
        throw Exception('Unconfirmed.');
      }

      // 회원 가입 성공!!
      safePrint('SIGNUP SUCCESS!');
      result = '';
    } on AuthException catch (e) {
      // 에러 핸들링
      result = e.message;
    } on Exception catch (e) {
      safePrint('[onSignUp Result] : $e');
      return e.toString();
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
      safePrint('[getCurrentUserEmail]: $username');
      if (authUser != null) {
        return username;
      }
    } catch (e) {
      safePrint("Error fetching current user: $e");
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
    // safePrint('[AccessToken]: $accessToken');
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
    String signUpResult = await onSignUp(appUserData, context);
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
  Future<Map<String, dynamic>?> loginProcess(User appUserData, BuildContext context) async {
    // errorMessage 2쌍을 저장해서 반환할 결과
    Map<String, dynamic> result = {
      'errorMessageEmail': "",
      'errorMessagePassword': "",
    };

    safePrint('LOGIN!');
    String loginResult = await onLogin(appUserData, context);
    // 로그인 성공
    if (loginResult == '') {
      HomeDrawer.userID = (await getCurrentUserEmail()).split('@')[0];
      return null;
    }
    // 로그인 실패. 사유 작성해서 반환.
    else {
      result['errorMessageEmail'] = loginResult;
      return result;
    }
  }
}