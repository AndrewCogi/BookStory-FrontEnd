import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AuthService{
  final String name;
  final String password;

  AuthService({required this.name, required this.password});
}

Future<String> onSignUp(AuthService data) async {
  AuthService _loginData = data;
  try{
    await Amplify.Auth.signUp(
      username: _loginData.name,
      password: _loginData.password,
      options: CognitoSignUpOptions(userAttributes: {CognitoUserAttributeKey.email: _loginData.name})
    );
    return '';
  } on AuthException catch(e){
    print(e);
    return '${e.message} - ${e.recoverySuggestion}';
  }
}

