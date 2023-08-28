import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  static bool isComplete = false;

  const LoadingScreen({super.key});
  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {

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
    Future.delayed(const Duration(seconds: 10), () {
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
        title: const Text('Login Page'),
      ),
      body: Stack(
        children: [
          // Main content
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TextField(
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 10),
                const TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loginButtonPressed,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
          // Loading screen
          if (LoadingScreen.isComplete)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}