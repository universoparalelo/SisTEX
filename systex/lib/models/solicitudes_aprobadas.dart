import 'package:systex/models/solicitudes.dart';

class SolicitudesAprobadas extends Solicitudes {
  String estado;

  SolicitudesAprobadas({
    required String idSolicitud,
    required String fechaSolicitud,
    required String nombre_y_apellido,
    required String analisisSolicitados,
    required String nombreMuestra,
    required String estilo,
    required String nroTelefono,
    required String producto,
    required String parametrosSolicitados,
    required String dni,
    required String lote,
    String? precioTotal, // Permitir valores nulos usando el operador ?
    required String razonAnalisis,
    required String temperaturaAlmacenamiento,
    required String fechaElaboracion,
    required String fechaVencimiento,
    String? direccionElaboracion,
    String? localidad,
    String? provincia,
    required String urlComprobantePago,
    required this.estado,
  }) : super(
          idSolicitud: idSolicitud,
          fechaSolicitud: fechaSolicitud,
          parametrosSolicitados: parametrosSolicitados,
          nombre_y_apellido: nombre_y_apellido,
          analisisSolicitados: analisisSolicitados,
          nombreMuestra: nombreMuestra,
          dni: dni,
          estilo: estilo,
          nroTelefono: nroTelefono,
          producto: producto,
          lote: lote,
          precioTotal:
              precioTotal ?? "", // Usar el valor predeterminado si es nulo
          razonAnalisis: razonAnalisis,
          temperaturaAlmacenamiento: temperaturaAlmacenamiento,
          fechaElaboracion: fechaElaboracion,
          fechaVencimiento: fechaVencimiento,
          direccionElaboracion: direccionElaboracion ?? "",
          localidad: localidad ?? "",
          provincia: provincia ?? "",
          urlComprobantePago: urlComprobantePago,
        );

  // Método que crea una instancia de Solicitudes desde un Map (JSON)
  factory SolicitudesAprobadas.fromJson(Map<String, dynamic> json) {
    print('preciototal' + json.toString());
    return SolicitudesAprobadas(
      idSolicitud: json["id_solicitud"],
      fechaSolicitud: json["fecha_aprobacion"],
      parametrosSolicitados: json["parametros_solicitados"],
      nombre_y_apellido: json["nombre_y_apellido"],
      analisisSolicitados: json["analisis"],

      nombreMuestra: json["nombre_muestra"],
      estilo: json["estilo"],
      nroTelefono: json["nro_telefono"],
      producto: json["producto"],
      estado: json["Estado"],

      lote: json["lote"],
      dni: json["dni"].toString().trim(),
      // precioTotal: json["precio_total"] ?? "",
      razonAnalisis: json["razon_analisis"],
      temperaturaAlmacenamiento: json["temperatura_almacenamiento"],
      fechaElaboracion: json["fecha_elaboracion"],
      fechaVencimiento: json["fecha_vencimiento"],
      // estado: json["estado"],
      //direccionElaboracion: json["direccion_elaboracion"] ?? "",
      //localidad: json["localidad"] ?? "",

      //provincia: json["provincia"] ?? "",
      urlComprobantePago: json["comprobantePago"],
    );
  }
}
