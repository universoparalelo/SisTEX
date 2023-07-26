class Informes {
  String codInforme;
  String urlInforme;

  //la fecha en la que se hizo el informe
  String fecha;
  String nombre;
  String lote;
  String id_muestra;
  //String id_elaborador;

  Informes(
      {required this.codInforme,
      required this.urlInforme,
      required this.fecha,
      required this.lote,
      //required this.id_elaborador,
      required this.id_muestra,
      required this.nombre});

  factory Informes.fromJson(Map<String, dynamic> json) {
    return Informes(
      codInforme: json["cod_informe"],
      urlInforme: json["url"],
      fecha: json["fecha"],
      nombre: json["nombre"],
      lote: json["lote"],
      id_muestra: json["id_muestra"],
      //id_elaborador: json["id_elaborador"],
    );
  }
}
