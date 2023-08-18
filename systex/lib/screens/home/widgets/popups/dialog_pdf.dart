// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last

import 'dart:html' as hm;
//import 'package:universal_html/html.dart' as hm;
import 'dart:io';

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:im_stepper/stepper.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:systex/models/parametro.dart';
import 'package:systex/models/parametrosElegidos.dart';
import 'package:systex/models/personal.dart';
import 'package:systex/models/productores.dart';

import 'package:systex/models/solicitudes_aprobadas.dart';
import 'package:systex/screens/home/home.dart';

import 'package:systex/services/api/http/informesHttp.dart';
import 'package:systex/services/api/http/parametrosHttp.dart';
import 'package:systex/services/api/http/pdf_http.dart';
import 'package:systex/services/api/http/personalHttp.dart';
import 'package:systex/services/api/http/productoresHttp.dart';
import 'package:systex/services/responsive/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

List<ParametrosElegidos> parametrosElegidos = [];
List<String> nombresParametros = [];
String typeAnalisis = "fisicoquímicos";
late List<bool> checkboxesGen;
late List<TextEditingController?> textfieldValues;
late Future<List<Parametro>> parametrosList;
List<TextEditingController?> nLotes = [];
List<bool> checkboxesResp = [];
List<bool> checkboxesColab = [];
List<bool> direction = [];

List<String> analistasResp = [];
List<String> analistasColab = [];
List<String> direccion = [];

String detailMetodology =
    'Se tomaron como referencia las normas internacionales, ASBC (American Society of Brewing Chemists), '
    'EBC (European Brewery Convention) y MEBAK (Mitteleuropäische Brautechnische Analysenkommission) '
    'de acuerdo con la técnica empleada';

//valor inicial (nutricional)
String observaciones =
    'Las muestras se conservan en el laboratorio por un período de 10 días después de la fecha de informado, salvo '
    'muestras perecederas o muestras en las que el cliente notifique expresamente que sean devueltas. '
    'Los resultados expresados, corresponden exclusivamente a la muestra analizada correspondiente al lote '
    'informado por la empresa. ';

class DialogPDF extends StatefulWidget {
  SolicitudesAprobadas solicitudAprobada;
  DialogPDF({required this.solicitudAprobada});
  @override
  State<DialogPDF> createState() => _DialogPDFState();
}

