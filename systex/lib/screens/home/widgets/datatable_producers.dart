import 'package:flutter/material.dart';
import 'package:systex/models/productores.dart';

class DataTableProducers extends StatefulWidget {
  List<Productor> productores;
  DataTableProducers({required this.productores});
  @override
  State<DataTableProducers> createState() => _DataTableProducersState();
}

class _DataTableProducersState extends State<DataTableProducers> {
  List<Productor> filteredProductores = [];
  TextEditingController searchController = TextEditingController();
  double columnSpacing = 100.0; // Valor predeterminado para columnSpacing

  @override
  void initState() {
    super.initState();
    filteredProductores =
        widget.productores; // Inicialmente mostramos todos los elementos
    print('lengthp' + widget.productores.length.toString());

    // Calcular el ancho disponible en el dispositivo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double availableWidth = MediaQuery.of(context).size.width;
      if (availableWidth < 800) {
        // Si el ancho es menor a 800 (por ejemplo, en dispositivos móviles), aumentamos el columnSpacing
        setState(() {
          columnSpacing = 150.0;
        });
      }
    });
  }

  void filterProductores(String query) {
    List<Productor> filteredList = widget.productores
        .where((productor) =>
            productor.nombre_y_apellido
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            productor.direccionElaboracion
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            productor.localidad.toLowerCase().contains(query.toLowerCase()) ||
            productor.provincia.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredProductores = filteredList;
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
                      filterProductores(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Buscar productor',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                  // Aquí puedes definir la acción del FAB
                  // Por ejemplo, agregar un nuevo productor
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: columnSpacing,
                    horizontalMargin:
                        5, // Aumenta el espacio entre las celdas del DataTable
                    columns: const [
                      DataColumn(label: Text('Nombre y Apellido')),
                      DataColumn(label: Text('Dir. Elaboracion')),
                      DataColumn(label: Text('Localidad')),
                      DataColumn(label: Text('Provincia')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: filteredProductores.map((e) {
                      return DataRow(cells: [
                        DataCell(Text(e.nombre_y_apellido)),
                        DataCell(Text(e.direccionElaboracion)),
                        DataCell(Text(e.localidad)),
                        DataCell(Text(e.provincia)),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
