import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';

class InfoWrapper{
  static Future<List<dynamic>> _getNews(String from, String page, String onlyNew, String count) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    String accessToken;
    String deviceID = deviceInfo['deviceID'];
    String appID = deviceInfo['appID'];
    String instanceID = deviceInfo['instanceID'];
    String basic = deviceInfo['basic'];

    final String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/MainPage?Count=$count&Page=$page&OnlyNew=$onlyNew';

    Map<String, String> headers = {"DeviceID" : deviceID, 'AppID': appID,  'InstanceID': instanceID, 'Authorization': basic, 'accept': 'application/json'};
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200){
      List<dynamic> news = jsonDecode(response.body)['Records'];
      return news;
    } else {
      return null;
    }
  }
}