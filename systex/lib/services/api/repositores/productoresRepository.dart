import 'package:systex/models/productores.dart';

abstract class RepositoryProductores {
  //obtener productor
  Future<List<Productor>> getAllProductores();
  Future<List<Productor>> searchProductor(String nameProductor);
  //agregar productor
  Future<void> addProductor(Productor productor);
  //borrar productor
  Future<void> deleteProductor(String idProd);
}
