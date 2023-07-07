import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:systex/models/informes.dart';
import 'package:systex/models/muestras.dart';
import 'package:systex/models/producer.dart';
import 'package:systex/models/solicitudes_productores.dart';
import 'package:systex/models/tipos_analisis.dart';
import 'package:systex/utilities/dates.dart';

import '../screens/informes/informes.dart';

class Services {
  static const credentials = r'''
{
  "type": "service_account",
  "project_id": "test-register-367513",
  "private_key_id": "6876aa6ffc4a7fd70327ad24fb1b2167902139ca",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDcfni092LG3Dnl\nK3XYbtG+zfXokVRThVi2wtHRex44j+D48b0QpYhiKef4NZxijAjClgLbtiUbfQ0e\nqcf2Pp2YmALCAFeEqAsqi/XP/UO1CfWcEs1l7UT6mp4OyLOTO0wfkw21W/1CS5Qk\nmaNZ29Zc70MVx3Fulu6nTUT4PAX47tP6Cl6e2n0d8i288Zc7vCIoSdg2l/V2uK4K\ndRLBVz+HcFCN14eyuULyGnez5ve1DY79cfWRH65OF9prOD2FG4xynQdWFg6qpWN3\n+HZ+RVqie4o0OA7UanTA1wnm5Klxyj0aTJZoZGa35z0zlIJ7llIM8Jw98ta7Rzgi\niQ/XiIkzAgMBAAECggEABsACa8ihzmR7vnKVp+INa4tvl0aRSWgTWEj5IzIWZNt9\nIvHd/I5f8S1gpUsZQs6pp/28Q0PXH/lnxB2lE8dEvzqlsiqDg2A6zOGLAJ27i5iT\njpfoXNHy/IvTAeRBoLGK7STtB88Anx2kM98JaENTU4+cwwpsUQ5JN3e/AEbW7sQ5\nmRSWESz2ZzQAD+/bxZb4JdInNAj/q1A5jKD4rDZiIq47MRyllfZqvp9jUrXELsUH\no01QDmRDPV0ouIwXAPptGm5QFtokLjII1wd9x86e02LYI66RGCAtWjIxa2dXnJXi\nGnYjOnLK3HS0ySiBXfORj42/Mj29+wofg+O/n0cTvQKBgQD2rM1+5WC6Hhe6tdQA\nuJD0VoPj0jD3Vrrda+QrdRbcDoU1eK0r2mfTslWYS7meXx+DMymIvLTnUeypCHsm\nnJEd6EVnSu01NZKsbdMQTsSUZ0Bd6zFSKO1bLfbxXUlShWiyG3uDkl9bAdB5Edrm\nlZfn8+mB4x2zvzqbW6kPrQfo7QKBgQDk1E1nkf42El4Lrm6pohfbGU373vXC+A3V\nTuQismL5atx/1B+xHhnj5OpAykAYE9HYjjQKT4v8sAs7RhQn6JNATejn333Z4u7h\nhYrM011Fuf2q3zihgVV7xtCT82c5/kvkF2ZNAn9sgEJsxRcIduB6dzuASBvpmyac\nIyIOgTSWnwKBgQC9hSadSD54wIYavXiU1TkJgS7z6poUbl5DoJE9kkht6foOixkB\niFwdGfcJe6SxOQRNGRHgLJwQ3bCmbg2wLLqR79Li+X4mU3LNZ9Oxw9Lk8i9R+VF7\nflZep4IDD1k2PamirdrHy73Xfh1d54n3fxem7o+Ja6V2ZIXytwm9MYPSQQKBgFU4\nN6eFuG28w2eIS9BC/K1tLBzMOSymIsi4+79sPe3zfTDh9/eHZU75FsCQUfRllTYY\nJ4tbep/dlCE8BQ+jzwsYuM957S2zFRHKIRoM8WShUrZLMZT8TLCvJ0iiUmRHr02/\n5Spy7q+iyJongF93njwdoXwx3qtOS7/EWc+bENGzAoGAP4o/RWxItrk4pD3TljNl\noFE6eegzB9FiCcGsUJs1NvnrU/qZyGn4Z/NyeM4iyjOs84XAaolIxZrE6P0Ew+sa\nAlbblf5LW4jYjY2R0tiTnErVlEXMI73o9lpRmzh7xOKRysmKQwmP/eGx+sTAGyCH\nLJ4eH6xfLEYVia8LdrOp4qU=\n-----END PRIVATE KEY-----\n",
  "client_email": "test-register@test-register-367513.iam.gserviceaccount.com",
  "client_id": "108530157539732356696",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/test-register%40test-register-367513.iam.gserviceaccount.com"
}''';

