import 'package:flutter/material.dart';

class PopUpMoreInfo extends StatefulWidget {
  String tempAlmacenamiento;
  String nroTelefono;
  String razonSocial;
  String provincia;
  String localidad;
  String cuitEmpresa;
  String presentacion;
  String localidadEmpresa;
  String direccionEmpresa;
  String provinciaEmpresa;
  String tipoSolicitante;
  String dirElaboracion;
  String estilo;
  String producto;
  String fechaElaboracion;
  String analisisSolicitados;
  String fechaVencimiento;
  String nombreMuestra;
  String lote;

  PopUpMoreInfo(
      {required this.tempAlmacenamiento,
      required this.nroTelefono,
      required this.razonSocial,
      required this.provincia,
      required this.tipoSolicitante,
      required this.localidadEmpresa,
      required this.cuitEmpresa,
      required this.presentacion,
      required this.provinciaEmpresa,
      required this.direccionEmpresa,
      required this.localidad,
      required this.producto,
      required this.dirElaboracion,
      required this.analisisSolicitados,
      required this.estilo,
      required this.fechaElaboracion,
      required this.fechaVencimiento,
      required this.nombreMuestra,
      required this.lote});

  @override
  State<PopUpMoreInfo> createState() => _PopUpMoreInfoState();
}

class _PopUpMoreInfoState extends State<PopUpMoreInfo> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mas informacion'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ListTile(
                title: const Text('Temp.Almacenamiento'),
                subtitle: Text(widget.tempAlmacenamiento)),
            ListTile(
                title: const Text('Razon Analisis'),
                subtitle: Text(widget.razonSocial)),
            ListTile(
                title: const Text('NroTelefono'),
                subtitle: Text(widget.nroTelefono)),
            ListTile(
                title: const Text('Provincia'),
                subtitle: Text(widget.provincia)),
            ListTile(
                title: const Text('Localidad'),
                subtitle: Text(widget.localidad)),
            ListTile(
                title: const Text('Dir.Elaboracion'),
                subtitle: Text(widget.dirElaboracion)),
            ListTile(
                title: const Text('Estilo'), subtitle: Text(widget.estilo)),
            ListTile(
                title: const Text('fechaElaboracion'),
                subtitle: Text(widget.fechaElaboracion)),
            ListTile(
                title: const Text('Fecha Vencimiento'),
                subtitle: Text(widget.fechaVencimiento)),
            ListTile(
                title: const Text('Producto'), subtitle: Text(widget.producto)),
            ListTile(
                title: const Text('TipoSolicitante'),
                subtitle: Text(widget.tipoSolicitante)),
            ListTile(
                title: const Text('CUIT Empresa'),
                subtitle: Text(widget.cuitEmpresa)),
            ListTile(
                title: const Text('Direccion Empresa'),
                subtitle: Text(widget.direccionEmpresa)),
            ListTile(
                title: const Text('Provincia Empresa'),
                subtitle: Text(widget.provinciaEmpresa)),
          ],
        ),
      ),
    );
  }
}
