import 'package:book_story/controllers/auth_controller.dart';
import 'package:book_story/controllers/impl/auth_controller_impl.dart';
import 'package:book_story/models/app_user.dart';
import 'package:book_story/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen(this.appUserData, {super.key});

  final AppUser appUserData;

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  bool isComplete = true;
  bool isObscure = true;
  String errorMessageVerificationCode = "";
  final TextEditingController _verificationCodeController = TextEditingController();
  final AuthController _authController = AuthControllerImpl();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Text('Email Verification',),
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
                padding: const EdgeInsets.all(80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_user_rounded, color: Colors.blue, size: 150),
                    const SizedBox(height: 20.0),
                    Text(
                      errorMessageVerificationCode,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _verificationCodeController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        hintText: 'Enter confirmation code',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the forgot password screen
                      },
                      child: const Text(
                        'Resend code',
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
                            _verificationButtonPressed();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text('Verify',),
                        ),
                      ],
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

  // TODO : auth_controller로 이전하는 작업 해야함.
  void _verificationButtonPressed() async {
    // Show loading screen and deactivate the main content
    setState(() {
      isComplete = false;
    });

    _verificationProcess();

    // Waiting verification process
    Future.delayed(const Duration(seconds: 10), () {
      if(isComplete == false) {
        // Once verification is complete, hide loading screen and activate main content
        setState(() {
          isComplete = true;
        });
      }
    });
  }

  void _verificationProcess() async {
    if (await HelperFunctions.internetConnectionCheck()) {
      // clear textField
      setState(() {
        errorMessageVerificationCode = "";
      });
      // verification
      String result = await _authController.verifyCode(widget.appUserData, _verificationCodeController.text);
      // if failed
      if(result!=""){
        setState(() {
          errorMessageVerificationCode = result;
        });
      }
      // success!
      else{
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign Up Complete')));
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } else {
      // ignore: use_build_context_synchronously
      HelperFunctions.showNoInternetDialog(context, false);
    }

    // 모든 과정이 끝났으면 해제
    setState(() {
      isComplete = true;
    });
  }
}


