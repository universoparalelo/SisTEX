import 'package:systex/models/tipos_muestras.dart';

abstract class TipoMuestrasRepository {
  Future<List<TipoMuestras>> getAllTiposAnalisis();

  Future<String> updateAnalisis(TipoMuestras tipomuestras);
}
