import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front/connexion_view.dart';
import 'package:universal_io/io.dart';
import 'boardview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home: const BoardView(),
      home: ConnexionView()
    );
  }
}