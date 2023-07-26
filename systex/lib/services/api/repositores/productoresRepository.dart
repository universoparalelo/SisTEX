import 'package:systex/models/productores.dart';

abstract class RepositoryProductores {
  Future<List<Productor>> getAllProductores();
  Future<List<Productor>> searchProductor(String nameProductor);
  Future<void> addProductor(Productor productor);
  Future<void> deleteProductor(String idProd);
}
