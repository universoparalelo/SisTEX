import 'dart:convert';

import 'package:systex/config.dart';
import 'package:systex/models/personal.dart';
import 'package:systex/services/api/repositores/personalRepository.dart';
import 'package:http/http.dart' as http;

class PersonalHttp extends PersonalRepository {
  @override
  Future<List<Personal>> getPersonal() async {
    List<Personal> personal = [];
    String url = pathUrlBase + 'api/personal/get';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      // La solicitud fue exitosa, entonces decodificamos la respuesta JSON
      List<dynamic> responseData = jsonDecode(resp.body);

      // Mapeamos los datos JSON a objetos Productor y los almacenamos en una lista

      List<Personal> _personal =
          responseData.map((item) => Personal.fromJson(item)).toList();

      // Devolvemos la lista de productores
      personal = _personal;
    }
    return personal;
  }
}
