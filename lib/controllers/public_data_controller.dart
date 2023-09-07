import 'dart:typed_data';

abstract class PublicDataController {
  Future<Uint8List?> fetchBookImage(String imageUrl);
}