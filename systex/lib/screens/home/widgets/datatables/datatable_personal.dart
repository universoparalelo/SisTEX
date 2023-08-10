import 'package:flutter/material.dart';

class DataTablePersonal extends StatefulWidget {
  DataTablePersonal({Key? key}) : super(key: key);

  @override
  State<DataTablePersonal> createState() => _DataTablePersonalState();
}

class _DataTablePersonalState extends State<DataTablePersonal> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          // border: TableBorder.all(),
          columns: const [
            DataColumn(
                label: Text('Nombre y Apellido',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label:
                    Text('Rol', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Agostina Blanco')),
              DataCell(Text('Estudiante')),
            ])
          ],
        ),
      ),
    );
  }
}
