import 'package:flutter/material.dart';

class RecordTipsPopup extends StatelessWidget {
  const RecordTipsPopup({super.key});

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
              'Please record in a quiet place.',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16.0),
            const Text(
              'The recorded sentences are 100 sentences in total.',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'If you leave during recording, you will have to record again.',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Please read with your child in mind.',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
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