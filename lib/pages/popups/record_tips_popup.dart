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
              Icons.tips_and_updates_rounded,
              color: Colors.orange,
              size: 48.0,
            ),
            const SizedBox(height: 16.0),
            const Text(
              '조용한 곳에서 녹음해 주세요.',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16.0),
            const Text(
              '녹음은 총 12문장에 대해 진행됩니다.',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            const Text(
              '문장을 정확히 읽어주셔야\n 다음 문장으로 넘어가실 수 있습니다.',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            const Text(
              '아이에게 읽어주듯이 녹음해 주세요.',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
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