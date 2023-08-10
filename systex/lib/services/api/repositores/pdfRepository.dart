import 'dart:typed_data';

abstract class PDFRepository {
  Future<Uint8List> loadImageFromUrl(String url);
}
