class Muestras {
  String idMuestra;
  String nombreMuestra;
  String lote;
  String idElaborador;
  String fechaElaboracion;
  String fechaIngreso;
  String tipoMuestra;
  String estilo;

  Muestras(
      {required this.idMuestra,
      required this.nombreMuestra,
      required this.lote,
      required this.idElaborador,
      required this.fechaElaboracion,
      required this.fechaIngreso,
      required this.tipoMuestra,
      required this.estilo});

  factory Muestras.fromJson(Map<String, dynamic> json) {
    return Muestras(
        idMuestra: json["id_muestra"],
        nombreMuestra: json["nombre_muestra"],
        lote: json["lote"],
        idElaborador: json["id_elaborador"],
        fechaElaboracion: json["fecha_elaboracion"],
        fechaIngreso: json["fecha_ingreso"],
        tipoMuestra: json["tipo_muestra"],
        estilo: json["estilo"]);
  }
}
