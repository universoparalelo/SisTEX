// ignore_for_file: use_build_context_synchronously

//import 'dart:html' as hm;
//import 'package:universal_html/html.dart' as hm;
import 'dart:io';

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:systex/models/parametro.dart';
import 'package:systex/models/parametrosElegidos.dart';
import 'package:systex/models/productores.dart';

import 'package:systex/models/solicitudes_aprobadas.dart';
import 'package:systex/screens/home/home.dart';

import 'package:systex/services/api/http/informesHttp.dart';
import 'package:systex/services/api/http/parametrosHttp.dart';
import 'package:systex/services/api/http/pdf_http.dart';
import 'package:systex/services/api/http/productoresHttp.dart';
import 'package:url_launcher/url_launcher.dart';

List<ParametrosElegidos> parametrosElegidos = [];
List<String> nombresParametros = [];
late List<bool> checkboxesGen;
late List<TextEditingController?> textfieldValues;
late Future<List<Parametro>> parametrosList;

class DialogPDF extends StatefulWidget {
  SolicitudesAprobadas solicitudAprobada;
  DialogPDF({required this.solicitudAprobada});
  @override
  State<DialogPDF> createState() => _DialogPDFState();
}

class _DialogPDFState extends State<DialogPDF> {
  List<Productor> productores = [];
  List<Parametro> parametros = [];
  List<int> bytes = [];
  @override
  void initState() {
    super.initState();
    getDireccionElaboracion();
  }

  Future<void> getDireccionElaboracion() async {
    productores = await ProductoresHttp()
        .searchProductor(widget.solicitudAprobada.nombre_y_apellido);
    print('direccionE' + productores[0].direccionElaboracion);
  }

  void addFooterToPdf(PdfPage page, String footerText) {
    // Calculate the height of the current page
    final double pageHeight = page.getClientSize().height;

    // Create a PDF text element for the footer
    final PdfTextElement footer = PdfTextElement(
      text: footerText,
      font: PdfStandardFont(PdfFontFamily.helvetica, 10),
    );

    // Get the PDF graphics context for the page
    final PdfGraphics graphics = page.graphics;

    // Calculate the width of the footer text
    final double fontSize = 10;
    final double footerWidth = footerText.length * fontSize * 0.5;

    // Calculate the position to place the footer text at the center of the page
    final double footerX = (page.getClientSize().width - footerWidth) / 2;
    final double footerY = pageHeight - 50; // Adjust this value as needed
    PdfFontStyle style = PdfFontStyle.bold;
    // Draw the footer text at the calculated position
    graphics.drawString(
      footerText,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(0, 740, page.getClientSize().width, 100),
    );
  }

  Future<void> generateAndOpenPdf(ParametrosElegidos param) async {
    print('mkd' + param.parametro);
    // Create a new PDF document.
    List<Productor> prod = await ProductoresHttp()
        .searchProductor(widget.solicitudAprobada.nombre_y_apellido);
    final PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    PdfStringFormat formatDateHeader = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.top,
    );

    final data = await rootBundle.load('assets/images/logo_pdf.png');
    Uint8List img =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    graphics.drawImage(PdfBitmap(img), Rect.fromLTWH(0, 0, 0, 0));

    final dataFirma = await rootBundle.load('assets/images/firma.png');
    Uint8List imgFirma = dataFirma.buffer
        .asUint8List(dataFirma.offsetInBytes, dataFirma.lengthInBytes);

    graphics.drawImage(PdfBitmap(imgFirma), Rect.fromLTWH(350, 650, 0, 0));

    String month = "";
    String year = DateTime.now().year.toString();
    String day = DateTime.now().day.toString();

    switch (DateTime.now().month) {
      case 1:
        month = "Enero";
        break;
      case 2:
        month = "Febrero";
        break;
      case 3:
        month = "Marzo";
        break;
      case 4:
        month = "Abril";
        break;
      case 5:
        month = "Mayo";
        break;
      case 6:
        month = "Junio";
        break;
      case 7:
        month = "Julio";
        break;
      case 8:
        month = "Agosto";
        break;
      case 9:
        month = "Septiembre";
        break;
      case 10:
        month = "Octubre";
        break;
      case 11:
        month = "Noviembre";
        break;
      case 12:
        month = "Diciembre";
        break;
    }

    String fechaHoy = "Resistencia, ${day} de ${month} de ${year}";

    String title = "Servicio de Asistencia Técnica";
    String subtitle =
        "Análisis de parámetros fisicoquímicos en la bebida alcohólica ${widget.solicitudAprobada.nombreMuestra}";
    PdfStringFormat formatDate = PdfStringFormat(
      alignment: PdfTextAlignment.right,
      lineAlignment: PdfVerticalAlignment.top,
    );

    PdfStringFormat formatTitles = PdfStringFormat(
      alignment: PdfTextAlignment.center,
      lineAlignment: PdfVerticalAlignment.top,
    );

