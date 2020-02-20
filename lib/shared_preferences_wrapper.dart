import 'package:flutter_udid/flutter_udid.dart';
import 'package:pharmacy_app/server_wrapper.dart';
import 'package:pharmacy_app/login_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SharedPreferencesWrap{
  static Future<List<String>> getPersonData() async {
    final prefs = await SharedPreferences.getInstance();
    final String surname = prefs.get("person.surname") ?? "Иванов";
    final String name = prefs.get("person.name") ?? "Иван";
    final String patronymic = prefs.get('person.patronymic') ?? "Иванович";
    final String date = prefs.get('person.date') ?? "01.01.2001";
    final String town = prefs.get('person.town') ?? "Москва";
    final String snils = prefs.get('person.snils') ?? "123-456-789-10";
    final String number = prefs.get('person.number') ?? "+7 (999)999-99-99";
    final String mail = prefs.get('person.mail') ?? "example@mail.com";
    return [surname, name, patronymic, date, town, snils, number, mail];
  }

  static Future<void> setPersonData(String surname, String name, String patronymic, String date, String town,
      String snils, String number, String mail) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("person.surname", surname);
    prefs.setString("person.name", name);
    prefs.setString('person.patronymic', patronymic);
    prefs.setString('person.date', date);
    prefs.setString('person.town', town);
    prefs.setString('person.snils', snils);
    prefs.setString('person.number', number);
    prefs.setString('person.mail', mail);
  }

  static Future<bool> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("logged") ?? false;
  }

  static Future<void> setLoginInfo(bool logginState) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('logged', logginState);
  }

  static Future<void> firstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    bool first = prefs.getBool("First") ?? true;
    if (first == true){
      _initDeviceInfo();
      prefs.setBool("First", false);
    }
  }

  static Future<void> setConfirmationToken(String token) async{
    await SharedPreferences.getInstance()..setString('ConfirmationToken', token);
  }

  static Future<String> getConfirmationToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ConfirmationToken');
  }

  static Future<void> setDeviceInfo(Map<String, String> info) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("DeviceID", info["deviceID"]);
    prefs.setString("InstanceID", info["instanceID"]);
  }

  static Future<Map<String, String>> getDeviceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    var deviceID = prefs.getString("DeviceID") ?? "";
    var instanceID = prefs.getString("InstanceID") ?? "";
    Map<String, String> info = {"deviceID": deviceID, "instanceID": instanceID, "basic": "Basic UmVjaXBlOip3c2VXU0U1NSo=", "appID": "ea1f1bc1-c552-4787-8d99-9cac5b5b377d"};
    return info;
  }

  //TODO: move to info_wrapper
  static void _initDeviceInfo() async {
    String uuid = Uuid().v1();
    String udid = await FlutterUdid.consistentUdid;
    Map<String, String> info = {"deviceID": udid, "instanceID": uuid};
    await SharedPreferencesWrap.setDeviceInfo(info);
  }

  static Future<void> setRefreshToken(String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("RefreshToken", refresh);
  }

  static Future<void> setAccessToken(String access) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("AccessToken", access);
  }

  static Future<List<String>> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString("RefreshToken") ?? "";
    final access = prefs.getString("AccessToken") ?? "";
    return [refresh, access];
  }
}