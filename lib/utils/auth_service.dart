import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AuthService{
  final String email;
  final String password;

  AuthService({required this.email, required this.password});
}

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
    print(e);
    return '${e.message}\n${e.recoverySuggestion}';
  }
}

Future<String> onLogin(AuthService loginData) async {
  try {
    SignInResult res = await Amplify.Auth.signIn(
        username: loginData.email, password: loginData.password);

    bool isSignedIn = res.isSignedIn;
    print('Login? : $isSignedIn');
  } on AuthException catch (e) {
    if (e.message.contains('already a user which is signed in')) {
      await Amplify.Auth.signOut();
      return 'Problem logging in. Please try again.';
    }

    return '${e.message} - ${e.recoverySuggestion}';
  }
  return '';
}

