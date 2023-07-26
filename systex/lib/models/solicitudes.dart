class Solicitudes {
  String idSolicitud;
  String fechaSolicitud;
  String nombre_y_apellido;
  String analisisSolicitados;
  String nombreMuestra;
  String estilo;
  String nroTelefono;
  String producto;
  String lote;
  String precioTotal;
  String razonAnalisis;
  String temperaturaAlmacenamiento;
  String fechaElaboracion;
  String fechaVencimiento;
  // String estado;
  String direccionElaboracion;
  String localidad;
  String provincia;
  String urlComprobantePago;

  Solicitudes({
    required this.idSolicitud,
    required this.fechaSolicitud,
    required this.nombre_y_apellido,
    required this.analisisSolicitados,
    required this.nombreMuestra,
    required this.estilo,
    required this.nroTelefono,
    required this.producto,
    required this.lote,
    required this.precioTotal,
    required this.razonAnalisis,
    required this.temperaturaAlmacenamiento,
    required this.fechaElaboracion,
    required this.fechaVencimiento,
    // required this.estado,
    required this.direccionElaboracion,
    required this.localidad,
    required this.provincia,
    required this.urlComprobantePago,
  });

  // Método que crea una instancia de Solicitudes desde un Map (JSON)
  factory Solicitudes.fromJson(Map<String, dynamic> json) {
    print('jti' + json.toString());
    return Solicitudes(
      idSolicitud: json["id_solicitud"],
      fechaSolicitud: json["fecha_solicitud"],
      nombre_y_apellido: json["nombre_y_apellido"],
      analisisSolicitados: json["analisis_solicitados"],
      nombreMuestra: json["nombre_muestra"],
      estilo: json["estilo"],
      nroTelefono: json["nro_telefono"],
      producto: json["producto"],
      lote: json["lote"],
      precioTotal: json["precio_total"],
      razonAnalisis: json["razon_analisis"],
      temperaturaAlmacenamiento: json["temperatura_almacenamiento"],
      fechaElaboracion: json["fecha_elaboracion"],
      fechaVencimiento: json["fecha_vencimiento"],
      // estado: json["estado"],
      direccionElaboracion: json["direccion_elaboracion"],
      localidad: json["localidad"],
      provincia: json["provincia"],
      urlComprobantePago: json["comprobantePago"],
    );
  }
}
