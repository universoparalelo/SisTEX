//datatable para ver solicitudes pendientes

// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:systex/config.dart';
import 'package:systex/models/solicitudes.dart';
import 'package:systex/models/tipos_muestras.dart';
import 'package:systex/screens/home/home.dart';
import 'package:systex/screens/home/widgets/popups/popup_approve_order.dart';
import 'package:systex/screens/home/widgets/popups/popup_more_info.dart';
import 'package:systex/services/api/http/solicitudesHttp.dart';

import 'package:systex/services/responsive/responsive.dart';

class DataTableSolicitudes extends StatefulWidget {
  List<Solicitudes> solicitudes;
  DataTableSolicitudes({required this.solicitudes});
  @override
  State<DataTableSolicitudes> createState() => _DataTableSolicitudesState();
}

class _DataTableSolicitudesState extends State<DataTableSolicitudes> {
  List<Solicitudes> filteredSolicitudes = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController motivo = TextEditingController();

  late ConnectionState state;

  @override
  void initState() {
    super.initState();

    filteredSolicitudes =
        widget.solicitudes; // Inicialmente mostramos todos los elementos
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

  var firebaseRef = FirebaseDatabase().ref().child('solicitudes');
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
          StreamBuilder<DatabaseEvent>(
              stream: firebaseRef.onValue,
              builder: ((context, snapshot) {
                print('snapdone' + snapshot.connectionState.toString());
                if (snapshot.connectionState == ConnectionState.active) {
                  print('mkj' + snapshot.hasData.toString());
                  if (snapshot.hasData) {
                    List<Solicitudes> solicitudesPendientes = [];
                    final data = snapshot.data;
                    print('dts' + data!.snapshot.value.toString());
                    if (snapshot.data!.snapshot.value != null) {
                      Object? mapaInternoObject = snapshot.data!.snapshot.value;
                      Map<String, dynamic>? mapaInterno;
                      Map<String, dynamic>? mapShow;
                      if (mapaInternoObject != null &&
                          mapaInternoObject is Map<dynamic, dynamic>) {
                        mapaInterno =
                            Map<String, dynamic>.from(mapaInternoObject);
                      } else {
                        print("El objeto no se puede convertir a un mapa.");
                      }

                      if (mapaInterno != null) {
                        print("Mapa Interno: $mapaInterno");
                        // Puedes trabajar con el mapaInterno y acceder a sus valores
                      } else {
                        print("No se encontró un mapa interno en los datos.");
                      }

                      for (var subMapa in mapaInterno!.values) {
                        if (subMapa is Map<String, dynamic>) {
                          mapShow = subMapa;
                          break;
                        }
                      }
                      List analisisSolicitados = [];
                      mapaInterno.forEach((clave, submapa) {
                        print("Clave: $clave");
                        print("Submapa: $submapa");
                        if (submapa is Map) {
                          print('es map');
                          if (submapa["analisis_solicitados"] is List) {
                            analisisSolicitados =
                                submapa["analisis_solicitados"];
                            print('mapa145' + analisisSolicitados.toString());
                          }
                        } else {
                          print('no es mapa');
                        }

                        for (int i = 0;
                            i <= analisisSolicitados.length - 1;
                            i++) {
                          Map mapa = analisisSolicitados[i];
                          submapa["analisis_solicitados"] =
                              mapa["nombre_analisis"];
                          submapa["parametros_solicitados"] =
                              mapa["parametros"]["nombre_parametros"];
                          Solicitudes solicitudPendiente =
                              Solicitudes.fromJson(submapa);

                          solicitudesPendientes.add(solicitudPendiente);
                        }
                      });
                      filteredSolicitudes = solicitudesPendientes;

                      return Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: FittedBox(
                              child: DataTable(
                            columnSpacing:
                                Responsive().calculateColumnSpacing(context, 7),
                            columns: const [
                              DataColumn(
                                  label: Text('MasInfo.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('FechaSolicitud',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Solicitante',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('AnalisisSolicitados',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Parametros a medir',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('ComprobantePago',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Acciones',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
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
                                            cuitEmpresa: e.cuitEmpresa,
                                            direccionEmpresa:
                                                e.direccionEmpresa,
                                            localidadEmpresa:
                                                e.localidadEmpresa,
                                            presentacion: e.presentacion,
                                            provinciaEmpresa:
                                                e.provinciaEmpresa,
                                            tipoSolicitante: e.tipoSolicitante,
                                            analisisSolicitados:
                                                e.analisisSolicitados,
                                            tempAlmacenamiento:
                                                e.temperaturaAlmacenamiento,
                                            nroTelefono: e.nroTelefono,
                                            razonSocial: e.razonAnalisis,
                                            dirElaboracion:
                                                e.direccionElaboracion,
                                            estilo: e.estilo,
                                            fechaElaboracion:
                                                e.fechaElaboracion,
                                            fechaVencimiento:
                                                e.fechaVencimiento,
                                            localidad: e.localidad,
                                            lote: e.lote,
                                            nombreMuestra: e.nombreMuestra,
                                            provincia: e.provincia,
                                          );
                                        });
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.eye,
                                    size: 12.0,
                                  ),
                                )),
                                DataCell(Text(e.fechaSolicitud)),
                                DataCell(Text(e.nombre_y_apellido)),
                                DataCell(Text(e.analisisSolicitados)),
                                DataCell(Text(e.parametrosSolicitados)),
                                DataCell(Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: RichText(
                                    text: TextSpan(
                                      text: e.urlComprobantePago,
                                      style: const TextStyle(
                                        color: Colors.blue, // Color azul
                                        decoration: TextDecoration
                                            .underline, // Subrayado
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
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Rechazo de muestra'),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: Center(
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 0, 20, 0),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      child: TextField(
                                                        controller: motivo,
                                                        decoration:
                                                            const InputDecoration(
                                                                hintText:
                                                                    '¿Cual es el motivo del rechazo?'),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        Map<String, dynamic>
                                                            data = {};
                                                        data["id_solicitud"] =
                                                            e.idSolicitud;
                                                        data["Estado"] =
                                                            "Rechazado";
                                                        data["motivo"] =
                                                            motivo.text;
                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            builder: (ctx) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Tarea en progreso...'),
                                                                content:
                                                                    SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.4,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.4,
                                                                  child:
                                                                      FutureBuilder<
                                                                          String>(
                                                                    future: SolicitudesHttp()
                                                                        .updateSolicitud(
                                                                            data),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      state = snapshot
                                                                          .connectionState;
                                                                      if (snapshot
                                                                              .connectionState ==
                                                                          ConnectionState
                                                                              .done) {
                                                                        return const Center(
                                                                          child:
                                                                              Text('Tarea completada'),
                                                                        );
                                                                      }
                                                                      return Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: const [
                                                                          SizedBox(
                                                                              height: 35,
                                                                              width: 35,
                                                                              child: CircularProgressIndicator()),
                                                                          SizedBox(
                                                                              height: 10.0),
                                                                          Text(
                                                                              'Rechazando muestra..'),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          selectedOption =
                                                                              "Rechazados";
                                                                        });
                                                                        solicitudes_rechazadas =
                                                                            await SolicitudesHttp().getAllSolicitudesRechazadas();
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          'Aceptar'))
                                                                ],
                                                              );
                                                            });

                                                        motivo.clear();
                                                      },
                                                      child: const Text(
                                                          'Aceptar')),
                                                ],
                                              );
                                            });
                                      },
                                      // ignore: prefer_const_constructors, sort_child_properties_last
                                      child: const Text('Rechazar'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          textStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 5.0),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Map<String, dynamic> data = {};

                                        data["id_solicitud"] = e.idSolicitud;
                                        data["Estado"] = "Aprobado";
                                        data["motivo"] = "-";
                                        print('idSolicitud' + e.idSolicitud);
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return PopUpAprroveOrder(
                                                data: data,
                                              );
                                            });
                                      },
                                      // ignore: prefer_const_constructors, sort_child_properties_last
                                      child: Text('Aprobar'),
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
                          )),
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: Text('Sin solicitudes pendientes')),
                          ],
                        ),
                      );
                    }
                  }
                }
                return Center(child: CircularProgressIndicator());
              })),
        ],
      ),
    );
  }
}