class _DialogPDFState extends State<DialogPDF> {
  List<Productor> productores = [];
  List<Parametro> parametros = [];
  String tipoAnalisis = "MICROBIOLÓGICO";
  List<int> bytes = [];
  late Future<List<Personal>> getPersonsPersonal;
  late Future<List<Productor>> getProductor;
  late Future<List<Parametro>> getParametros;
  @override
  void initState() {
    getProductor = ProductoresHttp()
        .searchProductor(widget.solicitudAprobada.nombre_y_apellido);
    getPersonsPersonal = PersonalHttp().getPersonal();
    getParametros = ParametrosHttp().getAllParametros();
    super.initState();

    analistasResp = [];
    analistasColab = [];
    direccion = [];
    if (widget.solicitudAprobada.analisisSolicitados == "Microbiológico") {
      setState(() {
        typeAnalisis = "microbiologicos";
        detailMetodology =
            'Para el análisis de las muestras, se utilizaron placas Compact Dry estériles, con medios cromogénicos deshidratados, específicas'
            'para cada microorganismo en estudio. Elaborador: NISSUI Pharmaceutical Co. Ltd. Tokyo, Japón '
            'Las placas Compact Dry son útiles para realizar análisis microbiológicos tanto en línea de procesos como en producto final.'
            'Cada Lote de placas, se encuentra acompañado de un certificado de análisis de calidad que avala su aptitud, para el '
            'microorganismo buscado. '
            'Los métodos Compact Dry se encuentran validados por la AOAC a través de los certificados N110401, 092002, 081001, 010401.';
      });
    } else {
      if (widget.solicitudAprobada.analisisSolicitados == "Nutricionales") {
        setState(() {
          typeAnalisis = "nutricionales";
          tipoAnalisis = "NUTRICIONAL";
          detailMetodology =
              'Grasas: IUPAC Standard Method 1.122, Proteínas, humedad y fibra dietaria:(AOAC, 2005).';
        });
      } else {
        if (widget.solicitudAprobada.analisisSolicitados == "Azucares") {
          setState(() {
            tipoAnalisis = "AZÚCARES";
            typeAnalisis = "azúcares";
            detailMetodology =
                'Se realizó la determinación por cromatografía líquida de alta performance (HPLC). Para'
                'el análisis de HPLC se utilizó una columna de elución Rezex TM ROA-Organic Acid H+ (8'
                '%) 300 x 7,8 mm con agua acidificada con ácido sulfúrico al 0,005 N como fase móvil.';
          });
        } else {
          setState(() {
            tipoAnalisis = "FISICOQUÍMICO";
            typeAnalisis = "fisicoquímicos";
            detailMetodology =
                'Se tomaron como referencia las normas internacionales, ASBC (American Society of Brewing Chemists), '
                'EBC (European Brewery Convention) y MEBAK (Mitteleuropäische Brautechnische Analysenkommission) '
                'de acuerdo con la técnica empleada';
          });
        }
      }
    }

    print('asdq' + widget.solicitudAprobada.analisisSolicitados.toString());
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
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(0, 700, page.getClientSize().width, 100),
    );
  }

  String quitarAcentos(String texto) {
    Map<String, String> acentos = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ñ': 'n',
      'Á': 'A',
      'É': 'E',
      'Í': 'I',
      'Ó': 'O',
      'Ú': 'U',
      'Ñ': 'N'
    };

    String textoSinAcentos = texto.replaceAllMapped(
      RegExp('[áéíóúñÁÉÍÓÚÑ]'),
      (match) => acentos[match.group(0)]!,
    );

    return textoSinAcentos;
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

    final data =
        await rootBundle.load('assets/images/logo3_redimensionado.png');
    Uint8List img =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    final logoUTN =
        await rootBundle.load('assets/images/logo_facultad_redimensionado.png');

    Uint8List imgutn = logoUTN.buffer
        .asUint8List(logoUTN.offsetInBytes, logoUTN.lengthInBytes);

    graphics.drawImage(PdfBitmap(img), const Rect.fromLTWH(0, 0, 0, 0));
    graphics.drawImage(PdfBitmap(imgutn), const Rect.fromLTWH(380, 0, 0, 0));

    final dataFirma = await rootBundle.load('assets/images/firma.png');
    Uint8List imgFirma = dataFirma.buffer
        .asUint8List(dataFirma.offsetInBytes, dataFirma.lengthInBytes);

    if (widget.solicitudAprobada.analisisSolicitados == "Fisicoquímico" ||
        widget.solicitudAprobada.analisisSolicitados == "Azucares") {
      graphics.drawImage(
          PdfBitmap(imgFirma), const Rect.fromLTWH(350, 625, 0, 0));
    } else {
      if (widget.solicitudAprobada.analisisSolicitados == "Microbiológico") {
        graphics.drawImage(
            PdfBitmap(imgFirma), const Rect.fromLTWH(30, 685, 0, 0));
        graphics.drawString("Analista: Mg. Ing. Lataza Rovaletti Ma. Mercedes",
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.right,
            ),
            bounds: Rect.fromLTWH(500, 740, 0, 0));
      }
      // graphics.drawImage(
      //  PdfBitmap(imgFirma), const Rect.fromLTWH(350, 625, 0, 0));
    }

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
    String subtitle = "";
    switch (widget.solicitudAprobada.analisisSolicitados) {
      case "Fisicoquímico":
        subtitle =
            "Análisis de parámetros ${typeAnalisis} en la bebida alcohólica ${widget.solicitudAprobada.nombreMuestra}";
        break;
      case "Nutricionales":
        subtitle =
            "Análisis de parámetros ${typeAnalisis} en ${widget.solicitudAprobada.nombreMuestra}";
        break;
      case "Azucares":
        subtitle =
            "Análisis de azúcares en ${widget.solicitudAprobada.nombreMuestra}";
        break;
      case "Microbiológico":
        subtitle =
            "Análisis de parámetros microbiológicos en ${widget.solicitudAprobada.nombreMuestra}";
    }

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
        bounds: Rect.fromLTWH(0, 50, page.getClientSize().width, 100));

    PdfFontStyle style = PdfFontStyle.bold;

    graphics.drawString(
        title, PdfStandardFont(PdfFontFamily.helvetica, 12, style: style),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitles,
        bounds: Rect.fromLTWH(0, 85, page.getClientSize().width, 100));

    graphics.drawString(
        subtitle, PdfStandardFont(PdfFontFamily.helvetica, 12, style: style),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitles,
        bounds: Rect.fromLTWH(0, 110, page.getClientSize().width, 100));

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

    if (widget.solicitudAprobada.tipoSolicitante == "Particular") {
      switch (widget.solicitudAprobada.analisisSolicitados) {
        case "Azucares":
          paragraphText =
              'El Sr. ${widget.solicitudAprobada.nombre_y_apellido} solicitó al grupo UTN QuiTEx el análisis de '
              'un (1) lote de ${widget.solicitudAprobada.producto} para '
              'cuantificar glucosa,fructosa,sacarosa y azucares totales';
      }
      graphics.drawString(
          paragraphText, PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          format: format,
          bounds: Rect.fromLTWH(0, 145, page.getClientSize().width, 100));
    } else {
      if (widget.solicitudAprobada.tipoSolicitante == "Corporativo") {
        graphics.drawString(
            "Solicitante: " +
                widget.solicitudAprobada.nombre_y_apellido +
                "\n" +
                "Empresa: " +
                widget.solicitudAprobada.nombreEmpresa +
                "\n" +
                "CUIT: " +
                widget.solicitudAprobada.cuitEmpresa +
                "\n" +
                "Direccion: " +
                widget.solicitudAprobada.direccionEmpresa +
                "\n" +
                "Marca comercial: " +
                widget.solicitudAprobada.nombreMuestra,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
            ),
            bounds: Rect.fromLTWH(0, 130, page.getClientSize().width, 100));
      }
    }

    // Agregar un espacio adicional para separar el párrafo de la tabla
    double spaceAfterParagraph = 10;

    // Add a table to the PDF.
    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 4);
    grid.headers.add(1);

    //Add rows to grid
    PdfGridRow header = grid.headers[0];
    if (widget.solicitudAprobada.analisisSolicitados == "Fisicoquímico") {
      header.cells[0].value = "Fecha de elaboracion";
      header.cells[1].value = "Estilo";
      header.cells[2].value = "Direccion de elaboracion";
      header.cells[3].value = "Lote";
    } else {
      if (widget.solicitudAprobada.analisisSolicitados == "Microbiológico") {
        header.cells[0].value = "Denominacion del producto";
        header.cells[1].value = "Presentacion";
        header.cells[2].value = "Fecha de elaboracion";
        header.cells[3].value = "Fecha de vencimiento";
      }
    }

    //Add header style
    header.style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );

    PdfGridRow row = grid.rows.add();
    if (widget.solicitudAprobada.analisisSolicitados == "Fisicoquímico") {
      row.cells[0].value = widget.solicitudAprobada.fechaElaboracion;
      row.cells[1].value = widget.solicitudAprobada.estilo;
      row.cells[2].value = prod[0].direccionElaboracion;
      row.cells[3].value = widget.solicitudAprobada.lote;
    } else {
      if (widget.solicitudAprobada.analisisSolicitados == "Microbiológico") {
        row.cells[0].value = widget.solicitudAprobada.producto;
        row.cells[1].value = widget.solicitudAprobada.presentacion;
        row.cells[2].value = widget.solicitudAprobada.fechaElaboracion;
        row.cells[3].value = widget.solicitudAprobada.fechaVencimiento;
      }
    }

    //Add rows style
    if (widget.solicitudAprobada.analisisSolicitados == "Fisicoquímico") {
      grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 10, right: 3, top: 4, bottom: 5),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
            style: PdfFontStyle.regular),
      );

      // Draw the table on the same page below the paragraph
      grid.draw(
          page: page,
          bounds: Rect.fromLTWH(0, 200, page.getClientSize().width, 0));
    } else {
      if (widget.solicitudAprobada.analisisSolicitados == "Microbiológico") {
        grid.style = PdfGridStyle(
          cellPadding: PdfPaddings(left: 10, right: 3, top: 4, bottom: 5),
          backgroundBrush: PdfBrushes.white,
          textBrush: PdfBrushes.black,
          font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
              style: PdfFontStyle.regular),
        );

        // Draw the table on the same page below the paragraph
        grid.draw(
            page: page,
            bounds: Rect.fromLTWH(0, 210, page.getClientSize().width, 0));
      }
    }

    String titleSinAcento = quitarAcentos(tipoAnalisis);

    String titleResults = "RESULTADOS DEL ANÁLISIS ${titleSinAcento}";

    graphics.drawString(titleResults,
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: style),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitleResult,
        bounds: Rect.fromLTWH(0, 200, page.getClientSize().width, 100));

    // Add a second table to the PDF.
    PdfGrid grid2 = PdfGrid();
    if (widget.solicitudAprobada.analisisSolicitados == "Microbiológico") {
      grid2.columns.add(count: 3);
    } else {
      grid2.columns.add(count: 2);
    }

    grid2.headers.add(1);

