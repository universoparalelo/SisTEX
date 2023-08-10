import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:systex/config.dart';
import 'package:systex/models/solicitudes.dart';
import 'package:systex/models/solicitudes_aprobadas.dart';
import 'package:systex/screens/home/widgets/dropdown_state.dart';
import 'package:systex/screens/home/widgets/popups/popup_more_info.dart';
import 'package:systex/services/responsive/responsive.dart';

class DataTableSolicitudesAprobadas extends StatefulWidget {
  List<SolicitudesAprobadas> solicitudes;
  DataTableSolicitudesAprobadas({required this.solicitudes});
  @override
  State<DataTableSolicitudesAprobadas> createState() =>
      _DataTableSolicitudesAprobadasState();
}

class _DataTableSolicitudesAprobadasState
    extends State<DataTableSolicitudesAprobadas> {
  List<SolicitudesAprobadas> filteredSolicitudes = [];
  TextEditingController searchController = TextEditingController();
  double columnSpacing = 75.0; // Valor predeterminado para columnSpacing

  @override
  void initState() {
    super.initState();
    filteredSolicitudes =
        widget.solicitudes; // Inicialmente mostramos todos los elementos

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
    List<SolicitudesAprobadas> filteredList = widget.solicitudes
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
    /*
    return ListView.builder(
        itemCount: widget.solicitudes.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(widget.solicitudes[index].nombreMuestra));
        });*/

    return Expanded(
        child: filteredSolicitudes.isEmpty
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(child: Text('Sin solicitudes')))
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  horizontalMargin: 5,
                  columnSpacing:
                      Responsive().calculateColumnSpacing(context, 6),
                  columns: const [
                    DataColumn(
                        label: Text('MasInfo.',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('FechaSolicitud',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Productor',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Estado',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    //  DataColumn(label: Text('ComprobantePago')),
                    DataColumn(label: Text('AnalisisSolicitados')),
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
                                  analisisSolicitados: e.analisisSolicitados,
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
                      DataCell(DropdownStateAprobados(
                        // state: e.estado,
                        solicitudes: e,
                      )),
                      /*
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
                )),*/
                      DataCell(Text(e.analisisSolicitados)),
                    ]);
                  }).toList(),
                ),
              ));
  }
}
