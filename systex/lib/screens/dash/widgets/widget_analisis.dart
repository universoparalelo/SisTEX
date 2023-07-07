import 'package:flutter/material.dart';
import 'package:systex/models/tipos_analisis.dart';
import 'package:systex/services/services.dart';

class WidgetAnalisis extends StatefulWidget {
  WidgetAnalisis({Key? key}) : super(key: key);

  @override
  State<WidgetAnalisis> createState() => _WidgetAnalisisState();
}

class _WidgetAnalisisState extends State<WidgetAnalisis> {
  List<TiposAnalisis> tipanalisis = [];
  List<bool> isSelected = [];
  List<DataRow> filasAnalisis = [];
  late DataTable tiposAnalisis;
  @override
  void initState() {
    super.initState();
    tiposAnalisis = DataTable(columns: [
      DataColumn(label: Text('Analisis')),
      DataColumn(label: Text('Valor')),
    ], rows: filasAnalisis);
    init();
  }

  void init() async {
    tipanalisis = await Services().getTiposAnalisis();
    isSelected = List.generate(tipanalisis.length, (index) => false);
    tipanalisis.removeWhere(
      (element) => element.analisis.isEmpty,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seleccione análisis',
            style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 5.0),
        FutureBuilder<void>(builder: ((context, snapshot) {
          if (tipanalisis.isEmpty) {
            return CircularProgressIndicator();
          }
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.6,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: tipanalisis.length,
                itemBuilder: ((context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChoiceChip(
                          avatar: isSelected[index] == false
                              ? null
                              : Icon(Icons.check,
                                  color: Colors.white, size: 12.0),
                          selectedColor: isSelected[index] == false
                              ? Colors.grey
                              : Colors.blue,
                          onSelected: (val) {
                            setState(() {
                              isSelected[index] = !isSelected[index];
                            });

                            if (isSelected[index]) {
                              setState(() {
                                final analysisName =
                                    tipanalisis[index].analisis;
                                final newRow = DataRow(cells: [
                                  DataCell(Text(analysisName)),
                                  DataCell(Text('0')),
                                ]);
                                filasAnalisis.add(newRow);
                              });
                            } else {
                              setState(() {
                                filasAnalisis.removeWhere((row) {
                                  final rowData = row.cells
                                      .map((cell) => (cell.child as Text).data)
                                      .toList();
                                  return rowData[0] ==
                                      tipanalisis[index].analisis;
                                });
                              });
                            }
                          },
                          label: Text(tipanalisis[index].analisis,
                              style: TextStyle(
                                  color: isSelected[index] == false
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w500)),
                          selected: isSelected[index]),
                      SizedBox(height: 5.0),
                    ],
                  );
                })),
          );
        })),
        filasAnalisis.isNotEmpty
            ? tiposAnalisis
            : Text('Sin analisis agregados'),
      ],
    );
  }
}
