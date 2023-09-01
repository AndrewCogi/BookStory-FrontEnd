
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:book_story/amplifyconfiguration.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/models/app_user.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:book_story/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';

class AuthControllerImpl implements AuthController {

  @override
  void configureAmplify() async {
    bool configured = false;
    final auth = AmplifyAuthCognito();
    final analytics = AmplifyAnalyticsPinpoint();

    try{
      Amplify.addPlugins([auth, analytics]);
      await Amplify.configure(amplifyconfig);
      configured = true;
    } catch(e) {
      safePrint(e);
    }

    if(configured){
      safePrint('Successfully configured Amplify!');
      safePrint('Check auth state...');
      HomeDrawer.isLogin = await checkAuthState();
      safePrint("HomeDrawer.isLogin : ${await checkAuthState()}");
    }
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
      return '';
    } on AuthException catch (e) {
      safePrint(e);
      return '${e.message}\n${e.recoverySuggestion}';
    }
  }

  @override
  Future<String> onLogin(AppUser data) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
          username: data.email, password: data.password);

      bool isSignedIn = res.isSignedIn;
      safePrint('Login? : $isSignedIn');

      await recordLogin(data.email);
    } on AuthException catch (e) {
      // 이미 접속중인 아이디의 경우, 자동 로그아웃 실시
      if (e.message.startsWith("There is already a user signed in")) {
        onLogout(data.email);
      }
      return e.message;
    }
    return '';
  }

  @override
  Future<bool> onLogout(String userEmail) async {
    // await _recordLogout(userEmail);
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
    safePrint(['IdToken: $idToken']);
    String? accessToken = (result as CognitoAuthSession).userPoolTokensResult.valueOrNull?.accessToken.raw;
    safePrint(['IdTokenEmail: $accessToken']);
    // String? identityId = (result as CognitoAuthSession)
    //     .userPoolTokensResult
    //     .valueOrNull
    //     ?.idToken
    //     .raw;
    return 'testing';
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

  // TODO : 이 요청이 필요할까? 그리고 에러 문자열로 찾는거 버전 업데이트되니까 싹 바뀌어버렸다. 다른 방법(e.message 등)을 찾고 적용하자..
  @override
  Future<Map<String, dynamic>?> stringValidCheckProcess(BuildContext context, AppUser appUserData) async {
    // errorMessage 2쌍을 저장해서 반환할 결과
    Map<String, dynamic> result = {
      'errorMessageEmail': "",
      'errorMessagePassword': "",
    };
    // internet connection valid
    if (await HelperFunctions.internetConnectionCheck()) {
      safePrint("email: ${appUserData.email}, pw: ${appUserData.password}");
      // 형식 체크
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
    }
    // internet connection invalid
    else {
      // ignore: use_build_context_synchronously
      HelperFunctions.showNoInternetDialog(context);
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
    if(signUpResult == ''){
      return null;
    }
    // 회원가입 실패. 사유 작성해서 반환.
    else{
      // 이미 존재하는 아이디
      if(signUpResult.startsWith("Username already exists in the system")){
        result['errorMessageEmail'] = "This user already exists in the system.";
      }
      // 아이디 or 비번의 입력값이 잘못됨. 어딘가 비어있음
      if(signUpResult.startsWith("One or more parameters are incorrect")){
        // ID field empty
        if(appUserData.email == ""){
          result['errorMessageEmail'] = "Enter Email.";
        }
        // PW field empty
        if(appUserData.password == ""){
          result['errorMessagePassword'] = "Enter Password.";
        }
      }
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
      // 이미 접속중인 아이디 (하나의 기기에서 중복 접속할 경우 발생)
      if (loginResult.startsWith("There is already a user signed in")) {
        result['errorMessageEmail'] = "Problem logging in. Please try again.";
      }
      // 아이디 or 비번의 입력값이 잘못됨. 어딘가 비어있음.
      if (loginResult.startsWith("One or more parameters are incorrect")) {
        // ID is empty
        if (appUserData.email == "") {
          result['errorMessageEmail'] = "Enter Email.";
        }
        // PW is empty
        if (appUserData.password == "") {
          result['errorMessagePassword'] = "Enter Password.";
        }
      }
      // 비밀번호가 틀렸음
      if (loginResult.startsWith("Failed since user is not authorized")) {
        result['errorMessageEmail'] = "Wrong password.";
      }
      // 등록된 아이디가 아님
      if (loginResult.startsWith("User not found in the system")) {
        result['errorMessageEmail'] =
        "This account is not registered. Sign up!";
      }
      // 이메일 인증이 안됨
      if (loginResult.startsWith("User not confirmed in the system")) {
        result['errorMessageEmail'] = "This account is not verification.";
      }
      return result;
    }
  }
}