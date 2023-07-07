import 'package:flutter/material.dart';
import 'package:systex/utilities/text_editing_controllers.dart';

class TextFieldLocation extends StatelessWidget {
  const TextFieldLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: localidad,
      decoration: InputDecoration(labelText: 'Localidad'),
    );
  }
}
