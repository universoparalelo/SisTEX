import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:systex/models/muestras.dart';
import 'package:systex/services/services.dart';

class DropdownState extends StatefulWidget {
  String state;
  String nombreMuestra;
  String nombreProductor;
  String tipoAnalisis;
  String estilo;
  String telefono;
  String producto;
  String lote;
  String fecha_elab;
  String fecha_vencimiento;
  DropdownState(
      {required this.state,
      required this.nombreMuestra,
      required this.nombreProductor,
      required this.tipoAnalisis,
      required this.estilo,
      required this.fecha_elab,
      required this.fecha_vencimiento,
      required this.lote,
      required this.producto,
      required this.telefono});

  @override
  State<DropdownState> createState() => _DropdownStateState();
}

class _DropdownStateState extends State<DropdownState> {
  var states = ["Pendiente", "Rechazado", "Aceptado"];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.state,
      focusColor: Colors.white,
      dropdownColor: Colors.white,
      hint: const Text('Selecciona una opción'),
      onChanged: (String? val) async {
        setState(() {
          widget.state = val!;
        });
        if (widget.state == "Aceptado") {
          Muestra muestra = Muestra(
              nombreMuestra: widget.nombreMuestra,
              lote: widget.lote,
              nombre_productor: widget.nombreProductor,
              estilo: widget.estilo,
              fecha_elab: widget.fecha_elab,
              fecha_ingreso: DateTime.now().toString(),
              tipo_muestra: widget.producto);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
            children: const [
              CircularProgressIndicator(),
              Text('Aprobando solicitud')
            ],
          )));
          await Services().addMuestra(muestra).then((value) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              children: const [Text('Solicitud aprobada')],
            )));
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          });
        }
      },
      items: states.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
