class Productor {
  final String idElaborador;
  final String nombre_y_apellido;
  final String direccionElaboracion;
  final String localidad;
  final String provincia;
  final String dni;
  final String tipoSolicitante;

  Productor(
      {required this.idElaborador,
      required this.nombre_y_apellido,
      required this.direccionElaboracion,
      required this.localidad,
      required this.dni,
      required this.tipoSolicitante,
      required this.provincia});

  // Método que crea una instancia de Person desde un Map (JSON)
  factory Productor.fromJson(Map<String, dynamic> json) {
    print('jotason' + json.toString());
    return Productor(
        idElaborador: json["id_elaborador"],
        nombre_y_apellido: json["nombre_y_apellido"],
        dni: json["dni"],
        tipoSolicitante: json["tipoSolicitante"],
        direccionElaboracion: json["direccion_elaboracion"],
        localidad: json["localidad"],
        provincia: json["provincia"]);
  }
}
