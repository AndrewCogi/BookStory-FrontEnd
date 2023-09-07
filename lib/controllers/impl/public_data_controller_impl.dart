import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:book_story/controllers/public_data_controller.dart';

class PublicDataControllerImpl implements PublicDataController{
  @override
  Future<Uint8List?> fetchBookImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load photo');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}