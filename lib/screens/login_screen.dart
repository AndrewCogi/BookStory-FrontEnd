import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/custom_drawer/home_drawer.dart';
import 'package:book_story/screens/verification_screen.dart';
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
  String errorMessageEmail = "";
  String errorMessagePassword = "";
  final FocusNode _secondTextFieldFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState(){
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
                        _loginProcess();
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
                        // ignore: use_build_context_synchronously
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

  void _loginProcess() async {
    // onLogin()을 실시해도 되는지를 저장
    bool isValid = false;
    // internet connection valid
    if (await InternetConnectivity.check()) {
      safePrint("name: ${_emailController.text}, pw: ${_passwordController.text}");
      AuthService authService = AuthService(email: _emailController.text, password: _passwordController.text);
      setState(() {
        // clear errorMessage
        errorMessageEmail = "";
        errorMessagePassword = "";
        // 형식 체크
        String isPasswordValidResult = isPasswordValid(authService.password);
        if(isEmailValid(authService.email) == false || isPasswordValidResult != ""){
          // 이메일 형식 체크
          if(isEmailValid(authService.email) == false){
            errorMessageEmail = "Check your email format.";
          }
          // 비번 형식 체크
          if(isPasswordValidResult != ""){
            errorMessagePassword = isPasswordValidResult;
          }
        }
        else{
          // go!
          isValid = true;
        }
      });

      // Login 실시해도 되는가?
      if(isValid){
        safePrint('LOGIN!');
        String result = await onLogin(authService);
        // Login 성공!
        if(result == '') {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          setState(() {
            HomeDrawer.isLogin = true;
            HomeDrawer.userEmail = authService.email;
          });
        }
        // onLogin()함수에서 어딘가 잘못됨
        else {
          setState(() {
            // 이미 접속중인 아이디 TODO:stateless connection인데 이게 왜 떴지?.. 중복로그인이 가능하도록 하는게 좋을듯. (한 계정으로 엄마아빠 같이쓰기. 아이가 여럿일수도 있고!)
            if(result.startsWith("There is already a user signed in")){
              errorMessageEmail = "There is already a user signed in.";
            }
            // 아이디 or 비번의 입력값이 잘못됨.
            if(result.startsWith("One or more parameters are incorrect")){
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
            }
            // 비밀번호가 틀렸음
            if(result.startsWith("Failed since user is not authorized")){
              errorMessageEmail = "Wrong password - Try Again.";
            }
            // 등록된 아이디가 아님
            if(result.startsWith("User not found in the system")){
              errorMessageEmail = "This account is not registered. Sign up!";
            }
            // 이메일 인증이 안됨
            if(result.startsWith("User not confirmed in the system")){
              errorMessageEmail = "This account is not verification.";
            }
          });
        }
      }
    }
    // internet connection invalid
    else {
      // ignore: use_build_context_synchronously
      InternetConnectivity.showNoInternetDialog(context);
    }
  }

  void _signUpProcess() async {
    // onSignUp()을 실시해도 되는지를 저장
    bool isValid = false;
    // internet connection valid
    if (await InternetConnectivity.check()) {
      // get input (email + password)
      safePrint('INPUT CHECK - email: '+_emailController.text+", pw: "+_passwordController.text);
      AuthService authService = AuthService(email: _emailController.text, password: _passwordController.text);
      setState(() {
        // clear errorMessage
        errorMessageEmail = "";
        errorMessagePassword = "";
        // 형식 체크
        String isPasswordValidResult = isPasswordValid(authService.password);
        if(isEmailValid(authService.email) == false || isPasswordValidResult != ""){
          // 이메일 형식 체크
          if(isEmailValid(authService.email) == false){
            errorMessageEmail = "Check your email format.";
          }
          // 비번 형식 체크
          if(isPasswordValidResult != ""){
            errorMessagePassword = isPasswordValidResult;
          }
        }
        else{
          // go!
          isValid = true;
        }
      });

      // Authenticate 실시해도 되는가?
      if(isValid){
        safePrint('AUTH!');
        String result = await onSignUp(authService);
        // Authenticate 성공!
        if(result == '') {
          // ignore: use_build_context_synchronously
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => VerificationScreen(authService),
            ),
          );
        }
        // onSignUp()함수에서 어딘가 잘못됨
        else {
          setState(() {
            // 이미 존재하는 아이디
            if(result.startsWith("Username already exists in the system")){
              errorMessageEmail = "This user already exists in the system.";
            }
            // 아이디 or 비번의 입력값이 잘못됨.
            if(result.startsWith("One or more parameters are incorrect")){
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
            }
          });
        }
      }
    }
    // internet connection invalid
    else {
      // ignore: use_build_context_synchronously
      InternetConnectivity.showNoInternetDialog(context);
    }
  }

  bool isEmailValid(String email) {
    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w.-]+@[\w\.-]+\.\w+$');
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