    PdfStringFormat formatTitleResult = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.bottom,
    );

    graphics.drawString(fechaHoy, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatDate,
        bounds: Rect.fromLTWH(0, 40, page.getClientSize().width, 100));

    PdfFontStyle style = PdfFontStyle.bold;

    graphics.drawString(
        title, PdfStandardFont(PdfFontFamily.helvetica, 12, style: style),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitles,
        bounds: Rect.fromLTWH(0, 70, page.getClientSize().width, 100));

    graphics.drawString(
        subtitle, PdfStandardFont(PdfFontFamily.helvetica, 12, style: style),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitles,
        bounds: Rect.fromLTWH(0, 95, page.getClientSize().width, 100));

    String paragraphText =
        'El Sr. ${widget.solicitudAprobada.nombre_y_apellido} responsable de la bebida alcohólica ${widget.solicitudAprobada.nombreMuestra} '
        'solicitó al grupo UTN QuiTEx el análisis de un (1) lote de la bebida alcohólica ${widget.solicitudAprobada.producto} para evaluar los parámetros fisicoquímicos de su bebida. '
        'La muestra fue recolectada por el elaborador.';
    PdfStringFormat format = PdfStringFormat(
      alignment: PdfTextAlignment.center,
      lineAlignment: PdfVerticalAlignment.top,
    );

    PdfStringFormat formatTitleMetodology = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.top,
    );

    graphics.drawString(
        paragraphText, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: format,
        bounds: Rect.fromLTWH(0, 120, page.getClientSize().width, 100));

    // Agregar un espacio adicional para separar el párrafo de la tabla
    double spaceAfterParagraph = 10;

    // Add a table to the PDF.
    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 4);
    grid.headers.add(1);

    //Add rows to grid
    PdfGridRow header = grid.headers[0];

    header.cells[0].value = "Fecha de elaboracion";
    header.cells[1].value = "Estilo";
    header.cells[2].value = "Direccion de elaboracion";
    header.cells[3].value = "Lote";

    //Add header style
    header.style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = widget.solicitudAprobada.fechaElaboracion;
    row.cells[1].value = widget.solicitudAprobada.estilo;
    row.cells[2].value = prod[0].direccionElaboracion;
    row.cells[3].value = widget.solicitudAprobada.lote;

    //Add rows style
    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 10, right: 3, top: 4, bottom: 5),
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );

    // Draw the table on the same page below the paragraph
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 200, page.getClientSize().width, 0));

    String titleResults = "RESULTADOS DEL ANÁLISIS FISICOQUÍMICO";

    graphics.drawString(titleResults,
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: style),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitleResult,
        bounds: Rect.fromLTWH(0, 240, page.getClientSize().width, 100));

    // Add a second table to the PDF.
    PdfGrid grid2 = PdfGrid();
    grid2.columns.add(count: 2);
    grid2.headers.add(1);

// Add header to the second table
    PdfGridRow header2 = grid2.headers[0];
    header2.cells[0].value = "Análisis";
    header2.cells[1].value = "Resultados obtenidos";

// Add header style for the second table
    header2.style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );

    for (int i = 0; i <= parametrosElegidos.length - 1; i++) {
      PdfGridRow row21 = grid2.rows.add();
      row21.cells[0].value = parametrosElegidos[i].parametro;
      row21.cells[1].value = parametrosElegidos[i].valor;
    }

// Add rows style for the second table
    grid2.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 10, right: 3, top: 4, bottom: 5),
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );

