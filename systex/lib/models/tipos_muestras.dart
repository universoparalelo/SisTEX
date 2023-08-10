//clase que representa los analisis realizados por el grupo

class TipoMuestras {
  String idTipoMuestra;
  String tipoMuestra;
  String precio;
  String analisis;

  TipoMuestras({
    required this.idTipoMuestra,
    required this.tipoMuestra,
    required this.precio,
    required this.analisis,
  });

  factory TipoMuestras.fromJson(Map<String, dynamic> json) {
    print('js' + json.toString());
    return TipoMuestras(
        idTipoMuestra: json["id_tipo_muestra"],
        tipoMuestra: json["tipo_muestra"],
        precio: json["precio"],
        analisis: json["analisis"]);
  }

  // Método para convertir el objeto a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id_tipo_muestra': idTipoMuestra,
      'tipo_muestra': tipoMuestra,
      'precio': precio,
      'analisis': analisis,
    };
  }
}
