import 'package:flutter/material.dart';
import 'package:pharmacy_app/home_widget.dart';
import 'package:pharmacy_app/login_widget.dart';
import 'package:pharmacy_app/profile.dart';
import 'package:pharmacy_app/main.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/MyProfile':
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(
                title: Text('Мой профиль'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Выйти'),
                    onPressed: () async {
                      SharedPreferencesWrap.setLogginInfo(false);
                    },
                  )
                ],
            ),
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
      case '/LoginCheckNumber':
        return MaterialPageRoute(builder: (_) => LoginCheckNumberWidget());
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