import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WindowDeleteProducer extends StatefulWidget {
  const WindowDeleteProducer({super.key});

  @override
  State<WindowDeleteProducer> createState() => _WindowDeleteProducerState();
}

class _WindowDeleteProducerState extends State<WindowDeleteProducer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Center(child: Text('¿Esta seguro?')));
  }
}
