import 'dart:convert';

import 'package:systex/config.dart';
import 'package:systex/models/muestras.dart';
import 'package:systex/services/api/repositores/muestrasRepository.dart';
import 'package:http/http.dart' as http;

class MuestrasHttp implements MuestrasRepository {
  @override
  Future<List<Muestras>> getAllMuestras() async {
    String url = pathUrlBase + 'api/muestras';
    List<Muestras> muestras = [];
    var resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      List<Map<String, dynamic>> jsonMap =
          List<Map<String, dynamic>>.from(jsonDecode(resp.body));
      for (int i = 0; i <= jsonMap.length - 1; i++) {
        Muestras muestra = Muestras.fromJson(jsonMap[i]);
        muestras.add(muestra);
      }
      print('cod' + resp.body);
    } else {
      print('pq123' + resp.body.toString());
    }
    return muestras;
  }
}
