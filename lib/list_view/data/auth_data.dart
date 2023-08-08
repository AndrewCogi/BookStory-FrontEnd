import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class LoginData{
  final String name;
  final String password;

  LoginData({required this.name, required this.password});
}

Future<String> _onSignUp(LoginData data) async {
  try{
    await Amplify.Auth.signUp(
      username: data.name,
      password: data.password,
      options: CognitoSignUpOptions(userAttributes: {CognitoUserAttributeKey.email: data.name})
    );
    return '';
  } on AuthException catch(e){
    return '${e.message} - ${e.recoverySuggestion}';
  }
}