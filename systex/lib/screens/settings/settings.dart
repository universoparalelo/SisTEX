import 'package:flutter/material.dart';
import 'package:systex/models/tipos_analisis.dart';
import 'package:systex/services/services.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<TiposAnalisis> tiposanalisis = [];
  Future<void> init() async {
    tiposanalisis = await Services().getTiposAnalisis();
    tiposanalisis.removeWhere((element) => element.analisis.isEmpty);

    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.fromLTRB(25, 20, 25, 0),
      width: MediaQuery.of(context).size.width * 0.89,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ajustes',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500)),
          ExpansionTile(title: const Text('Precios'), children: [
            Container(
              alignment: Alignment.topLeft,
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.90,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tiposanalisis.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(tiposanalisis[index].analisis),
                      subtitle: Text('\$' + tiposanalisis[index].precio),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    );
                  }),
            ),
          ]),
          ListTile(
              title: Text('Agregar analisis'),
              trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios_outlined))),
        ],
      ),
    );
  }
}
