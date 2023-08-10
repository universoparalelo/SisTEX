import 'package:systex/models/parametro.dart';

abstract class ParametrosRepository {
  Future<List<Parametro>> getAllParametros();

  Future<void> addParametro(String nombreParametro);
}
