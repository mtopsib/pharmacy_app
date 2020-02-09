import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesWrap{
  static Future<List<String>> getPersonData() async {
    final prefs = await SharedPreferences.getInstance();
    final String surname = prefs.get("person.surname") ?? "";
    final String name = prefs.get("person.name") ?? "";
    final String patronymic = prefs.get('person.patronymic') ?? "";
    final String date = prefs.get('person.date') ?? "";
    final String town = prefs.get('person.town') ?? "";
    final String snils = prefs.get('person.snils') ?? "";
    final String number = prefs.get('person.number') ?? "";
    final String mail = prefs.get('person.mail') ?? "";
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
}