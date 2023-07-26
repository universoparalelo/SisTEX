// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:systex/screens/home/home.dart';
import 'package:systex/screens/login/widgets/email_field.dart';
import 'package:systex/screens/login/widgets/password_field.dart';
import 'package:systex/services/api/http/userHttp.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: LoginBody()),
    );
  }
}

class LoginBody extends StatefulWidget {
  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        color: Colors.black.withOpacity(0.15),
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.35,
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/logo.png')),
              const SizedBox(height: 20),
              EmailField(email: email),
              const SizedBox(height: 10),
              PasswordField(password: password),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  UserHttp userHttp = UserHttp();
                  Map<String, dynamic> resp =
                      await userHttp.authUser(email.text, password.text);
                  // Lógica para manejar el inicio de sesión
                  if (resp.containsKey('token_session')) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  }
                },
                child: const Text("Iniciar Sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
