import 'dart:convert';

import 'package:intl/intl.dart';
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

  @override
  Future<String> postMuestra(
      String nombreElaborador,
      String fechaElaboracion,
      String lote,
      String tipoMuestra,
      String estilo,
      String nombreMuestra) async {
    String url = pathUrlBase + 'api/muestras/addMuestra';
    Map<String, dynamic> data = {};
    data["nombre_muestra"] = nombreMuestra;
    data["lote"] = lote;
    data["nombre_productor"] = nombreElaborador;
    data["fecha_elaboracion"] = fechaElaboracion;
    DateTime now = DateTime.now();

    // Formateamos la fecha en el formato deseado (dd/mm/yyyy)
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    data["fecha_ingreso"] = formattedDate;
    data["tipo_muestra"] = tipoMuestra;
    data["estilo"] = estilo;

    var resp = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data));
    print('respuesta:' + resp.body.toString());
    return resp.body;
  }

  @override
  Future<Muestras> getInfoMuestra(String idMuestra) async {
    String url =
        pathUrlBase + 'api/muestras/searchMuestraByID?idMuestra=$idMuestra';
    print('idme' + url);
    var resp = await http.get(
      Uri.parse(url),
    );
    Muestras muestras = Muestras(
        idMuestra: "idMuestra",
        nombreMuestra: "nombreMuestra",
        lote: "lote",
        idElaborador: "idElaborador",
        fechaElaboracion: "fechaElaboracion",
        fechaIngreso: "",
        tipoMuestra: "tipoMuestra",
        estilo: "estilo");
    if (resp.statusCode == 200) {
      // La solicitud fue exitosa, entonces decodificamos la respuesta JSON
      List<dynamic> responseData = jsonDecode(resp.body);

      // Mapeamos los datos JSON a objetos Productor y los almacenamos en una lista
      List<Muestras> muestrasList =
          responseData.map((item) => Muestras.fromJson(item)).toList();

      // Devolvemos la lista de productores
      muestras = muestrasList[0];
    }
    print('muestraN' + muestras.nombreMuestra);
    return muestras;
  }
}
