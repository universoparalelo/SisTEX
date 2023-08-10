import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:systex/config.dart';
import 'package:systex/models/solicitudes.dart';
import 'package:systex/models/solicitudes_aprobadas.dart';
import 'package:systex/models/solicitudes_rechazadas.dart';
import 'package:systex/screens/home/home.dart';
import 'package:systex/services/api/http/muestrasHttp.dart';
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

  @override
  Future<List<SolicitudesAprobadas>> getAllSolicitudesAprobadas() async {
    String url = pathUrlBase + 'api/solicitudes/aprobadas';

    var resp = await http.get(Uri.parse(url));
    List<SolicitudesAprobadas> solicitudes = [];
    if (resp.statusCode == 200) {
      print('jmap' + resp.body);
      List<Map<String, dynamic>> jsonMap =
          List<Map<String, dynamic>>.from(jsonDecode(resp.body));
      print('jsmap' + jsonMap[0].toString());
      for (int i = 0; i <= jsonMap.length - 1; i++) {
        SolicitudesAprobadas solicitud =
            SolicitudesAprobadas.fromJson(jsonMap[i]);
        solicitudes.add(solicitud);
      }
    } else {
      print('error13' + resp.body.toString());
    }

    return solicitudes;
  }

  @override
  Future<List<SolicitudesRechazadas>> getAllSolicitudesRechazadas() async {
    String url = pathUrlBase + 'api/solicitudes/rechazadas';

    var resp = await http.get(Uri.parse(url));
    List<SolicitudesRechazadas> solicitudes = [];
    if (resp.statusCode == 200) {
      print('jmaprec' + resp.body);
      List<Map<String, dynamic>> jsonMap =
          List<Map<String, dynamic>>.from(jsonDecode(resp.body));
      print('jsmaprec' + jsonMap.toString());
      for (int i = 0; i <= jsonMap.length - 1; i++) {
        SolicitudesRechazadas solicitud =
            SolicitudesRechazadas.fromJson(jsonMap[i]);
        solicitudes.add(solicitud);
      }
    }

    return solicitudes;
  }

  @override
  Future<String> updateSolicitud(Map<String, dynamic> bodySolicitud) async {
    String url = pathUrlBase + 'api/solicitudes/updateSolicitud';
    String response = "";
    print('idsolicitud' + bodySolicitud.toString());
    var resp = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodySolicitud));
    if (resp.statusCode == 200) {
      List<Map<String, dynamic>> muestra = await SolicitudesHttp()
          .searchSolicitud(bodySolicitud["id_solicitud"]);
      //agregar la muestra
      await MuestrasHttp().postMuestra(
        muestra[0]["nombre_y_apellido"],
        muestra[0]["fecha_elaboracion"],
        muestra[0]["lote"],
        muestra[0]["producto"],
        muestra[0]["estilo"],
        muestra[0]["nombre_muestra"],
      );
      try {
        solicitudes_aprobadas =
            await SolicitudesHttp().getAllSolicitudesAprobadas();
        solicitudes_rechazadas =
            await SolicitudesHttp().getAllSolicitudesRechazadas();
      } catch (ex) {
        print('error:1' + ex.toString());
      }
    }
    response = resp.body;
    print('response' + response);
    return response;
  }

  @override
  Future<List<Map<String, dynamic>>> searchSolicitud(String id) async {
    List<Map<String, dynamic>> data = [];
    String url =
        pathUrlBase + 'api/solicitudes/searchSolicitud?id_solicitud=$id';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      String jsonString = resp.body;

      List<dynamic> jsonData = jsonDecode(jsonString);

      List<Map<String, dynamic>> jsonList =
          List<Map<String, dynamic>>.from(jsonData);
      data = jsonList;
    }
    return data;
  }

  @override
  Future<Map<String, dynamic>> deleteSolicitudByID(String id) async {
    String url =
        pathUrlBase + 'api/solicitudes/deleteSolicitud?id_solicitud=$id';

    var resp = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    Map<String, dynamic> data = {};
    if (resp.statusCode == 200) {
      data["result"] = resp.body;
    } else {
      print('ERROR: ' + resp.body);
    }

    print('scode' + resp.statusCode.toString());
    return data;
  }

  @override
  Stream<DatabaseEvent> getSolicitudesPendientes() async* {
    final DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('solicitudes');
    yield* ref.onValue;
  }
}
