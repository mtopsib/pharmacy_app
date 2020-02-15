import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';

import 'news_card_widget.dart';

class InfoWrapper{

  static Future<List<Widget>> getNews(String from, String page, String onlyNew, String count) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    List<Widget> newsWidgets = new List<Widget>();

    String accessToken = "";
    String deviceID = deviceInfo['deviceID'];
    String appID = deviceInfo['appID'];
    String instanceID = deviceInfo['instanceID'];
    String basic = deviceInfo['basic'];

    final String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/MainPage?Page=$page';//?Count=$count&Page=$page&OnlyNew=$onlyNew';

    Map<String, String> headers = {"DeviceID" : deviceID, 'AppID': appID, 'InstanceID': instanceID, 'accept': 'application/json', 'AccessToken': accessToken, "Authorization": basic};
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200){
      List<dynamic> news = jsonDecode(response.body)['Records'];
      for (int i = 0; i < news.length; i++) {
        Map<String, dynamic> data = news[i]['Data'];
        newsWidgets.add(NewsCard(
          titleText: data['Header'].toString(),
          bodyText: data['Body'].toString(),
          botSource: data['Source'].toString(),
          date: data['Date'].toString().replaceAll("T", ' '),
          url: news[i]['ext_link'].toString(),
          )
        );
      }
      return newsWidgets;
    } else {
      return null;
    }
  }

  static Future<String> getAccessToken() async {
    final deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    String deviceID = deviceInfo['deviceID'];
    String appID = deviceInfo['appID'];
    String instanceID = deviceInfo['instanceID'];
    String basic = deviceInfo['basic'];
    String refresh = "";

    Map<String, String> headers = {"DeviceID" : deviceID, 'AppID': appID, 'InstanceID': instanceID, 'accept': 'application/json', "Authorization": basic};
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Token?RefreshToken=$refresh";
    Response response = await get(url, headers: headers);

    if (response.statusCode == 200){
      SharedPreferencesWrap.setTokens("", jsonDecode(response.body)[0].toString());
    } else {
      throw "Неизвестный токен. Требуется регистрация пользователя.";
    }

  }
}