import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<bool> getLogginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("logged") ?? false;
  }

  static Future<void> setLogginInfo(bool logginState) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('logged', logginState);
  }

  static Future<void> setConfirmationToken(String token) async{
    await SharedPreferences.getInstance()..setString('ConfirmationToken', token);
  }

  static Future<String> getConfirmationToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ConfirmationToken');
  }
}