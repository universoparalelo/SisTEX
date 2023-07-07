import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:systex/models/producer.dart';
import 'package:systex/screens/dash/widgets/floating_action.dart';
import 'package:systex/screens/dash/widgets/search_elaborator.dart';
import 'package:systex/screens/dash/widgets/selector_province.dart';
import 'package:systex/screens/dash/widgets/textfield_direction.dart';
import 'package:systex/screens/dash/widgets/textfield_location.dart';
import 'package:systex/screens/dash/widgets/textfield_name_producer.dart';
import 'package:systex/screens/dash/widgets/window_delete_producer.dart';

class ListProducers extends StatefulWidget {
  bool isExpanded;
  List<Producer> producers;
  int index;
  ListProducers(
      {required this.isExpanded, required this.producers, required this.index});

  @override
  State<ListProducers> createState() => _ListProducersState();
}

class _ListProducersState extends State<ListProducers> {
  TextEditingController editingController = TextEditingController();
  List<Producer> searchResults = [];
  void search() {
    String searchTerm = editingController.text;

    List<Producer> filteredData = widget.producers
        .where((element) => element.nameProducer
            .toLowerCase()
            .contains(searchTerm.toLowerCase()))
        .toList();
    setState(() {
      searchResults = filteredData;
    });
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
              //let's add the navigation menu for this project
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
                        controller: editingController,
                        onChanged: (val) => search(),
                        decoration: const InputDecoration(
                          hintText: 'Buscar productor',
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
                  child: widget.producers.isEmpty
                      ? const CircularProgressIndicator()
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'Nombre y Apellido',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text('Direccion',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Localidad',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Provincia',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Acciones',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: editingController.text.isEmpty
                                  ? widget.producers
                                      // Loops through dataColumnText, each iteration assigning the value to element
                                      .map(
                                        ((element) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(element
                                                    .nameProducer)), //Extracting from Map element the value
                                                DataCell(
                                                    Text(element.direction)),
                                                DataCell(
                                                    Text(element.location)),
                                                DataCell(
                                                    Text(element.province)),
                                                DataCell(Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (ctx) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Eliminar a ' +
                                                                          element
                                                                              .nameProducer),
                                                                  content:
                                                                      WindowDeleteProducer(),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {},
                                                                        child: Text(
                                                                            'Si')),
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                            'No')),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        )),
                                                  ],
                                                ))
                                              ],
                                            )),
                                      )
                                      .toList()
                                  : searchResults
                                      // Loops through dataColumnText, each iteration assigning the value to element
                                      .map(
                                        ((element) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(element
                                                    .nameProducer)), //Extracting from Map element the value
                                                DataCell(
                                                    Text(element.direction)),
                                                DataCell(
                                                    Text(element.location)),
                                                DataCell(
                                                    Text(element.province)),
                                                DataCell(Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        )),
                                                  ],
                                                ))
                                              ],
                                            )),
                                      )
                                      .toList()),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
