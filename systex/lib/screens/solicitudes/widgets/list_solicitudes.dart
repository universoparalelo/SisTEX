import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:systex/models/solicitudes_productores.dart';
import 'package:systex/screens/solicitudes/widgets/dropdown_state.dart';
import 'package:systex/screens/solicitudes/widgets/show_more_data.dart';
import 'package:systex/utilities/dates.dart';
import 'package:systex/utilities/text_editing_controllers.dart';

import 'package:flutter/material.dart';

class ListSolicitudes extends StatefulWidget {
  List<SolicitudesProductores> solicitudes;
  ListSolicitudes({required this.solicitudes});
  @override
  State<ListSolicitudes> createState() => _ListSolicitudesState();
}

class _ListSolicitudesState extends State<ListSolicitudes> {
  List<SolicitudesProductores> searchResults = [];
  void search() {
    String searchTerm = solicitudController.text;

    List<SolicitudesProductores> filteredData = widget.solicitudes
        .where((element) => element.nombreyApellido
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
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          color: Colors.grey[100],
                          child: TextField(
                            controller: solicitudController,
                            onChanged: (val) => search(),
                            decoration: const InputDecoration(
                              hintText: 'Buscar solicitud',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // FloatingAction(widget.index)
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: widget.solicitudes.isEmpty
                      ? const Center(
                          child: Text(
                            'No hay solicitudes',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 22.0,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: 20.0,
                            columns: const [
                              DataColumn(
                                label: Flexible(
                                  child: Text(
                                    'Nombre y Apellido',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Flexible(
                                  child: Text(
                                    'Fecha Solicitud',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Flexible(
                                  child: Text(
                                    'Tipo Solicitud',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Flexible(
                                  child: Text(
                                    'Nombre Muestra',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Flexible(
                                  child: Text(
                                    'NroTelefono',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Flexible(
                                  child: Text(
                                    'Estilo',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Flexible(
                                  child: Text(
                                    'Producto',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Flexible(
                                  child: Text(
                                    'Temp. Almacenamiento',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Flexible(
                                  child: Text(
                                    'Estado',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Flexible(
                                  child: Text(
                                    'Acciones',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: solicitudController.text.isEmpty
                                ? widget.solicitudes
                                    .map(
                                      (element) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.nombreyApellido,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                convertirExcelFecha(
                                                  int.parse(
                                                    element.fecha_solicitud,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.tipo,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.nombreMuestra,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.nro_telefono,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.estilo,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.producto,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.temp_almacenamiento,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: DropdownState(
                                                state: element.estado,
                                                estilo: element.estilo,
                                                fecha_elab:
                                                    element.fecha_elaboracion,
                                                fecha_vencimiento:
                                                    element.fecha_vencimiento,
                                                lote: element.lote,
                                                nombreMuestra:
                                                    element.nombreMuestra,
                                                nombreProductor:
                                                    element.nombreyApellido,
                                                producto: element.producto,
                                                telefono: element.nro_telefono,
                                                tipoAnalisis: element.producto,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                                child: IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (ctx) {
                                                            return AlertDialog(
                                                              content:
                                                                  ShowMoreData(
                                                                localidad: element
                                                                    .localidad,
                                                                provincia: element
                                                                    .provincia,
                                                                direccion_elab:
                                                                    element
                                                                        .direccion_elaboracion,
                                                                comprobantePago:
                                                                    '',
                                                                fecha_vencimiento:
                                                                    element
                                                                        .fecha_vencimiento,
                                                                lote: element
                                                                    .lote,
                                                                precio_analisis:
                                                                    element
                                                                        .precio_total,
                                                                razon_analisis:
                                                                    element
                                                                        .razon_analisis,
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    icon: const Icon(Icons
                                                        .arrow_right_alt))),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList()
                                : searchResults
                                    .map(
                                      (element) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.nombreyApellido,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.fecha_solicitud,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.tipo,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.nombreMuestra,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.nro_telefono,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.estilo,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.producto,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Text(
                                                element.temp_almacenamiento,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Flexible(
                                              child: Row(
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
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
