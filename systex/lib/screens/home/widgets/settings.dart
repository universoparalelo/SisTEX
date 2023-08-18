import 'package:flutter/material.dart';
import 'package:systex/models/tipos_muestras.dart';
import 'package:systex/screens/home/home.dart';
import 'package:systex/services/api/http/tipomuestrasHttp.dart';

class Settings extends StatefulWidget {
  List<TipoMuestras> tiposanalisis;
  Settings({required this.tiposanalisis});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController nombre = TextEditingController();
  TextEditingController precio = TextEditingController();
  List<TipoMuestras> muestrasResto = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= widget.tiposanalisis.length - 1; i++) {
      print('ank' + widget.tiposanalisis[i].analisis);
    }
    muestrasResto = widget.tiposanalisis
        .where((element) =>
            element.analisis == "Azúcares" ||
            element.analisis == "Nutricionales" ||
            element.analisis == "Fisicoquimico")
        .toList();
  }

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
                    Microbiologicos(
                        tiposanalisis: widget.tiposanalisis,
                        nombre: nombre,
                        precio: precio),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: muestrasResto.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(muestrasResto[index].analisis),
                            subtitle: Text('\$' + muestrasResto[index].precio),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.delete)),
                            ]),
                          );
                        },
                      ),
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

class Microbiologicos extends StatefulWidget {
  List<TipoMuestras> tiposanalisis;
  TextEditingController nombre;
  TextEditingController precio;
  Microbiologicos(
      {required this.tiposanalisis,
      required this.nombre,
      required this.precio});

  @override
  State<Microbiologicos> createState() => _MicrobiologicosState();
}

class _MicrobiologicosState extends State<Microbiologicos> {
  List<TipoMuestras> muestrasRest = [];
  @override
  void initState() {
    super.initState();
    for (TipoMuestras analisis in widget.tiposanalisis) {
      if (analisis.tipoMuestra != "Completo") {
        muestrasRest.add(analisis);
      }
    }
    widget.tiposanalisis = muestrasRest;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text('Microbiologico'),
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
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Actualizacion'),
                                  content: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: TextField(
                                            controller: widget.nombre,
                                            decoration: InputDecoration(
                                                hintText: widget
                                                    .tiposanalisis[index]
                                                    .tipoMuestra),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: TextField(
                                            controller: widget.precio,
                                            decoration: InputDecoration(
                                              hintText: widget
                                                  .tiposanalisis[index].precio,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (widget.nombre.text.isEmpty) {
                                            widget.nombre.text = widget
                                                .tiposanalisis[index]
                                                .tipoMuestra;
                                          }
                                          if (widget.precio.text.isEmpty) {
                                            widget.precio.text = widget
                                                .tiposanalisis[index].precio;
                                          }

                                          TipoMuestras tipomuestras =
                                              TipoMuestras(
                                            idTipoMuestra: widget
                                                .tiposanalisis[index]
                                                .idTipoMuestra,
                                            tipoMuestra: widget.nombre.text,
                                            precio: widget.precio.text,
                                            analisis: widget
                                                .tiposanalisis[index].analisis,
                                          );
                                          Navigator.pop(context);

                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Tarea en progreso...'),
                                                  content: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      child: FutureBuilder<
                                                              String>(
                                                          future: TipoMuestrasHttp()
                                                              .updateAnalisis(
                                                                  tipomuestras),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .done) {
                                                              Future<List<TipoMuestras>>
                                                                  tiposmuestras =
                                                                  TipoMuestrasHttp()
                                                                      .getAllTiposAnalisis();
                                                              tiposmuestras.then(
                                                                  (resultado) {
                                                                setState(() {
                                                                  tiposMuestras =
                                                                      resultado;
                                                                  selectedOption =
                                                                      "Opción 4";
                                                                });
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Home()));
                                                              });
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      'Actualizacion terminada'),
                                                                ],
                                                              );
                                                            }
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CircularProgressIndicator(),
                                                                Text(
                                                                    'Actualizando...'),
                                                              ],
                                                            );
                                                          })),
                                                );
                                              });
                                        },
                                        child: const Text('Actualizar')),
                                  ],
                                );
                              });
                        },
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
                subtitle: Text('\$' + widget.tiposanalisis[index].precio),
                onTap: () {
                  print('Seleccionaste "${widget.tiposanalisis[index]}"');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class MiWidget extends StatefulWidget {
  TipoMuestras tiposMuestra;
  MiWidget({required this.tiposMuestra});
  @override
  _MiWidgetState createState() => _MiWidgetState();
}

class _MiWidgetState extends State<MiWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Tarea en progreso...'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.3,
                child: FutureBuilder<String>(
                  future:
                      TipoMuestrasHttp().updateAnalisis(widget.tiposMuestra),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Actualización terminada'),
                        ],
                      );
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text('Actualizando...'),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ).then((_) {
          // Aquí el Future ha terminado y se muestra el AlertDialog.
          // Luego, una vez que el AlertDialog se cierra, se dispara el then.
          // Ahora puedes invocar otro Future para obtener los datos actualizados.
          Future<List<TipoMuestras>> tiposmuestrasFuture =
              TipoMuestrasHttp().getAllTiposAnalisis();
          tiposmuestrasFuture.then((resultado) {
            // Aquí se completó el Future y se obtuvieron los resultados.
            setState(() {
              tiposMuestras = resultado;
            });
          });
        });
      },
      child: Text('Mostrar AlertDialog'),
    );
  }
}