  Future<List<Muestra>> getMuestras() async {
    final gsheets = GSheets(credentials);
    final sheet = await gsheets
        .spreadsheet('1Gw02IwltfMdcrp4mX7XwpMgNsCFZA_26JgKL0dUOROk');
    var workSheet = sheet.worksheetById(0);
    List<List<String>> prods = await workSheet!.values.allRows();
    print('pds' + prods.toString());
    List<Muestra> producers = parsearLista(prods);
    return producers;
  }

  Future<List<SolicitudesProductores>> getSolicitudes() async {
    List<SolicitudesProductores> solicitudes = [];
    final gsheets = GSheets(credentials);
    final sheet = await gsheets
        .spreadsheet('1Gw02IwltfMdcrp4mX7XwpMgNsCFZA_26JgKL0dUOROk');
    var workSheet = sheet.worksheetById(848944516);
    List<List<dynamic>> prods = await workSheet!.values.allRows();
    solicitudes = parsearListaSolicitudes(prods);
    print('long' + solicitudes.toString());
    return solicitudes;
  }

  List<SolicitudesProductores> parsearListaSolicitudes(
      List<List<dynamic>> lista) {
    List<SolicitudesProductores> solicitudes = [];
    lista.removeAt(0);

    print('sot1r' + lista.length.toString());
    for (int i = 0; i < lista.length; i++) {
      List<dynamic> item = lista[i];
      print('lk' + item.toString());
      String fecha_solicitud = item[1].toString();
      String nombre_apellido = item[2].toString();
      String tipo = item[3].toString();
      String nombre_muestra = item[4].toString();
      String estilo = item[5];
      String nroTelefono = item[6];
      String producto = item[7];
      String estado = item[8];
      String lote = item[9];
      String precio_total = item[10];
      String razon_analisis = item[11];
      String temp_almacenamiento = item[12];
      String fecha_elab = item[13];
      String fecha_vencimiento = item[14];
      String direccion_elab = item[15];
      String localidad = item[16];
      String provincia = item[17];
      SolicitudesProductores solicitudesProductores = SolicitudesProductores(
          fecha_solicitud: fecha_solicitud,
          nombreyApellido: nombre_apellido,
          tipo: tipo,
          nombreMuestra: nombre_muestra,
          estilo: estilo,
          nro_telefono: nroTelefono,
          producto: producto,
          estado: estado,
          lote: lote,
          precio_total: precio_total,
          razon_analisis: razon_analisis,
          temp_almacenamiento: temp_almacenamiento,
          fecha_elaboracion: fecha_elab,
          fecha_vencimiento: fecha_vencimiento,
          direccion_elaboracion: direccion_elab,
          localidad: localidad,
          provincia: provincia);

      print('productor solicitante' + solicitudesProductores.nombreyApellido);

      solicitudes.add(solicitudesProductores);
    }

    print('muestras34' + solicitudes.toString());

    return solicitudes;
  }

