import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pharmacy_app/recipe_card_widget.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';
import 'news_card_widget.dart';

class ServerWrapper{

  static Future<void> refreshAccessToken() async {
    final deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    final tokens = await SharedPreferencesWrap.getTokens();
    String deviceID = deviceInfo['DeviceID'];
    String appID = deviceInfo['AppID'];
    String instanceID = deviceInfo['InstanceID'];
    String basic = deviceInfo['Authorization'];
    String refresh = tokens[0];

    Map<String, String> headers = {"DeviceID" : deviceID, 'AppID': appID, 'InstanceID': instanceID, "Authorization": basic};
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Token?RefreshToken=$refresh";
    Response response = await get(url, headers: headers);

    if (response.statusCode == 200){
      await SharedPreferencesWrap.setAccessToken(jsonDecode(response.body).toString());
      //print(jsonDecode(response.body).toString());
    } else {
      throw "Неизвестный токен. Требуется регистрация пользователя.";
    }

  }

  static Future<void> getProfileInfo([String userID]) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/News";
    if (userID != null){
      url += "?UserID=$userID";
    }

    Response response = await patch(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
    } else {
      throw "Error while get user profile";
    }
  }

  static Future<void> logout() async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Phone/Logout";

    Response response = await post(url, headers: deviceInfo);

    if (response.statusCode == 200){
      print(response.body);
    } else {
      throw "Error logout";
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

class ServerRecipe{
  static Future<void> getRecipes({String page = "", String count = "", String from = "", String onlyNew = ""}) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    if (deviceInfo["AccessToken"] == ""){
      deviceInfo.remove("AccessToken");
    }

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/RecipeList";

    bool haveOneQuery = false;
    if (page != ""){
      url += "?Page=$page";
      haveOneQuery = true;
    }
    if (count != ""){
      if (haveOneQuery){
        url += "&Count=";
      } else {
        url += "?Count=";
        haveOneQuery = true;
      }
      url += count;
    }
    if (from != ""){
      if (haveOneQuery){
        url += "&from=";
      } else {
        url += "?from=";
        haveOneQuery = true;
      }
      url += from;
    }
    if (onlyNew != ""){
      if (haveOneQuery){
        url += "&onlyNew=";
      } else {
        url += "?onlyNew=";
        haveOneQuery = true;
      }
      url += onlyNew;
    }

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
    } else {
      print("Не могу молучить рецепты");
    }
  }

  static Future<List<dynamic>> getRecipeTowns() async {
    var info = await SharedPreferencesWrap.getDeviceInfo();
    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/Towns";

    Response response = await get(url, headers: info);
    if (response.statusCode == 200){
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw "Can't get recipe towns";
    }
  }

  static Future<void> recipeShare(String phone, String recipeID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/RecipeShare?Phone=$phone&RecipeID=$recipeID";

    Response response = await put(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print("succesful sharing recipe");
    } else {
      throw "Cant't share recipe";
    }
  }

  static Future<void> deleteRecipeShare(String patientID, String recipeID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/RecipeShare?PatientID=$patientID&RecipeID=$recipeID";

    Response response = await delete(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print("succesful delete recipe share");
    } else {
      throw "Cant't delete recipe share";
    }
  }

  static Future<Map<String, dynamic>> getRecipeBody(String recipeID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/Recipe?RecipeID=$recipeID";

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      return jsonDecode(response.body);
    } else {
      throw "Cant't get recipe body";
    }
  }

  static Future<void> readRecipe(String recipeID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/Recipe?RecipeID=$recipeID";

    Response response = await patch(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print("succesful read recipe");
    } else {
      throw "Cant't read recipe";
    }
  }

  static Future<void> deleteRecipe(String recipeID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/Recipe?RecipeID=$recipeID";

    Response response = await delete(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print("succesful delete recipe");
    } else {
      throw "Cant't delete recipe";
    }
  }

  static Future<List<dynamic>> getGoodsList(String recipeID, {String town = ""}) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/ChoiceGoods?RecipeID=$recipeID";
    if (town != ""){
      url += "&Town=$town";
    }

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      return jsonDecode(response.body);
    } else {
      print("Не могу молучить список товаров");
    }
  }

  static Future<void> handleGoods(String recipeID, String goodsID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/ChoiceGoods?RecipeID=$recipeID&GoodsID=$goodsID";

    Response response = await put(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
    } else {
      print(response.body);
    }
  }

  static Future<void> deleteGoods(String recipeId, String goodsId, String aptekaId) async {
    var info = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/WhereBuy?RecipeID=$recipeId";
    if (goodsId != "") url += "&Goods009ID=$goodsId";
    if (aptekaId != "") url += "&AptekaID=$aptekaId";

    Response response = await delete(url, headers: info);
    print("delete answer ${response.body}");
  }

  static Future<void> getFactoryList(String recipeID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/ChoiceManufactured?RecipeID=$recipeID";

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
    } else {
      print("Не могу молучить список изготовителей");
    }
  }

  static Future<void> handleFactoryInRecipe(String recipeID, String manufacturedID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/ChoiceManufactured?RecipeID=$recipeID&ManufacturedID=$manufacturedID";

    Response response = await put(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
    } else {
      print("Не могу молучить список товаров");
    }
  }

  static Future<List<dynamic>> getPharmacies(String recipeID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/WhereBuy?RecipeID=$recipeID";

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      return jsonDecode(response.body);
    } else {
      print("Не могу молучить список аптек");
    }
  }

  static Future<void> handlePharmacies(String recipeID, String goodsID, double price, String aptekaID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/WhereBuy?RecipeID=$recipeID";
    var body = List<dynamic>();
    body.add({"Goods009ID": goodsID, "Price": price, "AptekaID": aptekaID});

    Response response = await put(url, headers: deviceInfo, body: jsonEncode(body));
    if (response.statusCode == 200){
      print("Товар успешно добавлен");
    } else {
      print("Не могу зафиксировать выбранную аптеку");
    }
  }
}

