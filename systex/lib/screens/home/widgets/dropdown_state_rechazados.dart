import 'package:flutter/material.dart';

class DropdownStateRechazados extends StatefulWidget {
  String state;
  DropdownStateRechazados({required this.state});

  @override
  State<DropdownStateRechazados> createState() =>
      _DropdownStateRechazadosState();
}

class _DropdownStateRechazadosState extends State<DropdownStateRechazados> {
  late String selectedState;

  @override
  void initState() {
    super.initState();
    // Inicializa el valor seleccionado con el valor inicial proporcionado.
    selectedState = widget.state;
  }

  var states = ["Aprobado", "Rechazado"];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        dropdownColor: Colors.white,
        value: selectedState,
        items: states.map((e) {
          return DropdownMenuItem(child: Text(e), value: e);
        }).toList(),
        onChanged: (val) {
          setState(() {
            selectedState = val as String;
          });
        },
        itemHeight: 50);
  }
}
