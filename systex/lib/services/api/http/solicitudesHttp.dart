import 'dart:convert';

import 'package:systex/config.dart';
import 'package:systex/models/solicitudes.dart';
import 'package:systex/services/api/repositores/solicitudesRepository.dart';
import 'package:http/http.dart' as http;

class SolicitudesHttp implements SolicitudesRepository {
  @override
  Future<List<Solicitudes>> getAllSolicitudes() async {
    String url = pathUrlBase + 'api/solicitudes';

    var resp = await http.get(Uri.parse(url));
    List<Solicitudes> solicitudes = [];
    if (resp.statusCode == 200) {
      print('jmap' + resp.body);
      List<Map<String, dynamic>> jsonMap =
          List<Map<String, dynamic>>.from(jsonDecode(resp.body));
      print('jsmap' + jsonMap.toString());
      for (int i = 0; i <= jsonMap.length - 1; i++) {
        Solicitudes solicitud = Solicitudes.fromJson(jsonMap[i]);
        solicitudes.add(solicitud);
      }
    } else {
      print('error13' + resp.body.toString());
    }

    return solicitudes;
  }
}
