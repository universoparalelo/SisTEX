import 'dart:io';
import 'dart:typed_data';

import 'package:systex/models/informes.dart';
import 'package:systex/models/solicitudes_aprobadas.dart';

abstract class InformesRepository {
  //Obtener todos los informes
  Future<List<Informes>> getInformes();

  //agregar informe
  Future<String> addInforme(String lote, String nombreMuestra, String productor,
      List<int> pdfInforme, String nombreAnalisis);
}
