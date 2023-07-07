import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:systex/utilities/dates.dart';

class ShowMoreData extends StatefulWidget {
  String lote;
  String precio_analisis;
  String razon_analisis;
  String fecha_vencimiento;
  String comprobantePago;
  String localidad;
  String provincia;
  String direccion_elab;
  ShowMoreData(
      {required this.lote,
      required this.localidad,
      required this.provincia,
      required this.precio_analisis,
      required this.razon_analisis,
      required this.fecha_vencimiento,
      required this.comprobantePago,
      required this.direccion_elab});

  @override
  State<ShowMoreData> createState() => _ShowMoreDataState();
}

class _ShowMoreDataState extends State<ShowMoreData> {
  String fechaFormateada = '';
  void formatDate() {
    int i = 0;
    String formatDateExcel =
        convertirExcelFecha(int.parse(widget.fecha_vencimiento));
    while (formatDateExcel[i] != " " && i <= formatDateExcel.length - 1) {
      fechaFormateada = fechaFormateada + formatDateExcel[i];
      print('fechaFormat' + fechaFormateada);
      i++;
    }
  }

  @override
  void initState() {
    formatDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.35,
      child: ListView(
        children: [
          ListTile(title: const Text('Lote'), subtitle: Text(widget.lote)),
          ListTile(
              title: const Text('Precio Analisis'),
              subtitle: Text('\$' + widget.precio_analisis)),
          ListTile(
              title: const Text('Razon Analisis'),
              subtitle: Text(widget.razon_analisis)),
          ListTile(
              title: const Text('Fecha Vencimiento'),
              subtitle: Text(fechaFormateada)),
          ListTile(
              title: const Text('Direccion Elaboracion'),
              subtitle: Text(widget.direccion_elab)),
          ListTile(
              title: const Text('Localidad'), subtitle: Text(widget.localidad)),
          ListTile(
              title: const Text('Provincia'), subtitle: Text(widget.provincia)),
        ],
      ),
    );
  }
}
