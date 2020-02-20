import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pharmacy_app/news_widget.dart';
import 'package:pharmacy_app/recipe_card_widget.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';
import 'news_card_widget.dart';

class ServerWrapper{

  static Future<List<Widget>> getNewsCard(String from, String page, String onlyNew, String count) async {
    await refreshAccessToken();
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
      print(response.body);
      List<dynamic> content = jsonDecode(response.body)['Records'];
      for (int i = 0; i < content.length; i++) {
        Map<String, dynamic> data = content[i]['Data'];
        if (content[i]["TypeData"] == "News"){
          contentWidgets.add(NewsCard(
            newsID: content[i]["ID"].toString(),
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

  //TODO: Протестировать когда сервер заработает
  static Future<Widget> getNewsBody(String newsID) async {
    await refreshAccessToken();
    var tokens = await SharedPreferencesWrap.getTokens();
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/News?NewsID=$newsID";
    Map<String, String> headers = {"AccessToken": tokens[1], "DeviceID": deviceInfo['deviceID'],
      "AppID": deviceInfo['appID'], "InstanceID": deviceInfo['instanceID']};

    Response response = await get(url, headers: headers);
    if (response.statusCode == 200){
      Map<String, String> content = jsonDecode(response.body);
      print(content['Header'] + "\n" + content['Body']);
      return null;
    } else {
      throw "Cant't get news info";
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

  static Future<void> readNews(String newsID) async{
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    var tokens = await SharedPreferencesWrap.getTokens();

    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/News?NewsID=$newsID";

    Map<String, String> headers = {"AccessToken": tokens[1], "DeviceID": deviceInfo['deviceID'],
      "AppID": deviceInfo['appID'], "InstanceID": deviceInfo['instanceID']};

    Response response = await patch(url, headers: headers);
    if (response.statusCode == 200){
      print("News $newsID was read");
    } else {
      throw "Error while patch read news";
    }
  }

  static Future<void> uploadSnils(String imagePath) async {
    if (imagePath == null) return;
    String base64Image = base64Encode(File(imagePath).readAsBytesSync());
    String userID = "";
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/SNILS?UserID=$userID";
    var tokens = await SharedPreferencesWrap.getTokens();
    var info = await SharedPreferencesWrap.getDeviceInfo();
    Map<String, String> headers = {"AccessToken": tokens[1], "DeviceID": info['deviceID'], "AppID": info["appID"], "InstanceID": info['instanceID']};

    Response response = await put(url, headers: headers, body: base64Image);
    if (response.statusCode == 200){
      //TODO: тут что-то делаем с профилем
    } else {
      throw "Ошибка при загрузке снилса";
    }
  }

  static Future<void> getProfileInfo([String userID]) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    var tokens = await SharedPreferencesWrap.getTokens();

    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/News";
    if (userID != null){
      url += "?UserID=$userID";
    }

    Map<String, String> headers = {"AccessToken": tokens[1], "DeviceID": deviceInfo['deviceID'],
      "AppID": deviceInfo['appID'], "InstanceID": deviceInfo['instanceID']};

    Response response = await patch(url, headers: headers);
    if (response.statusCode == 200){
      print(response.body);
    } else {
      throw "Error while get user profile";
    }
  }

  //TODO: Проверить работоспособность на досуге (еобязательная фича)
  /*static Future<Response> postPhoneLogin(String phoneNumber, ScaffoldState context) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    print(phoneNumber);
    String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Phone/Login?Phone=8-' + phoneNumber;
    String deviceID = deviceInfo['deviceID'];
    String appID = deviceInfo['appID'];
    String instanceID = deviceInfo['instanceID'];
    String basic = deviceInfo['basic'];
    Map<String, String> headers = {"DeviceID" : deviceID, 'AppID': appID,  'InstanceID': instanceID, 'Authorization': basic, 'accept': 'application/json'};
    Response response = await post(url, headers: headers);
    return response;
  }*/
}