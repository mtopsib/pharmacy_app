import 'package:flutter/material.dart';
import 'package:pharmacy_app/home_widget.dart';
import 'package:pharmacy_app/route_generator.dart';

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
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        home: Home()
    );
  }
}