// Draw the second table on the same page below the title
    grid2.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 360, page.getClientSize().width, 0),
    );

    // Calculate the total height after adding the content
    double metodologyTitleY =
        550; // Adjust the value based on your desired space
    double detailMetodologyY =
        metodologyTitleY + 20; // Adjust the value based on your desired space
    double newPageHeight =
        detailMetodologyY + 100; // Adjust the value based on your desired space

    // Position metodologyTitle and detailMetodology according to the calculated heights
    String metodologyTitle = "METODOLOGIA EMPLEADA";
    String detailMetodology =
        'Se tomaron como referencia las normas internacionales, ASBC (American Society of Brewing Chemists), '
        'EBC (European Brewery Convention) y MEBAK (Mitteleuropäische Brautechnische Analysenkommission) '
        'de acuerdo con la técnica empleada';

    graphics.drawString(
      metodologyTitle,
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: style),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      format: formatTitleMetodology,
      bounds:
          Rect.fromLTWH(0, metodologyTitleY, page.getClientSize().width, 100),
    );

    graphics.drawString(
      detailMetodology,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      format: formatTitleMetodology,
      bounds:
          Rect.fromLTWH(0, detailMetodologyY, page.getClientSize().width, 100),
    );
    String footerText =
        'ACLARACIÓN: Los Resultados obtenidos corresponden exclusivamente a la muestra recibida y analizada. '
        ' La Institución no se responsabiliza por el uso incorrecto que se hiciera de los mismos.';

    addFooterToPdf(page, footerText);
    // Save the document.
    bytes = await document.save();
    int randomNumber = Random().nextInt(100);
    // Download document
    /*
    try {
      hm.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}",
      )
        ..setAttribute("download",
            "${randomNumber}-${widget.solicitudAprobada.nombreMuestra}-${month}.pdf")
        ..click();
    } catch (e) {
      print('errorM' + e.toString());
    }*/

    await InformesHttp().addInforme(
        widget.solicitudAprobada.lote,
        widget.solicitudAprobada.nombreMuestra,
        widget.solicitudAprobada.nombre_y_apellido,
        bytes,
        widget.solicitudAprobada.analisisSolicitados);

    // Dispose the document
    document.dispose();

    parametrosElegidos.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generacion de informe'),
      content: FutureBuilder<void>(
          future: getDireccionElaboracion(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                    //width: MediaQuery.of(context).size.width * 0.50,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Datos de elaboracion'),
                        const SizedBox(height: 5.0),
                        // ignore: prefer_const_literals_to_create_immutables
                        DataTable(
                            border: TableBorder.all(color: Colors.black),
                            columns: const [
                              DataColumn(label: Text('Fecha elaboracion')),
                              DataColumn(label: Text('Estilo')),
                              DataColumn(label: Text('Direccion elaboracion')),
                              DataColumn(label: Text('Lote'))
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text(
                                    widget.solicitudAprobada.fechaElaboracion)),
                                DataCell(Text(widget.solicitudAprobada.estilo)),
                                DataCell(
                                    Text(productores[0].direccionElaboracion)),
                                DataCell(Text(widget.solicitudAprobada.lote)),
                              ])
                            ]),
                        Expanded(child: FutureBuilderParametros()),
                      ],
                    )),
              );
            }
            return Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: const CircularProgressIndicator()));
          }),
      actions: [
        ElevatedButton(
            onPressed: () async {
              for (int i = 0; i <= checkboxesGen.length - 1; i++) {
                if (checkboxesGen[i] == true) {
                  ParametrosElegidos param = ParametrosElegidos(
                      parametro: nombresParametros[i],
                      valor: textfieldValues[i]!.text);
                  parametrosElegidos.add(param);

                  print('parametro: ' + param.parametro);
                }
              }

              await generateAndOpenPdf(parametrosElegidos[0])
                  .then((value) async {
                informes = await InformesHttp().getInformes();
              });
            },
            child: const Text('Generar Informe')),
      ],
    );
  }
}

class FutureBuilderParametros extends StatefulWidget {
  FutureBuilderParametros({Key? key}) : super(key: key);

  @override
  State<FutureBuilderParametros> createState() =>
      _FutureBuilderParametrosState();
}

class _FutureBuilderParametrosState extends State<FutureBuilderParametros> {
  TextEditingController valueParameter = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkboxesGen = [];
    textfieldValues = [];
    parametrosList = ParametrosHttp().getAllParametros();
  }

  Widget checkbox(int index, String parametro) {
    return Checkbox(
      value: checkboxesGen[index],
      onChanged: (newValue) {
        setState(() {
          checkboxesGen[index] = newValue!;
        });
        //if (checkboxesGen[index] == false) {
        //   nombresParametros.remove(parametro);
        // } else {
        //    nombresParametros.add(parametro);
        //   }

        //print('nombresPam' + nombresParametros.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataTable();
  }

  Widget _buildDataTable() {
    return FutureBuilder<List<Parametro>>(
      future: parametrosList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          for (int i = 0; i <= snapshot.data!.length - 1; i++) {
            nombresParametros.add(snapshot.data![i].parametro);
          }
          // Verificar si las listas están vacías antes de inicializarlas
          if (checkboxesGen.isEmpty) {
            checkboxesGen =
                List.generate(snapshot.data!.length, (index) => false);
          }
          if (textfieldValues.isEmpty) {
            textfieldValues = List.generate(
              snapshot.data!.length,
              (index) => TextEditingController(
                text: '', // Establecer el valor inicial como cadena vacía
              ),
            );
          }

          return DataTable(
            horizontalMargin: 80,
            columnSpacing: 50.0,
            columns: const [
              DataColumn(label: Text('Parametro')),
              DataColumn(label: Text('¿Se midio?')),
              DataColumn(label: Text('Valor')),
            ],
            rows: List<DataRow>.generate(
              snapshot.data!.length,
              (index) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(snapshot.data![index].parametro)),
                  DataCell(
                    checkbox(
                      index,
                      snapshot.data![index].parametro,
                    ),
                  ),
                  DataCell(
                    TextFormField(
                      controller: textfieldValues[index],
                      enabled: checkboxesGen[
                          index], // Habilitar o deshabilitar el campo de texto según el valor del checkbox
                      onChanged: (newValue) {
                        setState(() {
                          textfieldValues[index]!.text = newValue;
                          // Obtener la posición actual del cursor
                          final currentCursorPos =
                              textfieldValues[index]!.selection;
                          // Actualizar el texto del controlador
                          textfieldValues[index]!.value =
                              textfieldValues[index]!.value.copyWith(
                                    text: newValue,
                                    // Restaurar la posición del cursor al final del texto
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: newValue.length),
                                    ),
                                  );
                        });
                      },
                      key: ValueKey(textfieldValues[index]),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.20,
            height: MediaQuery.of(context).size.height * 0.2,
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
