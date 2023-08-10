import 'package:flutter/material.dart';
import 'package:systex/models/solicitudes_aprobadas.dart';
import 'package:systex/screens/home/widgets/popups/dialog_pdf.dart';

class DropdownStateAprobados extends StatefulWidget {
  //String state;
  SolicitudesAprobadas solicitudes;
  DropdownStateAprobados({required this.solicitudes});

  @override
  State<DropdownStateAprobados> createState() => _DropdownStateAprobadosState();
}

class _DropdownStateAprobadosState extends State<DropdownStateAprobados> {
  late String selectedState;

  @override
  void initState() {
    super.initState();
    // Inicializa el valor seleccionado con el valor inicial proporcionado.
    selectedState = widget.solicitudes.estado;
    print('state12' + widget.solicitudes.analisisSolicitados);
  }

  var states = ["A iniciar", "En curso", "Finalizado"];

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
        if (selectedState == "Finalizado") {
          showDialog(
              context: context,
              builder: (ctx) {
                return DialogPDF(solicitudAprobada: widget.solicitudes);
              });
        }
      },
    );
  }
}
