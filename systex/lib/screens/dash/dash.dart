// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:systex/models/informes.dart';

import 'package:systex/models/muestras.dart';
import 'package:systex/models/producer.dart';
import 'package:systex/models/solicitudes_productores.dart';
import 'package:systex/screens/dash/widgets/floating_action.dart';
import 'package:systex/screens/dash/widgets/list_muestras.dart';
import 'package:systex/screens/dash/widgets/list_producers.dart';
import 'package:systex/screens/dash/widgets/selector_province.dart';
import 'package:systex/screens/dash/widgets/textfield_direction.dart';
import 'package:systex/screens/dash/widgets/textfield_location.dart';
import 'package:systex/screens/dash/widgets/textfield_name_producer.dart';
import 'package:systex/screens/informes/informes.dart';
import 'package:systex/screens/settings/settings.dart';
import 'package:systex/screens/solicitudes/solicitudes.dart';
import 'package:systex/services/services.dart';

List<Producer> producers = [];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isExpanded = false;
  int _selectedIndex = 0;

  List<Muestra> muestras = [];
  List<InformesMuestras> informes = [];
  List<SolicitudesProductores> solicitudes = [];
  @override
  void initState() {
    super.initState();
    init();
    //  ProducersController().getProducers();
  }

  Future<void> init() async {
    producers = await Services().getProducers();
    muestras = await Services().getMuestras();
    informes = await Services().getInformes();
    solicitudes = await Services().getSolicitudes();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationRail(
              extended: isExpanded,
              backgroundColor: const Color(0xFF262626), // Dark Gray
              unselectedIconTheme:
                  const IconThemeData(color: Colors.white, opacity: 1),
              unselectedLabelTextStyle: const TextStyle(
                color: Colors.white,
              ),
              selectedIconTheme: IconThemeData(color: Colors.grey[400]),
              destinations: [
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Productores',
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      icon: const Icon(Icons.person),
                    ),
                  ),
                  label: Text(
                    "Productores",
                    style: TextStyle(
                      color: _selectedIndex == 0 ? Colors.grey : Colors.white,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Muestras',
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          _selectedIndex = 1;
                        });
                        //muestras = await Services().getMuestras();
                        //setState(() {});
                      },
                      icon: const Icon(Icons.science),
                    ),
                  ),
                  label: Text(
                    "Muestras",
                    style: TextStyle(
                      color: _selectedIndex == 1 ? Colors.grey : Colors.white,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.file),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                    ),
                    message: 'Informes',
                  ),
                  label: Text("Informes",
                      style: TextStyle(
                        color: _selectedIndex == 2 ? Colors.grey : Colors.white,
                      )),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                      message: 'Solicitudes',
                      child: IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 3;
                          });
                        },
                      )),
                  label: Text("Solicitudes",
                      style: TextStyle(
                        color: _selectedIndex == 3 ? Colors.grey : Colors.white,
                      )),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 4;
                        });
                      },
                    ),
                    message: 'Ajustes',
                  ),
                  label: const Text("Ajustes"),
                ),
              ],
              selectedIndex: _selectedIndex,
            ),
            _selectedIndex == 0
                ? ListProducers(
                    isExpanded: isExpanded,
                    producers: producers,
                    index: _selectedIndex,
                  )
                : _selectedIndex == 1
                    ? ListMuestras(
                        muestras: muestras,
                        index: _selectedIndex,
                      )
                    : _selectedIndex == 2
                        ? Informes(
                            index: _selectedIndex, informesMuestras: informes)
                        : _selectedIndex == 3
                            ? Solicitudes(
                                solicitudes: solicitudes,
                              )
                            : Settings(),
          ],
        ));
  }
}
