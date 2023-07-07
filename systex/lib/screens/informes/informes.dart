import 'package:flutter/material.dart';
import 'package:systex/models/informes.dart';
import 'package:systex/screens/dash/widgets/floating_action.dart';

class Informes extends StatefulWidget {
  int index;
  List<InformesMuestras> informesMuestras;
  Informes({required this.index, required this.informesMuestras});

  @override
  State<Informes> createState() => _InformesState();
}

class _InformesState extends State<Informes> {
  TextEditingController searchInforme = TextEditingController();
  @override
  void initState() {
    super.initState();
    print('mie' + widget.informesMuestras.length.toString());
  }

  List<InformesMuestras> searchResults = [];
  void search() {
    String searchTerm = searchInforme.text;

    List<InformesMuestras> filteredData = widget.informesMuestras
        .where((element) =>
            element.id_muestra.toLowerCase().contains(searchTerm.toLowerCase()))
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
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      color: Colors.grey[100],
                      child: TextField(
                        controller: searchInforme,
                        onChanged: (val) => search(),
                        decoration: const InputDecoration(
                          hintText: 'Buscar Informe por codigo de muestra',
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
                  child: widget.informesMuestras.isEmpty
                      ? const Center(
                          child: Text('Sin Informes',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.w500)))
                      : DataTable(
                          columns: const [
                              DataColumn(
                                  label: Text(
                                'CodInforme',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text('URL',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Fecha',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('TipoInforme',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Lote',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('CodMuestra',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Acciones',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                            ],
                          rows: searchInforme.text.isEmpty
                              ? widget.informesMuestras
                                  // Loops through dataColumnText, each iteration assigning the value to element
                                  .map(
                                    ((element) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(element.cod_informe
                                                .toString())), //Extracting from Map element the value
                                            DataCell(RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: element.url,
                                                    style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.blue,
                                                    ),
                                                    // Agrega el comportamiento de navegación al enlace
                                                    recognizer: null,
                                                  ),
                                                ],
                                              ),
                                            )),
                                            DataCell(Text(element.fecha)),
                                            DataCell(Text(element.nombre)),
                                            DataCell(Text(element.lote)),
                                            DataCell(Text(element.id_muestra)),
                                            DataCell(Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.black,
                                                    )),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
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
                                            DataCell(Text(element.cod_informe
                                                .toString())), //Extracting from Map element the value
                                            DataCell(Text(element.url)),
                                            DataCell(Text(element.fecha)),
                                            DataCell(Text(element.nombre)),
                                            DataCell(Text(element.lote)),
                                            DataCell(Text(element.id_muestra)),
                                            DataCell(Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.black,
                                                    )),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    )),
                                              ],
                                            ))
                                          ],
                                        )),
                                  )
                                  .toList()))
            ],
          ),
        ),
      ),
    );
  }
}
