import 'package:book_story/utils/internet_check_service.dart';
import 'package:flutter/material.dart';
import '../utils/auth_service.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen(this.authData, {super.key});

  final AuthService authData;

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  bool isObscure = true;
  String errorMessageVerificationCode = "";
  final TextEditingController _verificationCodeController = TextEditingController();

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
        title: const Text('Email Verification'),
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
                      onPressed: () async {
                        if (await InternetConnectivity.check()) {
                          // clear textField
                          setState(() {
                            errorMessageVerificationCode = "";
                          });
                          // verification
                          String result = await verifyCode(widget.authData, _verificationCodeController.text);
                          // if failed
                          if(result!=""){
                            setState(() {
                              // code가 일치하지 않음
                              if(result.startsWith("Confirmation code entered is not correct")){
                                errorMessageVerificationCode = "Confirmation code is not correct.";
                              }
                              // code칸이 비었음
                              if(result.startsWith("One or more parameters are incorrect")){
                                errorMessageVerificationCode = "Enter verification code.";
                              }
                            });
                          }
                          // success!
                          else{
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        } else {
                          // ignore: use_build_context_synchronously
                          InternetConnectivity.showNoInternetDialog(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Verify'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

