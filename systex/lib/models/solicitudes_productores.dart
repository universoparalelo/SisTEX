class SolicitudesProductores {
  String fecha_solicitud;
  String nombreyApellido;
  String tipo;
  String nombreMuestra;
  String estilo;
  String nro_telefono;
  String producto;
  String estado;
  String lote;
  String precio_total;
  String razon_analisis;
  String temp_almacenamiento;
  String fecha_elaboracion;
  String fecha_vencimiento;
  String direccion_elaboracion;
  String localidad;
  String provincia;
  SolicitudesProductores(
      {required this.fecha_solicitud,
      required this.nombreyApellido,
      required this.tipo,
      required this.nombreMuestra,
      required this.estilo,
      required this.nro_telefono,
      required this.producto,
      required this.estado,
      required this.lote,
      required this.precio_total,
      required this.razon_analisis,
      required this.temp_almacenamiento,
      required this.fecha_elaboracion,
      required this.fecha_vencimiento,
      required this.direccion_elaboracion,
      required this.localidad,
      required this.provincia});
}
