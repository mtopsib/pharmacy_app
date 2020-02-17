import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pharmacy_app/recipe_card_widget.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';

import 'news_card_widget.dart';

class InfoWrapper{

  static Future<List<Widget>> getNews(String from, String page, String onlyNew, String count) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    final tokens = await SharedPreferencesWrap.getTokens();

    List<Widget> contentWidgets = new List<Widget>();

    String accessToken = "";
    if (tokens[1] != null){
      accessToken = tokens[1];
    }
    String deviceID = deviceInfo['deviceID'];
    String appID = deviceInfo['appID'];
    String instanceID = deviceInfo['instanceID'];
    String basic = deviceInfo['basic'];

    final String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/MainPage?Page=$page';//?Count=$count&Page=$page&OnlyNew=$onlyNew';

    Map<String, String> headers = {"DeviceID" : deviceID, 'AppID': appID, 'InstanceID': instanceID, 'accept': 'application/json', 'AccessToken': accessToken, "Authorization": basic};
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200){
      List<dynamic> content = jsonDecode(response.body)['Records'];
      for (int i = 0; i < content.length; i++) {
        Map<String, dynamic> data = content[i]['Data'];
        if (content[i]["TypeData"] == "News"){
          contentWidgets.add(NewsCard(
            titleText: data['Header'].toString(),
            bodyText: data['Body'].toString(),
            botSource: data['Source'].toString(),
            date: data['Date'].toString().replaceAll("T", ' '),
            url: content[i]['ext_link'].toString(),
          )
          );
        }
        else if (content[i]["TypeData"] == "Recipe"){
          contentWidgets.add(RecipeCard(
            recipeName: data["Number"],
            tradeName: "Анальгин",
            mnn: "Метамизол натрия",
            dosage: "0.03",
            form: "тюб",
            standartCount: "1",
            duration: "20",
            tabletsPerDay: "2",
            source: "НГКМ №1",
            date: data['Date'],
            personName: data["Patient"],
          ));
        }

      }
      print(response.body);
      return contentWidgets;
    } else {
      return null;
    }
  }

  static Future<void> refreshAccessToken() async {
    final deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    final tokens = await SharedPreferencesWrap.getTokens();
    String deviceID = deviceInfo['deviceID'];
    String appID = deviceInfo['appID'];
    String instanceID = deviceInfo['instanceID'];
    String basic = deviceInfo['basic'];
    String refresh = tokens[0];

    Map<String, String> headers = {"DeviceID" : deviceID, 'AppID': appID, 'InstanceID': instanceID, 'accept': 'application/json', "Authorization": basic};
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Token?RefreshToken=$refresh";
    Response response = await get(url, headers: headers);

    if (response.statusCode == 200){
      await SharedPreferencesWrap.setAccessToken(jsonDecode(response.body).toString());
      //print(jsonDecode(response.body).toString());
    } else {
      throw "Неизвестный токен. Требуется регистрация пользователя.";
    }

  }
}