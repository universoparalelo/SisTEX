import 'package:flutter/material.dart';
import 'package:systex/models/solicitudes_productores.dart';
import 'package:systex/screens/solicitudes/widgets/list_solicitudes.dart';

class Solicitudes extends StatefulWidget {
  List<SolicitudesProductores> solicitudes;
  Solicitudes({required this.solicitudes});
  @override
  State<Solicitudes> createState() => _SolicitudesState();
}

class _SolicitudesState extends State<Solicitudes> {
  @override
  Widget build(BuildContext context) {
    return ListSolicitudes(solicitudes: widget.solicitudes);
  }
}