  List<Muestra> parsearLista(List<List<dynamic>> lista) {
    List<Muestra> muestras = [];

    print('lks' + lista.toString());

    for (int i = 1; i < lista.length - 1; i++) {
      List<dynamic> item = lista[i];
      print('sot' + item.toString());
      String nombreMuestra = item[1];

      String lote = item[2];
      String nombre_prod = item[3];
      String fecha_elab = item[4];
      String fecha_ingreso = item[5];
      String tipo_muestra = item[6];
      String estilo = item[7];

      Muestra muestra = Muestra(
        nombreMuestra: nombreMuestra,
        lote: lote,
        nombre_productor: nombre_prod,
        fecha_elab: fecha_elab,
        fecha_ingreso: fecha_ingreso,
        tipo_muestra: tipo_muestra,
        estilo: estilo,
      );

      muestras.add(muestra);
    }

    print('muestras34' + muestras.toString());

    return muestras;
  }

  Future<List<Producer>> getProducers() async {
    final gsheets = GSheets(credentials);
    final sheet = await gsheets
        .spreadsheet('1Gw02IwltfMdcrp4mX7XwpMgNsCFZA_26JgKL0dUOROk');
    var workSheet = sheet.worksheetById(1499752289);
    List<List<String>> prods = await workSheet!.values.allRows();
    List<Producer> producers = parsearLista2(prods);
    return producers;
  }

  List<Producer> parsearLista2(List<List<dynamic>> lista) {
    List<Producer> productores = [];

    for (int i = 1; i < lista.length; i++) {
      List<dynamic> item = lista[i];

      String nombre = item[1].split(', ')[0];

      String direccion = item[2];
      String localidad = item[3];
      String provincia = item[4];

      Producer productor = Producer(
        nameProducer: nombre,
        direction: direccion,
        location: localidad,
        province: provincia,
      );

      productores.add(productor);
    }

    return productores;
  }

  List<TiposAnalisis> parsearListaPrecios(List<List<dynamic>> lista) {
    List<TiposAnalisis> tiposanalisis = [];

    for (int i = 1; i < lista.length; i++) {
      List<dynamic> item = lista[i];
      print('itm' + item.toString());
      if (item.isNotEmpty && !item.contains(",")) {
        TiposAnalisis analisis = TiposAnalisis(
          analisis: item[0],
          precio: item[1],
        );

        tiposanalisis.add(analisis);
      }
    }

    return tiposanalisis;
  }

  Future<List<TiposAnalisis>> getTiposAnalisis() async {
    final gsheets = GSheets(credentials);
    List<TiposAnalisis> tiposanalisis = [];
    final sheet = await gsheets
        .spreadsheet('1Gw02IwltfMdcrp4mX7XwpMgNsCFZA_26JgKL0dUOROk');
    var workSheet = sheet.worksheetById(1573032540);
    List<List<String>> prods = await workSheet!.values.allRows();
    tiposanalisis = parsearListaPrecios(prods);
    return tiposanalisis;
    print('jtq' + tiposanalisis.toString());
  }

  List<InformesMuestras> parsearListaInformes(List<List<dynamic>> lista) {
    List<InformesMuestras> informes = [];

    for (int i = 1; i < lista.length; i++) {
      List<dynamic> item = lista[i];
      print('itm' + item.toString());
      if (item.isNotEmpty && !item.contains(",")) {
        int fechaNum = int.parse(item[2]);
        DateTime fechabase = DateTime(1900, 1, 1);
        DateTime fechaParsed = fechabase.add(Duration(days: fechaNum));
        String fechaFormat = DateFormat('dd/MM/yyyy').format(fechaParsed);
        InformesMuestras inf = InformesMuestras(
          cod_informe: int.parse(item[0]),
          url: item[1],
          fecha: fechaFormat,
          nombre: item[3],
          lote: item[4],
          id_muestra: item[5],
        );

        informes.add(inf);
      }
    }

    return informes;
  }

  Future<List<InformesMuestras>> getInformes() async {
    final gsheets = GSheets(credentials);
    List<InformesMuestras> informes = [];
    final sheet = await gsheets
        .spreadsheet('1Gw02IwltfMdcrp4mX7XwpMgNsCFZA_26JgKL0dUOROk');
    var workSheet = sheet.worksheetById(834844339);
    List<List<String>> prods = await workSheet!.values.allRows();
    informes = parsearListaInformes(prods);
    print('mks' + informes.length.toString());
    return informes;
  }

