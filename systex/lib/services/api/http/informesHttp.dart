import 'dart:convert';

import 'package:systex/config.dart';
import 'package:systex/models/informes.dart';
import 'package:systex/services/api/repositores/informesRepository.dart';
import 'package:http/http.dart' as http;

class InformesHttp implements InformesRepository {
  @override
  Future<List<Informes>> getInformes() async {
    String url = pathUrlBase + 'api/informes';

    var resp = await http.get(Uri.parse(url));
    List<Informes> informes = [];
    if (resp.statusCode == 200) {
      List<Map<String, dynamic>> jsonMap =
          List<Map<String, dynamic>>.from(jsonDecode(resp.body));
      print('jsmap' + jsonMap.toString());
      for (int i = 0; i <= jsonMap.length - 1; i++) {
        Informes informe = Informes.fromJson(jsonMap[i]);
        informes.add(informe);
      }
    } else {
      print('ad443' + resp.body.toString());
    }

    print('infomr' + informes[0].fecha);

    return informes;
  }
}
