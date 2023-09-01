import 'package:flutter/material.dart';

class InternetCheckPopup extends StatelessWidget {
  const InternetCheckPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning,
              color: Colors.orange,
              size: 48.0,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25.0),
            const Text(
              'Please check your internet connection and try again.',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25.0),
            ElevatedButton(
              onPressed: () {
                // Add any action you want to perform when the user clicks a button (if needed).
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}