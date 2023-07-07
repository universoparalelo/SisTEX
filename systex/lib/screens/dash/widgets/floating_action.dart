import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:systex/models/producer.dart';
import 'package:systex/screens/dash/dash.dart';
import 'package:systex/screens/dash/widgets/selector_province.dart';
import 'package:systex/screens/dash/widgets/textfield_direction.dart';
import 'package:systex/screens/dash/widgets/textfield_location.dart';
import 'package:systex/screens/dash/widgets/textfield_name_producer.dart';
import 'package:systex/screens/dash/widgets/widget_analisis.dart';
import 'package:systex/services/services.dart';
import 'package:systex/utilities/text_editing_controllers.dart';
import 'package:systex/utilities/variables_direction.dart';

class FloatingAction extends StatefulWidget {
  int index;
  FloatingAction(this.index);

  @override
  State<FloatingAction> createState() => _FloatingActionState();
}

class _FloatingActionState extends State<FloatingAction> {
  //controllers para el form de informes
  TextEditingController suggestionSelected = TextEditingController();
  TextEditingController directionSelected = TextEditingController();
  bool showProgress = false;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () async {
          widget.index == 0
              ? showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text('Nuevo Productor'),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(
                                    width: 250.0,
                                    child: TextFieldNameProducer()),
                                SizedBox(width: 15.0),
                                SizedBox(
                                    width: 250.0, child: TextFieldDirection()),
                              ],
                            ),
                            const SizedBox(height: 25.0),
                            const Text('Provincia'),
                            SelectorProvince(),
                            const SizedBox(height: 25.0),
                            const TextFieldLocation(),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              Services serv = Services();
                              Producer producer = Producer(
                                  nameProducer: nombreProductor.text,
                                  direction: direccion.text,
                                  location: localidad.text,
                                  province: provincia_productor);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Adding Producer'),
                                    content: FutureBuilder<void>(
                                      future: serv.addProductor(producer),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<void> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Row(
                                            children: [
                                              Text('Agregando productor...'),
                                              SizedBox(
                                                  height: 40.0,
                                                  width: 40.0,
                                                  child:
                                                      CircularProgressIndicator()),
                                            ],
                                          ); // Muestra el mensaje de carga mientras el Future está en ejecución
                                        } else {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}'); // Muestra un mensaje de error si el Future produce una excepción
                                          } else {
                                            return Text(
                                                'Productor agregado exitosamente'); // Muestra el mensaje de finalización cuando el Future se completa
                                          }
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text('Agregar Productor')),
                      ],
                    );
                  })
              : widget.index == 1
                  ? showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text('Nueva Muestra'),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(
                                        width: 250.0,
                                        child: TextFieldNameProducer()),
                                    SizedBox(width: 15.0),
                                    SizedBox(
                                        width: 250.0,
                                        child: TextFieldDirection()),
                                  ],
                                ),
                                const SizedBox(height: 25.0),
                                const Text('Provincia'),
                                SelectorProvince(),
                                const SizedBox(height: 25.0),
                                const TextFieldLocation(),
                              ],
                            ),
                          ),
                        );
                      })
                  : showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text('Generar Informe'),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TypeAheadField<String>(
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                      trailing: suggestionSelected == suggestion
                                          ? SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: CircularProgressIndicator(
                                                color: Colors.blue,
                                              ),
                                            )
                                          : null,
                                    );
                                  },
                                  suggestionsBoxDecoration:
                                      SuggestionsBoxDecoration(
                                    constraints: BoxConstraints.tight(Size(
                                        MediaQuery.of(context).size.width *
                                            0.45,
                                        200)), // Personaliza el tamaño del menú
                                  ),
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    controller: suggestionSelected,
                                    decoration: InputDecoration(
                                      hintText: 'Nombre del productor',
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    List<String> suggestions = List.generate(
                                        producers.length,
                                        (index) =>
                                            producers[index].nameProducer);

                                    return suggestions
                                        .where((suggestion) =>
                                            suggestion.startsWith(pattern))
                                        .toList();
                                  },
                                  hideOnLoading: true,
                                  onSuggestionSelected: (suggestion) async {
                                    setState(() {
                                      showProgress = true;
                                    });
                                    // Aquí puedes manejar la selección de una sugerencia por parte del usuario
                                    print(
                                        'Sugerencia seleccionada: $suggestion');
                                    setState(() {
                                      suggestionSelected.text = suggestion;
                                    });
                                    directionSelected.text = await Services()
                                        .getDirection(suggestion);
                                    setState(() {
                                      showProgress = false;
                                    });
                                  },
                                ),
                                SizedBox(height: 15.0),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: TextField(
                                    controller: directionSelected,
                                    decoration: InputDecoration(
                                      labelText: 'Direccion',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                WidgetAnalisis(),
                              ],
                            ),
                          ),
                        );
                      });
        },
        backgroundColor: const Color(0xFF262626),
        child: widget.index == 0 || widget.index == 1
            ? Icon(
                Icons.add,
                color: Colors.white,
              )
            : FaIcon(FontAwesomeIcons.filePdf));
  }
}
