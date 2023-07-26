import 'package:systex/models/solicitudes.dart';

abstract class SolicitudesRepository {
  //obtiene todas las solicitudes pendientes
  Future<List<Solicitudes>> getAllSolicitudes();
}
