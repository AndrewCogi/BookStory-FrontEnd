import 'package:book_story/popup/internet_check_popup.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class InternetConnectivity {
  static Future<bool> check() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const InternetCheckPopup();
      },
    );
  }
}
