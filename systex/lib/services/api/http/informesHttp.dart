import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:systex/config.dart';
import 'package:systex/models/informes.dart';
import 'package:systex/models/solicitudes_aprobadas.dart';
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

  @override
  Future<String> addInforme(String lote, String nombreMuestra, String productor,
      List<int> pdfInforme, String nombreAnalisis) async {
    String url = pathUrlBase + 'api/informes/addInforme';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Agregar los bytes del PDF como una parte de la solicitud
    request.files.add(http.MultipartFile(
      'pdfInforme',
      http.ByteStream.fromBytes(pdfInforme),
      pdfInforme.length,
      filename: 'report.pdf',
    ));

    // Agregar los otros datos en el cuerpo de la solicitud
    request.fields['lote'] = lote;
    request.fields['nombre_muestra'] = nombreMuestra;
    request.fields['productor'] = productor;
    request.fields['nombre_analisis'] = nombreAnalisis;

    String responseServer = "";

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        responseServer = "Informe guardado";
        print('OK!');
      } else {
        responseServer = "No se pudo guardar el informe";
        print(response.toString());
        print(
            'Error en la solicitud HTTP. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud HTTP: $error');
    }

    return responseServer;
  }
}
