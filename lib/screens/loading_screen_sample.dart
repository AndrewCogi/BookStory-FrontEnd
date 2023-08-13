import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  static bool isComplete = false;
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  void _loginButtonPressed() {
    // Show loading screen and deactivate the main content
    setState(() {
      LoadingScreen.isComplete = true;
    });

    safePrint("processing...");
    setState(() {
      LoadingScreen.isComplete = false;
    });

    // Simulate login process
    Future.delayed(Duration(seconds: 5), () {
      // Once login is complete, hide loading screen and activate main content
      setState(() {
        LoadingScreen.isComplete = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Stack(
        children: [
          // Main content
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loginButtonPressed,
                  child: Text('Login'),
                ),
              ],
            ),
          ),
          // Loading screen
          if (LoadingScreen.isComplete)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}