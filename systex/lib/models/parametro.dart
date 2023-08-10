class Parametro {
  String id_parametro;
  String parametro;
  Parametro({required this.id_parametro, required this.parametro});

  // Método que crea una instancia de Parametro desde un Map (JSON)
  factory Parametro.fromJson(Map<String, dynamic> json) {
    return Parametro(
      id_parametro: json["id_parametro"],
      parametro: json["parametro"],
    );
  }
}
