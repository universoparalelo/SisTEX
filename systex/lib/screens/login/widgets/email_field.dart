import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  TextEditingController email;
  EmailField({required this.email});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: widget.email,
        decoration: InputDecoration(
          hintText: "Email",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
