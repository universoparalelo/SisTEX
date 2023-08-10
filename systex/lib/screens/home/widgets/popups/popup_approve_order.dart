// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:systex/screens/home/home.dart';
import 'package:systex/services/api/http/muestrasHttp.dart';
import 'package:systex/services/api/http/solicitudesHttp.dart';

class PopUpAprroveOrder extends StatefulWidget {
  Map<String, dynamic> data;
  PopUpAprroveOrder({required this.data});

  @override
  State<PopUpAprroveOrder> createState() => _PopUpAprroveOrderState();
}

class _PopUpAprroveOrderState extends State<PopUpAprroveOrder> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> deletePendSolicitud() async {
    try {
      await SolicitudesHttp()
          .deleteSolicitudByID(widget.data["id_solicitud"])
          .then((value) {
        setState(() async {
          solicitudes = await SolicitudesHttp().getAllSolicitudes();
        });
      });
    } catch (e) {
      print('ERROR: ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Aprobacion en progreso..'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width * 0.3,
        child: FutureBuilder<void>(
          future: SolicitudesHttp().updateSolicitud(widget.data),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SizedBox(
                    height:
                        30, // Ajusta aquí el tamaño deseado del CircularProgressIndicator
                    width:
                        30, // Ajusta aquí el tamaño deseado del CircularProgressIndicator
                    child: CircularProgressIndicator(
                      strokeWidth: 2, // Ajusta aquí el ancho del círculo
                    ),
                  ),
                  Text('Por favor espere...'),
                ],
              );
            } else {
              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Ocurrio un error durante la tarea'),
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        'La aprobacion de la solicitud se ha completado con éxito!'),
                  ],
                );
              }
            }
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            await deletePendSolicitud().then((value) => {
                  setState(() {
                    selectedOption = "Aprobados";
                  }),
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()))
                });

            /*
            setState(() {
              selectedOption = "Aprobados";
            });
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));*/
          },
          child: Text('Aceptar'),
        )
      ],
    );
  }
}
