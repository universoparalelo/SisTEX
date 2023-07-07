import 'package:flutter/material.dart';
import 'package:systex/utilities/text_editing_controllers.dart';

import '../../../utilities/variables_direction.dart';

class SelectorProvince extends StatefulWidget {
  @override
  State<SelectorProvince> createState() => _SelectorProvinceState();
}

class _SelectorProvinceState extends State<SelectorProvince> {
  var provincias = ["Chaco", "Corrientes", "Santa Fe"];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      value: provincia_productor,
      items: <String>["Chaco", "Corrientes", "Santa Fe"]
          .map<DropdownMenuItem<String>>((e) {
        return DropdownMenuItem(child: Text(e), value: e);
      }).toList(),
      onChanged: (val) {
        setState(() {
          provincia_productor = val!;
        });
      },
    );
  }
}
