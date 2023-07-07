import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController textEditingController;

  const SearchBar({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
      color: Colors.grey[100],
      child: TextField(
        controller: textEditingController,
        decoration: const InputDecoration(
          hintText: 'Buscar productor',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
