import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:systex/models/informes.dart';
import 'package:systex/models/muestras.dart';
import 'package:systex/models/productores.dart';
import 'package:systex/models/solicitudes.dart';
import 'package:systex/models/solicitudes_aprobadas.dart';
import 'package:systex/models/solicitudes_rechazadas.dart';
import 'package:systex/models/tipos_muestras.dart';

import 'package:systex/screens/home/widgets/datatables/datatable_aprobados.dart';
import 'package:systex/screens/home/widgets/datatables/datatable_informes.dart';
import 'package:systex/screens/home/widgets/datatables/datatable_muestras.dart';
import 'package:systex/screens/home/widgets/datatables/datatable_personal.dart';
import 'package:systex/screens/home/widgets/datatables/datatable_producers.dart';
import 'package:systex/screens/home/widgets/datatables/datatable_rechazados.dart';
import 'package:systex/screens/home/widgets/datatables/datatable_solicitudes.dart';
import 'package:systex/screens/home/widgets/settings.dart';
import 'package:systex/services/api/http/informesHttp.dart';
import 'package:systex/services/api/http/muestrasHttp.dart';
import 'package:systex/services/api/http/productoresHttp.dart';
import 'package:systex/services/api/http/solicitudesHttp.dart';
import 'package:systex/services/api/http/tipomuestrasHttp.dart';
import 'package:systex/services/api/http/userHttp.dart';

Key refreshKey = UniqueKey();
List<Productor> productores = [];
List<Muestras> muestras = [];
List<Informes> informes = [];
List<TipoMuestras> tiposMuestras = [];
List<Solicitudes> solicitudes = [];
List<SolicitudesRechazadas> solicitudes_rechazadas = [];
List<SolicitudesAprobadas> solicitudes_aprobadas = [];
String selectedOption = 'Opción 1';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoaded = false;

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  Future<void> initData() async {
    productores = await ProductoresHttp().getAllProductores();
    print('pr123' + productores.toString());
    muestras = await MuestrasHttp().getAllMuestras();
    informes = await InformesHttp().getInformes();
    try {
      solicitudes_aprobadas =
          await SolicitudesHttp().getAllSolicitudesAprobadas();
    } catch (e) {
      print('grave errror:' + e.toString());
    }
    try {
      solicitudes_rechazadas =
          await SolicitudesHttp().getAllSolicitudesRechazadas();
      print('lengthR' + solicitudes_rechazadas.length.toString());
    } catch (e) {
      print('grave errror2:' + e.toString());
    }

    // print('aprobadasS' + solicitudes_aprobadas.toString());
    // solicitudes = await SolicitudesHttp().getAllSolicitudes();
    tiposMuestras = await TipoMuestrasHttp().getAllTiposAnalisis();
  }

  @override
  void initState() {
    super.initState();

    initData().then((_) {
      setState(() {
        isDataLoaded = true; // Marcamos que los datos han sido cargados
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        key: refreshKey,
        children: [
          // Primera división - Menú
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            color: const Color(0xFF4CAF50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contenedor verde para el mensaje de bienvenida y nombre de usuario
                Container(
                  color: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  child: const Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                // Opciones del menú
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  title: const Text(
                    'Productores',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  onTap: () => selectOption('Opción 1'),
                ),

                ListTile(
                  leading: const Icon(
                    Icons.science,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  title: const Text('Muestras',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () => selectOption('Opción 2'),
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.folderOpen,
                      color: Colors.white, size: 20.0),
                  title: const Text('Informes',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () => selectOption('Opción 3'),
                ),
                ExpansionTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Pedidos',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  collapsedTextColor: Colors
                      .white, // Color del texto en el título cuando está contraído
                  backgroundColor:
                      const Color(0xFF4CAF50), // Color del fondo del título
                  onExpansionChanged: (expanded) {
                    // Acción cuando se expande o contrae el ExpansionTile
                    if (expanded) {
                      setState(() {
                        selectedOption =
                            ''; // Reiniciamos la opción seleccionada cuando se expande
                      });
                    }
                  },
                  children: [
                    ListTile(
                      title: const Text('Rechazados',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      onTap: () {
                        setState(() {
                          selectedOption =
                              'Rechazados'; // Actualizamos la opción seleccionada al tocar el ListTile
                        });
                      },
                      selected: selectedOption == 'Rechazados',
                    ),
                    ListTile(
                      title: const Text('Aprobados',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      onTap: () {
                        setState(() {
                          selectedOption =
                              'Aprobados'; // Actualizamos la opción seleccionada al tocar el ListTile
                        });
                      },
                      selected: selectedOption == 'Aprobados',
                    ),
                    ListTile(
                      title: const Text('Pendientes',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      onTap: () {
                        setState(() {
                          selectedOption =
                              'Pendientes'; // Actualizamos la opción seleccionada al tocar el ListTile
                        });
                      },
                      selected: selectedOption == 'Pendientes',
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  title: const Text(
                    'Personal',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  onTap: () => selectOption('Personal'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  title: const Text('Ajustes',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () => selectOption('Opción 4'),
                ),

                const Spacer(),
                ListTile(
                  leading: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  title: const Text('Cerrar Sesion',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () => selectOption('Opción 5'),
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                color: Colors.white,
                padding: const EdgeInsets.all(5.0),
                child: isDataLoaded
                    ? (selectedOption == "Opción 1"
                        ? DataTableProducers(
                            productores: productores,
                          )
                        : selectedOption == "Opción 2"
                            ? DataTableMuestras(
                                muestras: muestras,
                              )
                            : selectedOption == "Opción 3"
                                ? DataTableInformes(informes: informes)
                                : selectedOption == "Pendientes"
                                    ? DataTableSolicitudes(
                                        solicitudes: solicitudes)
                                    : selectedOption == "Aprobados"
                                        ? DataTableSolicitudesAprobadas(
                                            solicitudes: solicitudes_aprobadas)
                                        : selectedOption == "Rechazados"
                                            ? DataTableSolicitudesRechazadas(
                                                solicitudes:
                                                    solicitudes_rechazadas,
                                              )
                                            : selectedOption == "Personal"
                                                ? DataTablePersonal()
                                                : selectedOption == "Opción 4"
                                                    ? Settings(
                                                        tiposanalisis:
                                                            tiposMuestras,
                                                      )
                                                    : null)
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
