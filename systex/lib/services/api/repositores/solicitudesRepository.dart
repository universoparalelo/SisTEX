import 'package:firebase_database/firebase_database.dart';
import 'package:systex/models/solicitudes.dart';

abstract class SolicitudesRepository {
  Stream<DatabaseEvent> getSolicitudesPendientes();

  //obtiene todas las solicitudes pendientes
  Future<List<Solicitudes>> getAllSolicitudes();

  //obtiene todas las solicitudes aprobadas
  Future<List<Solicitudes>> getAllSolicitudesAprobadas();

  //obtiene todas las solicitudes rechazadas
  Future<List<Solicitudes>> getAllSolicitudesRechazadas();

  //actualizar el estado de una solicitud
  Future<String> updateSolicitud(Map<String, dynamic> bodySolicitud);

  //Buscar solicitud por ID
  Future<List<Map<String, dynamic>>> searchSolicitud(String id);

  //borrar una solicitud
  Future<Map<String, dynamic>> deleteSolicitudByID(String id);
}
