import 'package:amplify_core/amplify_core.dart';
import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/models/app_user.dart';
import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:book_story/pages/screens/verification_screen.dart';
import 'package:book_story/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isComplete = true;
  bool isObscure = true;
  String errorMessageEmail = "";
  String errorMessagePassword = "";
  AppUser? appUserData;
  final AuthController _authController = AuthControllerImpl();
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
        title: const Text('Welcome!',),
      ),
      body: Stack(
        children: [
          Padding(
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
                          onPressed: () {
                            _cognitoButtonPressed(CognitoIndex.login);
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
                            _cognitoButtonPressed(CognitoIndex.signup);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text('Sign Up',),
                        ),
                      ],
                    ),

                    const SizedBox(height: 80.0),
                    const Row(
                      children: [
                        Expanded(child: Divider(thickness: 2.0)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Or login with',),
                        ),
                        Expanded(child: Divider(thickness: 2.0)),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (await HelperFunctions.internetConnectionCheck()) {
                            // TODO : 구글로그인으로 이동
                          } else {
                            // ignore: use_build_context_synchronously
                            HelperFunctions.showNoInternetDialog(context);
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
          if(isComplete == false)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),

    );
  }

  Future<void> _cognitoButtonPressed(CognitoIndex cognitoIndex) async {
    // init AppUser
    appUserData = AppUser(email: _emailController.text, password: _passwordController.text);

    // clear errorMessages
    setState(() {
      errorMessageEmail = "";
      errorMessagePassword = "";
    });

    // Login process... (if done, automatically activate the main content)
    if(cognitoIndex == CognitoIndex.login){
      Map<String,dynamic>? result = await _authController.verificationProcessIDPW(context,appUserData!);
      // 로그인을 시도해봐도 좋음!
      if(result == null){
        // Show loading screen and deactivate the main content
        setState(() {
          isComplete = false;
        });
        // 로그인 실시!
        Map<String,dynamic>? result = await _authController.loginProcess(appUserData!);
        // 로그인 성공
        if(result == null){
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Complete')));
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          setState(() {
            HomeDrawer.isLogin = true;
            HomeDrawer.userEmail = appUserData!.email;
          });
        }
        // 로그인 실패
        else {
          setState(() {
            errorMessageEmail = result['errorMessageEmail'];
            errorMessagePassword = result['errorMessagePassword'];
          });
        }
        // 모든 절차가 완료되었으니, active하게 변경
        setState(() {
          isComplete = true;
        });
      }
      // 로그인을 시도하기에 적합하지 않은 문자열임.
      else {
        setState(() {
          errorMessageEmail = result['errorMessageEmail'];
          errorMessagePassword = result['errorMessagePassword'];
        });
      }
    }
    // SignUp process... (if done, automatically activate the main content)
    else if(cognitoIndex == CognitoIndex.signup){
      Map<String,dynamic>? result = await _authController.verificationProcessIDPW(context,appUserData!);
      // 회원가입을 시도해봐도 좋음!
      if(result == null) {
        // Show loading screen and deactivate the main content
        setState(() {
          isComplete = false;
        });
        // 회원가입 실시!
        Map<String, dynamic>? result = await _authController.signUpProcess(appUserData!);
        // 회원가입 성공
        if(result == null){
          // ignore: use_build_context_synchronously
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => VerificationScreen(appUserData!),
            ),
          );
        }
        // 회원가입 실패
        else{
          setState(() {
            errorMessageEmail = result['errorMessageEmail'];
            errorMessagePassword = result['errorMessagePassword'];
          });
        }
        // 모든 절차가 완료되었으니, active하게 변경
        setState(() {
          isComplete = true;
        });
      }
      // 회원가입을 시도하기에 적합하지 않은 문자열임.
      else {
        setState(() {
          errorMessageEmail = result['errorMessageEmail'];
          errorMessagePassword = result['errorMessagePassword'];
        });
      }
    }

    // Waiting login process
    Future.delayed(const Duration(seconds: 10), () {
      if(isComplete == false) {
        // Once login is complete, hide loading screen and activate main content
        setState(() {
          isComplete = true;
        });
      }
    });
  }
}

enum CognitoIndex{
  login,
  signup,
}