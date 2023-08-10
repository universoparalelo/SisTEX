import 'dart:convert';

import 'package:systex/config.dart';
import 'package:systex/models/parametro.dart';
import 'package:systex/services/api/repositores/parametrosRepository.dart';
import 'package:http/http.dart' as http;

class ParametrosHttp implements ParametrosRepository {
  @override
  Future<void> addParametro(String nombreParametro) async {
    // TODO: implement addParametro
    throw UnimplementedError();
  }

  @override
  Future<List<Parametro>> getAllParametros() async {
    String url = pathUrlBase + 'api/parametros/get';

    var resp = await http.get(Uri.parse(url));
    List<Parametro> parametros = [];
    if (resp.statusCode == 200) {
      List<Map<String, dynamic>> jsonMap =
          List<Map<String, dynamic>>.from(jsonDecode(resp.body));
      print('jsmap' + jsonMap.toString());
      for (int i = 0; i <= jsonMap.length - 1; i++) {
        Parametro parametro = Parametro.fromJson(jsonMap[i]);
        parametros.add(parametro);
      }
    }
    return parametros;
  }
}