// Add header to the second table
    PdfGridRow header2 = grid2.headers[0];
    if (widget.solicitudAprobada.analisisSolicitados == "Microbiológico") {
      header2.cells[0].value = "Análisis";
      header2.cells[1].value = "Resultados obtenidos";
      header2.cells[2].value = "Lote Placa Compact Dry";
    } else {
      header2.cells[0].value = "Análisis";
      header2.cells[1].value = "Resultados obtenidos";
    }

// Add header style for the second table
    header2.style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
          style: PdfFontStyle.regular),
    );

    for (int i = 0; i <= parametrosElegidos.length - 1; i++) {
      PdfGridRow row21 = grid2.rows.add();
      row21.cells[0].value = parametrosElegidos[i].parametro;
      row21.cells[1].value = parametrosElegidos[i].valor;
      if (widget.solicitudAprobada.analisisSolicitados == "Microbiológico") {
        row21.cells[2].value = nLotes[i]!.text;
      }
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
      bounds: Rect.fromLTWH(0, 315, page.getClientSize().width, 0),
    );

    // Calculate the total height after adding the content
    double metodologyTitleY =
        490; // Adjust the value based on your desired space
    double detailMetodologyY =
        metodologyTitleY + 20; // Adjust the value based on your desired space
    double newPageHeight =
        detailMetodologyY + 100; // Adjust the value based on your desired space

    // Position metodologyTitle and detailMetodology according to the calculated heights
    String metodologyTitle = "METODOLOGIA EMPLEADA";

    graphics.drawString(
      metodologyTitle,
      PdfStandardFont(PdfFontFamily.helvetica, 12,
          multiStyle: [PdfFontStyle.bold, PdfFontStyle.underline]),
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

    if (widget.solicitudAprobada.analisisSolicitados == "Microbiológico" ||
        widget.solicitudAprobada.analisisSolicitados == "Nutricionales") {
      /*
      String observacionesTitle = "OBSERVACIONES";

      graphics.drawString(
        observacionesTitle,
        PdfStandardFont(PdfFontFamily.helvetica, 12,
            multiStyle: [PdfFontStyle.underline, PdfFontStyle.bold]),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitleMetodology,
        bounds: Rect.fromLTWH(0, 540, page.getClientSize().width, 100),
      );

      graphics.drawString(
        observaciones,
        PdfStandardFont(PdfFontFamily.helvetica, 10,
            style: PdfFontStyle.regular),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitleMetodology,
        bounds: Rect.fromLTWH(0, 555, page.getClientSize().width, 100),
      );*/
    }

    String titleTeam = "EQUIPO DE TRABAJO";
    if (widget.solicitudAprobada.analisisSolicitados == "Fisicoquímico") {
      graphics.drawString(
        titleTeam,
        PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitleMetodology,
        bounds: Rect.fromLTWH(0, 580, page.getClientSize().width, 100),
      );
    } else {
      if (widget.solicitudAprobada.analisisSolicitados == "Microbiológico" ||
          widget.solicitudAprobada.analisisSolicitados == "Azucares") {
        graphics.drawString(
          titleTeam,
          PdfStandardFont(PdfFontFamily.helvetica, 11,
              style: PdfFontStyle.bold),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          format: formatTitleMetodology,
          bounds: Rect.fromLTWH(0, 595, page.getClientSize().width, 100),
        );
      }
    }

    if (analistasResp.isNotEmpty) {
      String analistasRespExp = "";
      if (analistasResp.length >= 2) {
        analistasRespExp = analistasResp.join(',');
      } else {
        analistasRespExp = analistasResp.first;
      }

      graphics.drawString(
        "Analistas Responsables: " + analistasRespExp,
        PdfStandardFont(PdfFontFamily.helvetica, 9,
            style: PdfFontStyle.regular),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitleMetodology,
        bounds: Rect.fromLTWH(0, 610, page.getClientSize().width, 100),
      );
    }
    if (analistasColab.isNotEmpty) {
      String analistasColabExp = "";
      if (analistasColab.length >= 2) {
        analistasColabExp = analistasColab.join(',');
      } else {
        analistasColabExp = analistasColab.first;
      }
      // String analistasColabExp =
      //     analistasColab.toString().substring(1, analistasColab.length - 1);

      graphics.drawString(
        "Analistas colaboradores: " + analistasColabExp,
        PdfStandardFont(PdfFontFamily.helvetica, 9,
            style: PdfFontStyle.regular),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitleMetodology,
        bounds: Rect.fromLTWH(0, 630, page.getClientSize().width, 100),
      );
    }
    if (direccion.isNotEmpty) {
      String direccionExp = "";
      if (direccion.length >= 2) {
        direccionExp = direccion.join(',');
      } else {
        direccionExp = direccion.first;
      }
      // String direccionExp =
      //     direccion.toString().substring(1, direccion.length - 1);
      graphics.drawString(
        "Direccion: " + direccionExp,
        PdfStandardFont(PdfFontFamily.helvetica, 9,
            style: PdfFontStyle.regular),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: formatTitleMetodology,
        bounds: Rect.fromLTWH(0, 650, page.getClientSize().width, 100),
      );
    }

    if (widget.solicitudAprobada.analisisSolicitados == "Fisicoquímico") {
      String footerText =
          'ACLARACIÓN: Los Resultados obtenidos corresponden exclusivamente a la muestra recibida y analizada. '
          ' La Institución no se responsabiliza por el uso incorrecto que se hiciera de los mismos.';

      addFooterToPdf(page, footerText);
    } else {
      if (widget.solicitudAprobada.analisisSolicitados == "Nutricionales") {
        addFooterToPdf(page, observaciones);
      }
    }

    // Save the document.
    bytes = await document.save();
    int randomNumber = Random().nextInt(100);
    // Download document

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
    }

    /*

    await InformesHttp().addInforme(
        widget.solicitudAprobada.lote,
        widget.solicitudAprobada.nombreMuestra,
        widget.solicitudAprobada.nombre_y_apellido,
        bytes,
        widget.solicitudAprobada.analisisSolicitados);*/

    // Dispose the document
    document.dispose();

    parametrosElegidos.clear();
  }

  int upperBound = 1;

  int activeStep = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Generacion de informe'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(children: [
            IconStepper(
              icons: const [
                Icon(Icons.numbers),
                Icon(Icons.supervisor_account),
              ],
              activeStep: activeStep,

              // This ensures step-tapping updates the activeStep.
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
            activeStep == 0
                ? Text('Carga de parametros químicos')
                : Text('Carga de equipo de trabajo'),
            Expanded(
                child: FittedBox(
              child: activeStep == 0
                  ? CargaParametros(
                      getProductor: getProductor,
                      widget: widget,
                      getParametros: getParametros,
                    )
                  : Expanded(
                      child: FittedBox(
                          child: FutureBuilder<List<Personal>>(
                              future: getPersonsPersonal,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (direction.isEmpty) {
                                    direction = List.generate(
                                        snapshot.data!.length,
                                        (index) => false);
                                    checkboxesResp = List.generate(
                                        snapshot.data!.length,
                                        (index) => false);
                                    checkboxesColab = List.generate(
                                        snapshot.data!.length,
                                        (index) => false);
                                  }

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: DataTable(
                                        horizontalMargin: 5,
                                        columnSpacing: Responsive()
                                            .calculateColumnSpacing(context, 4),
                                        columns: const [
                                          DataColumn(
                                              label: Text('Nombre y Apellido',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text(
                                                  'Analista Responsable',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text(
                                                  'Analista colaboradora',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Direccion',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                        rows: List<DataRow>.generate(
                                            snapshot.data!.length, (index) {
                                          return DataRow(cells: [
                                            DataCell(Text(snapshot.data![index]
                                                .nombre_y_apellido)),
                                            DataCell(Checkbox(
                                              value: checkboxesResp[index],
                                              onChanged: (val) {
                                                setState(() {
                                                  checkboxesResp[index] = val!;
                                                });
                                                if (val!) {
                                                  analistasResp.add(snapshot
                                                      .data![index]
                                                      .nombre_y_apellido);
                                                } else {
                                                  analistasResp.remove(snapshot
                                                      .data![index]
                                                      .nombre_y_apellido);
                                                }
                                                print(analistasResp.toString());
                                              },
                                            )),
                                            DataCell(Container(
                                              alignment: Alignment.center,
                                              child: Checkbox(
                                                value: checkboxesColab[index],
                                                onChanged: (val) {
                                                  setState(() {
                                                    checkboxesColab[index] =
                                                        val!;
                                                  });
                                                  if (val!) {
                                                    analistasColab.add(snapshot
                                                        .data![index]
                                                        .nombre_y_apellido);
                                                  } else {
                                                    analistasColab.remove(
                                                        snapshot.data![index]
                                                            .nombre_y_apellido);
                                                  }
                                                },
                                              ),
                                            )),
                                            DataCell(Checkbox(
                                              value: direction[index],
                                              onChanged: (val) {
                                                setState(() {
                                                  direction[index] = val!;
                                                });
                                                if (val!) {
                                                  direccion.add(snapshot
                                                      .data![index]
                                                      .nombre_y_apellido);
                                                } else {
                                                  direccion.remove(snapshot
                                                      .data![index]
                                                      .nombre_y_apellido);
                                                }
                                              },
                                            )),
                                          ]);
                                        }),
                                      ),
                                    ),
                                  );
                                }
                                return FittedBox(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                  ),
                                );
                              })),
                    ),
            ))
          ]),
        ),
        actions: [
          activeStep == 1
              ? ElevatedButton(
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
                  child: const Text('Generar Informe'))
              : Text(''),
        ]);
  }
}

