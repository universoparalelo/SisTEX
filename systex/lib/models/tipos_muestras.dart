//clase que representa los analisis realizados por el grupo

class TipoMuestras {
  String idTipoMuestra;
  String tipoMuestra;
  String precio;

  TipoMuestras(
      {required this.idTipoMuestra,
      required this.tipoMuestra,
      required this.precio});

  factory TipoMuestras.fromJson(Map<String, dynamic> json) {
    return TipoMuestras(
      idTipoMuestra: json["id_tipo_muestra"],
      tipoMuestra: json["tipo_muestra"],
      precio: json["precio"],
    );
  }
}
