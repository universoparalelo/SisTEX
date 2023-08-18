import 'package:systex/models/solicitudes.dart';
import 'package:systex/models/solicitudes_aprobadas.dart';

class SolicitudesRechazadas extends Solicitudes {
  String estado;
  String motivo;
  SolicitudesRechazadas({
    required String idSolicitud,
    required String fechaSolicitud,
    required String nombre_y_apellido,
    required String analisisSolicitados,
    required String nombreMuestra,
    required String estilo,
    required String dni,
    required String nroTelefono,
    required String tipoSolicitante,
    required String nombreEmpresa,
    required String cuitEmpresa,
    required String direccionEmpresa,
    required String presentacion,
    required String localidadEmpresa,
    required String provinciaEmpresa,
    required this.motivo,
    required String producto,
    required String lote,
    String? precioTotal, // Permitir valores nulos usando el operador ?
    required String razonAnalisis,
    required String temperaturaAlmacenamiento,
    required String fechaElaboracion,
    required String parametrosSolicitados,
    required String fechaVencimiento,
    String? direccionElaboracion,
    String? localidad,
    String? provincia,
    required String urlComprobantePago,
    required this.estado,
  }) : super(
          idSolicitud: idSolicitud,
          dni: dni,
          tipoSolicitante: tipoSolicitante,
          cuitEmpresa: cuitEmpresa,
          nombreEmpresa: nombreEmpresa,
          direccionEmpresa: direccionEmpresa,
          localidadEmpresa: localidadEmpresa,
          provinciaEmpresa: provinciaEmpresa,
          presentacion: presentacion,
          fechaSolicitud: fechaSolicitud,
          nombre_y_apellido: nombre_y_apellido,
          analisisSolicitados: analisisSolicitados,
          nombreMuestra: nombreMuestra,
          parametrosSolicitados: parametrosSolicitados,
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
  factory SolicitudesRechazadas.fromJson(Map<String, dynamic> json) {
    print('preciototal' + json.toString());
    return SolicitudesRechazadas(
      idSolicitud: json["id_solicitud"],
      fechaSolicitud: json["fecha_rechazo"],
      dni: json["dni"],
      tipoSolicitante: json["tipoSolicitante"],
      nombreEmpresa: json["nombre_empresa"],
      cuitEmpresa: json["cuit_empresa"],
      direccionEmpresa: json["direccion_empresa"],
      presentacion: json["presentacion"],
      localidadEmpresa: json["localidad_empresa"],
      provinciaEmpresa: json["provincia_empresa"],
      parametrosSolicitados: json["parametros_solicitados"],
      nombre_y_apellido: json["nombre_y_apellido"],
      analisisSolicitados: json["analisis"],
      motivo: json["motivo"],
      nombreMuestra: json["nombre_muestra"],
      estilo: json["estilo"],
      nroTelefono: json["nro_telefono"],
      producto: json["producto"],
      estado: json["Estado"],
      lote: json["lote"],
      precioTotal: json["precio_total"] ?? "",
      razonAnalisis: json["razon_analisis"],
      temperaturaAlmacenamiento: json["temperatura_almacenamiento"],
      fechaElaboracion: json["fecha_elaboracion"],
      fechaVencimiento: json["fecha_vencimiento"],
      // estado: json["estado"],
      direccionElaboracion: json["direccion_elaboracion"] ?? "",
      localidad: json["localidad"] ?? "",
      provincia: json["provincia"] ?? "",
      urlComprobantePago: json["comprobantePago"],
    );
  }
}
