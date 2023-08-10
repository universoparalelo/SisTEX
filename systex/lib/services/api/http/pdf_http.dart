import 'dart:typed_data';

import 'package:systex/services/api/repositores/pdfRepository.dart';
import 'package:http/http.dart' as http;

class PDFHttp implements PDFRepository {
  @override
  Future<Uint8List> loadImageFromUrl(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image from URL');
    }
  }
}