class ServerNews{
  static Future<List<Widget>> getNewsCard({String page = "", String from = "", String onlyNew = "", String count = ""}) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    List<Widget> contentWidgets = new List<Widget>();

    if (deviceInfo["AccessToken"] == ""){
      deviceInfo.remove("AccessToken");
    }
    var geoInfo = await SharedPreferencesWrap.getCurrentCity();
    deviceInfo["GEO_Width"] = geoInfo[1];
    deviceInfo["GEO_Long"] = geoInfo[2];
    //deviceInfo["Town"] = geoInfo[0].toString();

    String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/MainPage';

    bool haveOneQuery = false;
    if (page != ""){
      url += "?Page=$page";
      haveOneQuery = true;
    }
    if (count != ""){
      if (haveOneQuery){
        url += "&Count=";
      } else {
        url += "?Count=";
        haveOneQuery = true;
      }
      url += count;
    }
    if (from != ""){
      if (haveOneQuery){
        url += "&from=";
      } else {
        url += "?from=";
        haveOneQuery = true;
      }
      url += from;
    }
    if (onlyNew != ""){
      if (haveOneQuery){
        url += "&onlyNew=";
      } else {
        url += "?onlyNew=";
        haveOneQuery = true;
      }
      url += onlyNew;
    }

    Response response = await get(url, headers: deviceInfo);

    if (response.statusCode == 200){
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
            read: content[i]['NotRead'] as bool,
            )
          );
        }
        else if (content[i]["TypeData"] == "Recipe"){
          contentWidgets.add(RecipeCard(
            recipeName: data["Number"].toString(),
            goods: data["Goods"],
            hospital: data["Hospital"],
            date: data['Date'].toString(),
            personName: data["PatientFIO"].toString(),
            id: content[i]["ID"].toString(),
            notRead: content[i]["NotRead"] as bool,
          ));
        }

      }
      return contentWidgets;
    } else {
      throw "Can't get news from server";
    }
  }

  static Future<List<dynamic>> getPages() async {
    final deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/MainPage';

    Response response = await get(url, headers: deviceInfo);

    List<dynamic> pages = jsonDecode(response.body)["Pages"];

    if (response.statusCode == 200){
      return pages;
    } else {
      throw "Error while parsing pages";
    }
  }

  static Future<Map<String, String>> getNewsBody(String newsID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/News?NewsID=$newsID";

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      Map<String, dynamic> content = jsonDecode(response.body);
      Map<String, String> data = {"NotRead": content["NotRead"].toString(), "Header": content["Header"].toString(), "Body": content["Body"].toString(),
      "Source": content["Source"].toString(), "Date": content["Date"].toString(), "ext_link":content["ext_link"].toString()};
      return data;
    } else {
      throw "Cant't get news info";
    }
  }

  static Future<void> deleteNews(String newsID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/News?NewsID=$newsID";

    Response response = await delete(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print("succesful delete news");
    } else {
      throw "Cant't delete news";
    }
  }

  static Future<void> readNews(String newsID) async{
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/News?NewsID=$newsID";

    Response response = await patch(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print("News $newsID was read");
    } else {
      print(response.statusCode);
      throw "Error while patch read news";
    }
  }

}

