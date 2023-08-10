import 'dart:convert';

import 'package:systex/config.dart';
import 'package:systex/models/tipos_muestras.dart';
import 'package:systex/services/api/repositores/tipomuestrasRepository.dart';
import 'package:http/http.dart' as http;

class TipoMuestrasHttp implements TipoMuestrasRepository {
  @override
  Future<List<TipoMuestras>> getAllTiposAnalisis() async {
    String url = pathUrlBase + 'api/tipomuestras';

    var resp = await http.get(Uri.parse(url));
    List<TipoMuestras> tipos_analisis = [];
    if (resp.statusCode == 200) {
      print('rby67' + resp.body);
      List<Map<String, dynamic>> jsonMap =
          List<Map<String, dynamic>>.from(jsonDecode(resp.body));

      for (int i = 0; i <= jsonMap.length - 1; i++) {
        TipoMuestras analisis = TipoMuestras.fromJson(jsonMap[i]);
        tipos_analisis.add(analisis);
      }
    } else {
      print('code' + resp.body);
    }
    return tipos_analisis;
  }

  @override
  Future<String> updateAnalisis(TipoMuestras tipomuestras) async {
    String idTipoMuestra = tipomuestras.idTipoMuestra;
    Map<String, dynamic> map = tipomuestras.toMap();
    String url =
        pathUrlBase + 'api/tipomuestras/updateTipoMuestra/$idTipoMuestra';

    var resp = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: json.encode(map),
    );
    if (resp.statusCode == 200) {
      return "Analisis actualizado!";
    } else {
      return "Error. No se pudo actualizar el analisis";
    }
  }
}
