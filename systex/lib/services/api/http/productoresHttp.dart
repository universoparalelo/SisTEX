import 'dart:convert';

import 'package:systex/config.dart';
import 'package:systex/models/productores.dart';
import 'package:systex/services/api/repositores/productoresRepository.dart';
import 'package:http/http.dart' as http;

class ProductoresHttp implements RepositoryProductores {
  @override
  Future<void> addProductor(Productor productor) async {}

  @override
  Future<void> deleteProductor(String idProd) async {
    // TODO: implement deleteProductor
    throw UnimplementedError();
  }

  @override
  Future<List<Productor>> getAllProductores() async {
    String finalUrl = pathUrlBase + 'api/productores';
    List<Productor> productores = [];
    var request = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (request.statusCode == 200) {
      // La solicitud fue exitosa, entonces decodificamos la respuesta JSON
      List<dynamic> responseData = jsonDecode(request.body);

      // Mapeamos los datos JSON a objetos Productor y los almacenamos en una lista

      List<Productor> _productores =
          responseData.map((item) => Productor.fromJson(item)).toList();

      // Devolvemos la lista de productores
      productores = _productores;
    } else {
      print('error12' + request.body.toString());
    }

    return productores;
  }

  @override
  Future<List<Productor>> searchProductor(String nameProductor) async {
    print('prod1' + nameProductor);
    String url = pathUrlBase + 'api/productores/$nameProductor';
    var resp = await http.get(Uri.parse(url));
    List<Productor> productores = [];
    if (resp.statusCode == 200) {
      // La solicitud fue exitosa, entonces decodificamos la respuesta JSON
      List<dynamic> responseData = jsonDecode(resp.body);
      print('jota1' + responseData.toString());
      // Mapeamos los datos JSON a objetos Productor y los almacenamos en una lista
      List<Productor> _productores =
          responseData.map((item) => Productor.fromJson(item)).toList();

      // Devolvemos la lista de productores
      productores = _productores;
    }
    print('prodw' + productores[0].direccionElaboracion);
    return productores;
  }
}