class CargaParametros extends StatefulWidget {
  const CargaParametros({
    Key? key,
    required this.getProductor,
    required this.getParametros,
    required this.widget,
  }) : super(key: key);

  final Future<List<Productor>> getProductor;
  final DialogPDF widget;
  final Future<List<Parametro>> getParametros;

  @override
  State<CargaParametros> createState() => _CargaParametrosState();
}

class _CargaParametrosState extends State<CargaParametros>
    with AutomaticKeepAliveClientMixin<CargaParametros> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<List<Productor>>(
      future: widget.getProductor,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Parámetros de Carga',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Datos de Elaboración',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                widget.widget.solicitudAprobada.analisisSolicitados ==
                        "Microbiológico"
                    ? DataTable(
                        columnSpacing:
                            Responsive().calculateColumnSpacing(context, 4),
                        horizontalMargin: 5,
                        border: TableBorder.all(color: Colors.black),
                        columns: const [
                            DataColumn(
                                label: Text('Denominación del producto',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Presentación',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Fecha de elaboración',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Fecha de vencimiento',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                          ],
                        rows: [
                            DataRow(cells: [
                              DataCell(Text(
                                  widget.widget.solicitudAprobada.producto)),
                              DataCell(Text(widget
                                  .widget.solicitudAprobada.presentacion)),
                              DataCell(Text(widget
                                  .widget.solicitudAprobada.fechaElaboracion)),
                              DataCell(Text(widget
                                  .widget.solicitudAprobada.fechaVencimiento)),
                            ])
                          ])
                    : DataTable(
                        columnSpacing:
                            Responsive().calculateColumnSpacing(context, 4),
                        horizontalMargin: 5,
                        border: TableBorder.all(color: Colors.black),
                        columns: const [
                            DataColumn(
                                label: Text('Fecha elaboracion',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Estilo',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Direccion elaboracion',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Lote',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                          ],
                        rows: [
                            DataRow(cells: [
                              DataCell(Text(widget
                                  .widget.solicitudAprobada.fechaElaboracion)),
                              DataCell(
                                  Text(widget.widget.solicitudAprobada.estilo)),
                              DataCell(
                                  Text(snapshot.data![0].direccionElaboracion)),
                              DataCell(
                                  Text(widget.widget.solicitudAprobada.lote)),
                            ])
                          ]),
                SizedBox(height: 20.0),
                Text(
                  'Parámetros Adicionales',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                FutureBuilderParametros(
                  tipoAnalisis:
                      widget.widget.solicitudAprobada.analisisSolicitados,
                  parametro: widget.getParametros,
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class FutureBuilderParametros extends StatefulWidget {
  String tipoAnalisis;
  Future<List<Parametro>> parametro;
  FutureBuilderParametros(
      {required this.tipoAnalisis, required this.parametro});

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
    print('param12' + widget.tipoAnalisis.toString());
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
      future: widget.parametro,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          for (int i = 0; i <= snapshot.data!.length - 1; i++) {
            print('spam1' +
                snapshot.data![i].parametro +
                " " +
                snapshot.data![i].analisis);
            if (widget.tipoAnalisis == snapshot.data![i].analisis) {
              nombresParametros.add(snapshot.data![i].parametro);
              print('nombreparametro:' + nombresParametros.toString());
            }
          }
          List<Parametro> selectedParametros = snapshot.data!
              .where((element) => element.analisis == widget.tipoAnalisis)
              .toList();

          // Verificar si las listas están vacías antes de inicializarlas
          if (checkboxesGen.isEmpty) {
            checkboxesGen =
                List.generate(selectedParametros.length, (index) => false);
          }
          if (textfieldValues.isEmpty) {
            textfieldValues = List.generate(
              selectedParametros.length,
              (index) => TextEditingController(
                text: '', // Establecer el valor inicial como cadena vacía
              ),
            );
          }
          if (nLotes.isEmpty) {
            nLotes = List.generate(
              selectedParametros.length,
              (index) => TextEditingController(
                text: '', // Establecer el valor inicial como cadena vacía
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: widget.tipoAnalisis == "Microbiológico"
                ? DataTable(
                    horizontalMargin: 5,
                    columnSpacing:
                        Responsive().calculateColumnSpacing(context, 3),
                    columns: const [
                      DataColumn(
                          label: Text('Parametro',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('¿Se midio?',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Valor',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Placa Compact Dry',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: List<DataRow>.generate(
                      selectedParametros.length,
                      (index) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(selectedParametros[index].parametro)),
                          DataCell(
                            checkbox(
                              index,
                              selectedParametros[index].parametro,
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
                                            selection:
                                                TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: newValue.length),
                                            ),
                                          );
                                });
                              },
                              key: ValueKey(textfieldValues[index]),
                            ),
                          ),
                          DataCell(
                            TextFormField(
                              controller: nLotes[index],
                              enabled: checkboxesGen[
                                  index], // Habilitar o deshabilitar el campo de texto según el valor del checkbox
                              onChanged: (newValue) {
                                setState(() {
                                  nLotes[index]!.text = newValue;
                                  // Obtener la posición actual del cursor
                                  final currentCursorPos =
                                      nLotes[index]!.selection;
                                  // Actualizar el texto del controlador
                                  nLotes[index]!.value = nLotes[index]!
                                      .value
                                      .copyWith(
                                        text: newValue,
                                        // Restaurar la posición del cursor al final del texto
                                        selection: TextSelection.fromPosition(
                                          TextPosition(offset: newValue.length),
                                        ),
                                      );
                                });
                              },
                              key: ValueKey(nLotes[index]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : DataTable(
                    horizontalMargin: 5,
                    columnSpacing:
                        Responsive().calculateColumnSpacing(context, 3),
                    columns: const [
                      DataColumn(
                          label: Text('Parametro',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('¿Se midio?',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Valor',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: List<DataRow>.generate(
                      selectedParametros.length,
                      (index) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(selectedParametros[index].parametro)),
                          DataCell(
                            checkbox(
                              index,
                              selectedParametros[index].parametro,
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
                                            selection:
                                                TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: newValue.length),
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
