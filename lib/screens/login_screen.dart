import 'package:book_story/utils/internet_check_service.dart';
import 'package:flutter/material.dart';
import '../utils/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;
  late AuthService loginData;
  String errorMessageEmail = "";
  String errorMessagePassword = "";
  final FocusNode _secondTextFieldFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState(){
    loginData = AuthService(email: _emailController.text, password: _passwordController.text);
    super.initState();
  }

  @override
  void dispose(){
    _secondTextFieldFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Welcome!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              const BorderRadius.all(Radius.circular(0.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    offset: const Offset(4, 4),
                    blurRadius: 8.0),
              ],
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const Text(
                //   "Authenticate",
                //   style: TextStyle(
                //     fontSize: 24.0,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const Icon(Icons.local_library, color: Colors.blue, size: 150),
                const SizedBox(height: 20.0),
                Text(
                  errorMessageEmail,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_secondTextFieldFocus);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  errorMessagePassword,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _secondTextFieldFocus,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: isObscure ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          if(isObscure==true) {
                            isObscure=false;
                          } else {isObscure=true;}
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    // Navigate to the forgot password screen
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (await InternetConnectivity.check()) {
                          print('name: '+_emailController.text+", pw: "+_passwordController.text);
                          AuthService authService = AuthService(email: _emailController.text, password: _passwordController.text);
                          onLogin(authService);
                          // TODO : _signUp() / _login() -> 로그인 예외처리 & 로그인 후 email verification 창 만들기
                        } else {
                          InternetConnectivity.showNoInternetDialog(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        _signUpProcess();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),

                const SizedBox(height: 80.0),
                const Row(
                  children: [
                    Expanded(child: Divider(thickness: 2.0)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Or login with'),
                    ),
                    Expanded(child: Divider(thickness: 2.0)),
                  ],
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await InternetConnectivity.check()) {
                        // TODO : 구글로그인으로 이동
                      } else {
                        InternetConnectivity.showNoInternetDialog(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.lightGreen,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle),
                        SizedBox(width: 10.0),
                        Text('Sign in with Google',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUpProcess() async {
    // internet connection valid
    if (await InternetConnectivity.check()) {
      // clear errorMessage
      setState(() {
        errorMessageEmail = "";
        errorMessagePassword = "";
      });
      print('name: '+_emailController.text+", pw: "+_passwordController.text);
      AuthService authService = AuthService(email: _emailController.text, password: _passwordController.text);
      String result = await onSignUp(authService);

      // TODO: 사용 가능한 아이디와 비밀번호라면, Verification code 입력창으로 이동
      if(result == '') {

      }
      // 어딘가 잘못됨
      else {
        setState(() {
          // 이미 존재하는 아이디
          if(result.startsWith("Username already exists in the system")){
            errorMessageEmail = "Username already exists in the system.";
          }
          // 아이디 or 비번의 입력값이 잘못됨.
          else if(result.startsWith("One or more parameters are incorrect")){
            // 아이디 필드 비어있는지 확인
            if(_emailController.text == "" || _passwordController.text == ""){
              // ID field empty
              if(_emailController.text == ""){
                errorMessageEmail = "Enter Email.";
              }
              // PW field empty
              if(_passwordController.text == ""){
                errorMessagePassword = "Enter Password.";
              }
            }
            else{
              // 이메일 형식 확인
              if(!isEmailValid(authService.email)){
                errorMessageEmail = "Check your email format.";
              }
            }
          }
          // 비번의 형식이 잘못됨
          else if(result.startsWith("The password given is invalid")){
            // 암호 형식 확인
            errorMessagePassword = isPasswordValid(authService.password);
          }
        });
      }
    }
    // internet connection invalid
    else {
      InternetConnectivity.showNoInternetDialog(context);
    }
  }

  bool isEmailValid(String email) {
    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegExp.hasMatch(email);
  }

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
}


