import 'package:intl/intl.dart';

String convertirFechaNumerica(String fechaNumerica) {
  int anio = int.parse(fechaNumerica.substring(0, 2));
  int mes = int.parse(fechaNumerica.substring(2, 4));
  int dia = int.parse(fechaNumerica.substring(4, 6));

  // Obtener el año actual y ajustar el siglo si es necesario
  int anioActual = DateTime.now().year;
  int siglo = anioActual ~/ 100; // División entera
  anio += siglo * 100;
  DateTime fecha = DateTime(anio, mes, dia);
  print('fecha1' + fecha.toString());
  return fecha.toString();
}

String convertirExcelFecha(int numeroSerie) {
  DateTime fechaBase = DateTime(1900, 1, 1);
  DateTime fechaFinal = fechaBase.add(Duration(days: numeroSerie.toInt() - 2));
  String finalDate = fechaFinal.day.toString() +
      '\/' +
      fechaFinal.month.toString() +
      '\/' +
      fechaFinal.year.toString() +
      '  ' +
      fechaFinal.hour.toString() +
      ':' +
      fechaFinal.minute.toString() +
      ':' +
      fechaFinal.second.toString();
  return finalDate;
}
