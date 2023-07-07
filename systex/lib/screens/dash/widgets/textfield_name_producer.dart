import 'package:flutter/material.dart';
import 'package:systex/utilities/text_editing_controllers.dart';

class TextFieldNameProducer extends StatelessWidget {
  const TextFieldNameProducer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: nombreProductor,
      decoration: InputDecoration(labelText: 'Nombre y Apellido'),
    );
  }
}
