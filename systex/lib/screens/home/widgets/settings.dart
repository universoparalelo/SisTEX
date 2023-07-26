import 'package:flutter/material.dart';
import 'package:systex/models/tipos_muestras.dart';

class Settings extends StatefulWidget {
  List<TipoMuestras> tiposanalisis;
  Settings({required this.tiposanalisis});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Settings')),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ExpansionTile(
                  title: const Text('Analisis que se realizan'),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.tiposanalisis.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {},
                                  // ignore: prefer_const_constructors
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                          title: Text(widget.tiposanalisis[index].tipoMuestra),
                          subtitle:
                              Text('\$' + widget.tiposanalisis[index].precio),
                          onTap: () {
                            print(
                                'Seleccionaste "${widget.tiposanalisis[index]}"');
                          },
                        );
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: const Text('Nuevo Analisis'),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
                )
              ],
            )),
      ),
    );
  }
}
