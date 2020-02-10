import 'package:flutter/material.dart';
import 'package:pharmacy_app/Home.dart';
import 'package:pharmacy_app/Profile.dart';
import 'package:pharmacy_app/main.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/MyProfile':
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(title: Text('Мой профиль')),
            body: MyProfile(),
          );
        });
      case '/EditProfile':
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(title: Text('Мой профиль')),
            body: ProfileEdit(),
          );
        });
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("ERROR"),
        ),
      );
    });
  }
}