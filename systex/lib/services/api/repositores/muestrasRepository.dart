import 'package:systex/models/muestras.dart';

abstract class MuestrasRepository {
  Future<List<Muestras>> getAllMuestras();

  Future<String> postMuestra(String nombreElaborador, String fechaElaboracion,
      String lote, String tipoMuestra, String estilo, String nombreMuestra);

  Future<Muestras?> getInfoMuestra(String idMuestra);
}
