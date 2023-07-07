import 'package:flutter/material.dart';
import 'package:systex/utilities/text_editing_controllers.dart';

class TextFieldDirection extends StatelessWidget {
  const TextFieldDirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: direccion,
      decoration: InputDecoration(labelText: 'Direccion'),
    );
  }
}
