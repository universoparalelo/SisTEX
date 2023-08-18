class Personal {
  String id_personal;
  String nombre_y_apellido;
  String rol;

  Personal(
      {required this.id_personal,
      required this.nombre_y_apellido,
      required this.rol});

  factory Personal.fromJson(Map<String, dynamic> json) {
    print('jotason' + json.toString());
    return Personal(
        id_personal: json["id_personal"],
        nombre_y_apellido: json["nombre_y_apellido"],
        rol: json["rol"]);
  }
}
