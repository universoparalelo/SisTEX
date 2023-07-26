import 'package:systex/models/informes.dart';

abstract class InformesRepository {
  Future<List<Informes>> getInformes();
}
