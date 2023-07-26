import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PasswordField extends StatefulWidget {
  TextEditingController password;
  PasswordField({required this.password});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isHide = false;
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
        controller: widget.password,
        obscureText: isHide,
        decoration: InputDecoration(
            hintText: "Contraseña",
            border: InputBorder.none,
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isHide = !isHide;
                  });
                },
                icon: Icon(isHide ? Icons.lock : Icons.lock_open))),
      ),
    );
  }
}
