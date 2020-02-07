import 'package:flutter/material.dart';
import 'package:pharmacy_app/Home.dart';

void main() => runApp(MainPage());

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyMaterialApp();
  }
}

class MyMaterialApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "mainPage",
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}


