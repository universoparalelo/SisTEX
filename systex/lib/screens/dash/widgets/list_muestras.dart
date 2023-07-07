import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:systex/models/muestras.dart';
import 'package:systex/screens/dash/widgets/floating_action.dart';
import 'package:systex/screens/dash/widgets/search_bar_muestra.dart';

class ListMuestras extends StatefulWidget {
  List<Muestra> muestras = [];
  int index;
  ListMuestras({required this.muestras, required this.index});

  @override
  State<ListMuestras> createState() => _ListMuestrasState();
}

class _ListMuestrasState extends State<ListMuestras> {
  //MuestrasController muestras = Get.put(MuestrasController());
  TextEditingController editingController = TextEditingController();
  List<Muestra> searchResults = [];
  void search() {
    String searchTerm = editingController.text;

    List<Muestra> filteredData = widget.muestras
        .where((element) => element.nombreMuestra
            .toLowerCase()
            .contains(searchTerm.toLowerCase()))
        .toList();
    setState(() {
      searchResults = filteredData;
    });
  }

  @override
  void initState() {
    searchResults = widget.muestras;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      color: Colors.grey[100],
                      child: TextField(
                        onChanged: (val) {
                          search();
                        },
                        controller: editingController,
                        decoration: const InputDecoration(
                          hintText: 'Buscar Muestra',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    FloatingAction(widget.index)
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Nombre Muestra',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text('Lote',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Productor',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Fecha elaboracion',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Fecha ingreso',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipo muestra',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Estilo',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                  ],
                  rows: editingController.text.isEmpty
                      ? widget.muestras
                          .map(
                            (element) => DataRow(cells: [
                              DataCell(Text(element
                                  .nombreMuestra)), //Extracting from Map element the value
                              DataCell(Text(element.lote)),
                              DataCell(Text(element.nombre_productor)),
                              DataCell(Text(element.fecha_elab)),
                              DataCell(Text(element.fecha_ingreso)),
                              DataCell(Text(element.tipo_muestra)),
                              DataCell(Text(element.estilo)),
                            ]),
                          )
                          .toList()
                      : searchResults
                          .map(
                            (element) => DataRow(cells: [
                              DataCell(Text(element
                                  .nombreMuestra)), //Extracting from Map element the value
                              DataCell(Text(element.lote)),
                              DataCell(Text(element.nombre_productor)),
                              DataCell(Text(element.fecha_elab)),
                              DataCell(Text(element.fecha_ingreso)),
                              DataCell(Text(element.tipo_muestra)),
                              DataCell(Text(element.estilo)),
                            ]),
                          )
                          .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