  List<TiposAnalisis> parsearListaAnalisis(List<List<dynamic>> lista) {
    List<TiposAnalisis> tiposanalisis = [];

    for (int i = 1; i < lista.length; i++) {
      List<dynamic> item = lista[i];
      print('itm' + item.toString());
      if (item.isNotEmpty && !item.contains(",")) {
        TiposAnalisis tipanalisis =
            TiposAnalisis(analisis: item[0], precio: item[1]);

        tiposanalisis.add(tipanalisis);
      }
    }

    return tiposanalisis;
  }

  Future<String> getDirection(String nombreProductor) async {
    final gsheets = GSheets(credentials);
    String direction = '';
    final sheet = await gsheets
        .spreadsheet('1Gw02IwltfMdcrp4mX7XwpMgNsCFZA_26JgKL0dUOROk');
    var workSheet = sheet.worksheetById(1499752289);
    List<List<String>> prods = await workSheet!.values.allRows();
    List<Producer> producers = parsearLista2(prods);
    for (int i = 0; i <= producers.length - 1; i++) {
      if (producers[i].nameProducer == nombreProductor) {
        direction = producers[i].direction + ' ' + '-' + producers[i].location;
      }
    }
    return direction;
  }

  Future<List<TiposAnalisis>> getAnalisis() async {
    List<TiposAnalisis> analisis = [];
    final gsheets = GSheets(credentials);

    final sheet = await gsheets
        .spreadsheet('1Gw02IwltfMdcrp4mX7XwpMgNsCFZA_26JgKL0dUOROk');
    var workSheet = sheet.worksheetById(1573032540);
    List<List<String>> prods = await workSheet!.values.allRows();
    analisis = parsearListaAnalisis(prods);

    return analisis;
  }

  Future<void> addProductor(Producer producer) async {
    final gsheets = GSheets(credentials);
    final sheet = await gsheets
        .spreadsheet('1Gw02IwltfMdcrp4mX7XwpMgNsCFZA_26JgKL0dUOROk');
    var workSheet = sheet.worksheetById(1499752289);

    List<Producer> producers = await getProducers();
    var row = [
      producers.length + 1,
      producer.nameProducer,
      producer.direction,
      producer.location,
      producer.province
    ];
    workSheet!.values.insertRow(producers.length + 1, row);
  }

  //agregar muestra
  Future<void> addMuestra(Muestra muestra) async {
    final gsheets = GSheets(credentials);
    List<Muestra> muestras = await getMuestras();
    final sheet = await gsheets
        .spreadsheet('1Gw02IwltfMdcrp4mX7XwpMgNsCFZA_26JgKL0dUOROk');
    var workSheet = sheet.worksheetById(0);
    var row = [
      muestras.length + 1,
      muestra.nombreMuestra,
      muestra.lote,
      muestra.nombre_productor,
      muestra.fecha_elab,
      muestra.fecha_ingreso,
      muestra.tipo_muestra,
      muestra.estilo
    ];
    workSheet!.values.appendRow(row);
    //workSheet!.values.insertRow();
  }

  //verificar si existe productor buscandolo por direccion y nombre
  Future<bool> verifyExistsProductor(
      String direction, String nombreProductor) async {
    List<Producer> producers = await getProducers();
    bool found = false;
    for (int i = 0; i <= producers.length - 1; i++) {
      if (producers[i].direction == direction &&
          producers[i].nameProducer == nombreProductor) {
        found = true;
      }
    }
    return found;
  }

  //verificar si existe muestra de un productor
  Future<bool> verifyExistsMuestra(
      String nombreMuestra, String lote, String productor) async {
    List<Muestra> muestras = await getMuestras();
    bool foundMuestra = false;
    for (int i = 0; i <= muestras.length - 1; i++) {
      if (muestras[i].nombreMuestra == nombreMuestra &&
          muestras[i].lote == lote &&
          muestras[i].nombre_productor == productor) {
        foundMuestra = true;
      }
    }
    return foundMuestra;
  }
}
