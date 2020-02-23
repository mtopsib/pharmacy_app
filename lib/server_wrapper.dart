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

  static Future<void> uploadSnils(String imagePath) async {
    if (imagePath == null) return;
    String base64Image = base64Encode(File(imagePath).readAsBytesSync());
    String userID = "";
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/SNILS?UserID=$userID";
    var info = await SharedPreferencesWrap.getDeviceInfo();

    Response response = await put(url, headers: info, body: base64Image);
    if (response.statusCode == 200){
      print("Успешная загрузка снилса на сервер");
    } else {
      throw "Ошибка при загрузке снилса";
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

  static Future<void> getRecipeTowns(String newsID) async {
    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/Towns";

    Response response = await get(url);
    if (response.statusCode == 200){
      print(response.body);
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

  static Future<void> getRecipeBody(String recipeID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/Recipe?RecipeID=$recipeID";

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
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

  static Future<void> getGoodsList(String recipeID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/ChoiceGoods?RecipeID=$recipeID";

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
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

  static Future<void> getPharmacies(String recipeID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/WhereBuy?RecipeID=$recipeID";

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
    } else {
      print("Не могу молучить список аптек");
    }
  }

  static Future<void> handlePharmacies(String recipeID, String manufacturedID) async {
    var deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    var url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/WhereBuy?RecipeID=$recipeID";

    Response response = await put(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
    } else {
      print("Не могу молучить список товаров");
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
          )
          );
        }
        else if (content[i]["TypeData"] == "Recipe"){
          contentWidgets.add(RecipeCard(
            recipeName: data["Number"].toString(),
            tradeName: "Анальгин",
            mnn: "Метамизол натрия",
            dosage: "0.03",
            form: "тюб",
            standartCount: "1",
            duration: "20",
            tabletsPerDay: "2",
            source: "НГКМ №1",
            date: data['Date'].toString(),
            personName: data["Patient"].toString(),
            id: content[i]["ID"].toString(),
          ));
        }

      }
      return contentWidgets;
    } else {
      throw "Can't get news from server";
    }
  }

  static Future<void> getPages() async {
    final deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/MainPage?Page=Profile';

    Response response = await get(url, headers: deviceInfo);

    List<dynamic> pages = jsonDecode(response.body)["Pages"];

    if (response.statusCode == 200){
      print("Pages: " + pages.toString());
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
}

class ServerProfile{
  static Future<void> getUserProfile({String userID = ""}) async {
    final deviceInfo = await SharedPreferencesWrap.getDeviceInfo();

    String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Profile';
    if (userID != ""){
      url += "?UserID=$userID";
    }

    Response response = await get(url, headers: deviceInfo);
    if (response.statusCode == 200){
      print(response.body);
    } else {
      throw "Error while get user info";
    }
  }
}