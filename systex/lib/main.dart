import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:systex/screens/home/home.dart';
import 'package:systex/screens/login/login.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App', debugShowCheckedModeBanner: false, home: Home());
  }
}
