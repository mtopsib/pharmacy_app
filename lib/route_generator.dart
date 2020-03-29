import 'package:flutter/material.dart';
import 'package:pharmacy_app/news_widget.dart';
import 'package:pharmacy_app/profile_widget.dart';
import 'package:pharmacy_app/home_widget.dart';
import 'package:pharmacy_app/login_widget.dart';
import 'package:pharmacy_app/profile_widget.dart';
import 'package:pharmacy_app/main.dart';
import 'package:pharmacy_app/recipe_widget.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';
import 'package:pharmacy_app/messages_widget.dart';
import 'package:pharmacy_app/webview_widget.dart';

import 'buy_goods_widget.dart';
import 'choose_recipe_widget.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/News':
        if (args is String){
          return MaterialPageRoute(builder: (_) => NewsWidget(args));
        } else {
          return _errorRoute();
        }
        break;
      case '/Messages/Chat':
        return MaterialPageRoute(builder: (_) => MessagesWidget(messageId: args,));
      case '/RecipeWidget':
        return MaterialPageRoute(builder: (_) => RecipeWidget(recipeId: args,));
      case '/ChooseRecipe':
        return MaterialPageRoute(builder: (_) => ChooseRecipe(args));
      case '/BuyGoods':
        return MaterialPageRoute(builder: (_) => BuyGoods(args));
      case '/MyProfile':
        return MaterialPageRoute(builder: (_) => MyProfile(showSnilsAlert: args,));
      case '/Messages':
        return MaterialPageRoute(builder: (_) => MessagesListWidget());
      case '/Messages/New':
        return MaterialPageRoute(builder: (_) => NewMessage());
      case '/EditProfile':
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(title: Text('Мой профиль')),
            body: ProfileEdit(data: args),
          );
        });
      case '/LoginCheckNumber':
        return MaterialPageRoute(builder: (_) => LoginCheckNumberWidget());
      case '/Snils':
        return MaterialPageRoute(builder: (_) => SnilsCameraWidget());
      case "/Webview":
        return MaterialPageRoute(builder: (_) => WebViewWidget(url: args,));
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