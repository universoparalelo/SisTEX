// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:systex/config.dart';
import 'package:systex/models/solicitudes_rechazadas.dart';
import 'package:systex/screens/home/widgets/dropdown_state.dart';
import 'package:systex/screens/home/widgets/dropdown_state_rechazados.dart';

import 'package:systex/screens/home/widgets/popups/popup_more_info.dart';
import 'package:systex/services/responsive/responsive.dart';

class DataTableSolicitudesRechazadas extends StatefulWidget {
  List<SolicitudesRechazadas> solicitudes;
  DataTableSolicitudesRechazadas({required this.solicitudes});
  @override
  State<DataTableSolicitudesRechazadas> createState() =>
      _DataTableSolicitudesRechazadasState();
}

class _DataTableSolicitudesRechazadasState
    extends State<DataTableSolicitudesRechazadas> {
  List<SolicitudesRechazadas> filteredSolicitudes = [];
  TextEditingController searchController = TextEditingController();
  double columnSpacing = 50.0; // Valor predeterminado para columnSpacing

  @override
  void initState() {
    super.initState();
    filteredSolicitudes =
        widget.solicitudes; // Inicialmente mostramos todos los elementos
    print('lengthp88' + widget.solicitudes.length.toString());

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

  void filterSolicitudes(String query) {
    List<SolicitudesRechazadas> filteredList = widget.solicitudes
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
                      filterSolicitudes(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Buscar solicitud',
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
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: DataTable(
                  columnSpacing:
                      Responsive().calculateColumnSpacing(context, 7),
                  horizontalMargin:
                      5, // Aumenta el espacio entre las celdas del DataTable
                  columns: const [
                    DataColumn(
                        label: Text('MasInfo.',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('FechaSolicitud',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Solicitante',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Motivo',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('AnalisisSolicitados',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('ComprobantePago',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Estado',
                            style: TextStyle(fontWeight: FontWeight.bold))),
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
                                  analisisSolicitados: e.analisisSolicitados,
                                  cuitEmpresa: e.cuitEmpresa,
                                  direccionEmpresa: e.direccionEmpresa,
                                  localidadEmpresa: e.localidadEmpresa,
                                  presentacion: e.presentacion,
                                  provinciaEmpresa: e.provinciaEmpresa,
                                  tipoSolicitante: e.tipoSolicitante,
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
                      DataCell(Text(e.motivo)),
                      DataCell(Text(e.analisisSolicitados)),
                      DataCell(Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: RichText(
                          text: TextSpan(
                            text: e.urlComprobantePago,
                            style: const TextStyle(
                              color: Colors.blue, // Color azul
                              decoration: TextDecoration.underline, // Subrayado
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchURL(e.urlComprobantePago);
                              },
                          ),
                        ),
                      )),
                      DataCell(DropdownStateRechazados(
                        state: e.estado,
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
