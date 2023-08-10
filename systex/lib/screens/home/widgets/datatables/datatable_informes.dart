import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:systex/config.dart';
import 'package:systex/models/informes.dart';
import 'package:systex/models/muestras.dart';
import 'package:systex/models/productores.dart';
import 'package:systex/services/api/http/muestrasHttp.dart';
import 'package:systex/services/responsive/responsive.dart';

class DataTableInformes extends StatefulWidget {
  List<Informes> informes;
  DataTableInformes({required this.informes});
  @override
  State<DataTableInformes> createState() => _DataTableInformesState();
}

class _DataTableInformesState extends State<DataTableInformes> {
  List<Informes> filteredInformes = [];
  TextEditingController searchController = TextEditingController();
  double columnSpacing = 150.0; // Valor predeterminado para columnSpacing

  @override
  void initState() {
    super.initState();

    filteredInformes =
        widget.informes; // Inicialmente mostramos todos los elementos

    // Calcular el ancho disponible en el dispositivo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double availableWidth = MediaQuery.of(context).size.width;
      if (availableWidth < 800) {
        // Si el ancho es menor a 800 (por ejemplo, en dispositivos móviles), aumentamos el columnSpacing
        setState(() {
          columnSpacing = 50.0;
        });
      }
    });
  }

  void filterMuestras(String query) {
    List<Informes> filteredList = widget.informes
        .where((informe) =>
            informe.codInforme.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredInformes = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            // Utilizamos un Row para alinear la barra de búsqueda hacia la izquierda
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.3, // Ajusta el ancho de la barra de búsqueda
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      filterMuestras(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Buscar informe',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: Responsive().calculateColumnSpacing(context, 6),
                horizontalMargin: 5,
                columns: const [
                  DataColumn(
                    label: Text('URL'),
                  ),
                  DataColumn(label: Text('FechaInforme')),
                  DataColumn(label: Text('CodMuestra')),
                  DataColumn(label: Text('Analisis')),
                  DataColumn(label: Text('Lote')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: filteredInformes.map((e) {
                  return DataRow(cells: [
                    DataCell(
                      SizedBox(
                        width:
                            100, // Ajusta este valor para cambiar el ancho de la celda URL
                        child: RichText(
                          text: TextSpan(
                            text: e.urlInforme,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchURL(e.urlInforme);
                              },
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(e.fecha)),
                    DataCell(
                      Text(e.id_muestra),
                    ),
                    DataCell(Text(e.nombre)),
                    DataCell(Text(e.lote)),
                    DataCell(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