class ServerLogin{
  static Future<Response> loginPhone(String phone) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    deviceInfo.remove("AccessToken");

    String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Phone/Login?Phone=8-$phone';

    Response response = await post(url, headers: deviceInfo);
    return response;
  }

  static Future<String> loginEsia() async {
    var info = await SharedPreferencesWrap.getDeviceInfo();
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/ESIA?url_to_redirect=https://xn--90arb8cyac.009.xn--p1ai/";

    Response response = await get(url, headers: info);
    if (response.statusCode == 200){
      return jsonDecode(response.body)['redirect_url'].toString();
    }
  }

  static Future<void> postDataFromEsia(String code, String state) async {
    var info = await SharedPreferencesWrap.getDeviceInfo();

    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/ESIA?code=$code&state=$state";

    Response response = await post(url, headers: info);
  }
}

class ServerProfile{
  static Future<Map<String, dynamic>> getUserProfile({String userID = ""}) async {
    final deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Profile';
    if (userID != ""){
      url += "?UserID=$userID";
    }

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      Map<String, dynamic> data = jsonDecode(response.body);
      await SharedPreferencesWrap.setUserID(data["UserID"].toString());
      return data;
    } else {
      throw "Error while get user info";
    }
  }

  static Future<void> changeUserData(Map<String, String> data) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();
    var userID = await SharedPreferencesWrap.getUserID();
    if (userID == null){
      return;
    }

    String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Profile';

    Response response = await patch(url, headers: deviceInfo, body: jsonEncode(data));
    print(jsonEncode(data));
    if (response.statusCode == 200){
      print("Data succesfuly changed");
    } else {
      print(response.body);
    }
  }

  static Future<void> addRelatives(String agree) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Profile';

    Response response = await put(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
    } else {
      throw "Error while change user data";
    }
  }

  static Future<void> uploadSnils(String imagePath) async {
    var userID = await SharedPreferencesWrap.getUserID();
    if (userID == null) return;
    if (imagePath == null) return;
    String base64Image = base64Encode(File(imagePath).readAsBytesSync());
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/SNILS?UserID=$userID";
    var info = await SharedPreferencesWrap.getDeviceInfo();

    Response response = await put(url, headers: info, body: base64Image);
    if (response.statusCode == 200){
      print("Успешная загрузка снилса на сервер");
    } else {
      print(response.body);
    }
  }

  static Future<void> logout() async {
    var info = await SharedPreferencesWrap.getDeviceInfo();
    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Phone/Logout";

    Response response = await post(url, headers: info);
    if (response.statusCode == 200){
      print("Successful logout");
    } else {
      print("Error while post logout");
    }
  }

}

class ServerMessages{
  static Future<String> getMessage(String messageID) async {
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/Message?MessageID=$messageID";

    Response response = await get(url);
    if (response.statusCode == 200){
      return (jsonDecode(response.body).toString());
      print(response.body);
    } else {
      throw "Error while getting message";
    }
  }

  static Future<void> readMessage(String messageID) async {
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/Message?MessageID=$messageID";

    Response response = await get(url);
    if (response.statusCode == 200){
      print("read message");
    } else {
      throw "Error while reading message";
    }
  }

  static Future<void> postMessage(Map<String, String> data) async {
    String userID = await SharedPreferencesWrap.getUserID();
    if (userID == null) return;
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/Message?UserID=$userID";

    Response response = await post(url, body: jsonEncode(data));
    if (response.statusCode == 200){
      print("ok");
    } else {
      throw "Error while posting message";
    }
  }

  static Future<void> deleteMessage(String messageID) async {
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/Message?MessageID=$messageID";

    Response response = await delete(url);
    if (response.statusCode == 200){
      print("delete message");
    } else {
      throw "Error while deleting message";
    }
  }


}