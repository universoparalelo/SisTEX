import 'package:systex/models/muestras.dart';

abstract class MuestrasRepository {
  Future<List<Muestras>> getAllMuestras();
}
