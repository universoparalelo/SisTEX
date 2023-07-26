//datatable para ver solicitudes pendientes

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:systex/config.dart';
import 'package:systex/models/solicitudes.dart';
import 'package:systex/screens/home/widgets/popup_more_info.dart';

class DataTableSolicitudes extends StatefulWidget {
  List<Solicitudes> solicitudes;
  DataTableSolicitudes({required this.solicitudes});
  @override
  State<DataTableSolicitudes> createState() => _DataTableSolicitudesState();
}

class _DataTableSolicitudesState extends State<DataTableSolicitudes> {
  List<Solicitudes> filteredSolicitudes = [];
  TextEditingController searchController = TextEditingController();
  double columnSpacing = 75.0; // Valor predeterminado para columnSpacing

  @override
  void initState() {
    super.initState();
    filteredSolicitudes =
        widget.solicitudes; // Inicialmente mostramos todos los elementos
    print('lengthp' + widget.solicitudes.length.toString());

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
    List<Solicitudes> filteredList = widget.solicitudes
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
      filteredSolicitudes = filteredList;
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
                      labelText: 'Buscar pedido',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: columnSpacing,
                    horizontalMargin:
                        5, // Aumenta el espacio entre las celdas del DataTable
                    columns: const [
                      DataColumn(label: Text('MasInfo.')),
                      DataColumn(label: Text('FechaSolicitud')),
                      DataColumn(label: Text('Productor')),
                      DataColumn(label: Text('AnalisisSolicitados')),
                      DataColumn(label: Text('ComprobantePago')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: filteredSolicitudes.map((e) {
                      return DataRow(cells: [
                        DataCell(GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return PopUpMoreInfo(
                                    producto: e.producto,
                                    tempAlmacenamiento:
                                        e.temperaturaAlmacenamiento,
                                    nroTelefono: e.nroTelefono,
                                    razonSocial: e.razonAnalisis,
                                    dirElaboracion: e.direccionElaboracion,
                                    estilo: e.estilo,
                                    fechaElaboracion: e.fechaElaboracion,
                                    fechaVencimiento: e.fechaVencimiento,
                                    localidad: e.localidad,
                                    lote: e.lote,
                                    nombreMuestra: e.nombreMuestra,
                                    provincia: e.provincia,
                                  );
                                });
                          },
                          child: FaIcon(
                            FontAwesomeIcons.eye,
                            size: 12.0,
                          ),
                        )),
                        DataCell(Text(e.fechaSolicitud)),
                        DataCell(Text(e.nombre_y_apellido)),
                        DataCell(Text(e.analisisSolicitados)),
                        DataCell(Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: RichText(
                            text: TextSpan(
                              text: e.urlComprobantePago,
                              style: const TextStyle(
                                color: Colors.blue, // Color azul
                                decoration:
                                    TextDecoration.underline, // Subrayado
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchURL(e.urlComprobantePago);
                                },
                            ),
                          ),
                        )),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Rechazar'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 5.0),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Aprobar'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 5.0),
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
