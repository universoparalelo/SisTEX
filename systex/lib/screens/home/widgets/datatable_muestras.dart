import 'package:flutter/material.dart';
import 'package:systex/models/muestras.dart';
import 'package:systex/models/productores.dart';

class DataTableMuestras extends StatefulWidget {
  List<Muestras> muestras;
  DataTableMuestras({required this.muestras});
  @override
  State<DataTableMuestras> createState() => _DataTableMuestrasState();
}

class _DataTableMuestrasState extends State<DataTableMuestras> {
  List<Muestras> filteredMuestras = [];
  TextEditingController searchController = TextEditingController();
  double columnSpacing = 150.0; // Valor predeterminado para columnSpacing

  @override
  void initState() {
    super.initState();
    print('wg' + widget.muestras.toString());
    filteredMuestras =
        widget.muestras; // Inicialmente mostramos todos los elementos

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
    List<Muestras> filteredList = widget.muestras
        .where((muestra) =>
            muestra.nombreMuestra.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredMuestras = filteredList;
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
                      labelText: 'Buscar muestra',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: Colors.black,
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: columnSpacing,
                horizontalMargin:
                    5, // Aumenta el espacio entre las celdas del DataTable
                columns: const [
                  //DataColumn(label: Text('CodMuestra')),
                  DataColumn(label: Text('Nombre Muestra')),
                  DataColumn(label: Text('Lote')),
                  DataColumn(label: Text('Fecha Elaboracion')),
                  DataColumn(label: Text('Fecha Ingreso')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: filteredMuestras.map((e) {
                  return DataRow(cells: [
                    //DataCell(Text(e.idMuestra)),
                    DataCell(Text(e.nombreMuestra)),
                    DataCell(Text(e.lote)),
                    DataCell(Text(e.fechaElaboracion)),
                    DataCell(Text(e.fechaIngreso)),
                    DataCell(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
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
