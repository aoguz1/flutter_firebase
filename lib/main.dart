import 'package:firebase_flutter/view/authantice/giris.dart';
import 'package:firebase_flutter/view/rooter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        body: RooterView(),
      ),
    );
  }
}
