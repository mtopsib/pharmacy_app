import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pharmacy_app/camera_widget.dart';
import 'package:pharmacy_app/server_wrapper.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';
import 'dart:async';

class MainProfile extends StatelessWidget{
  var textStyle = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              child: Text('Мой профиль', style: textStyle,),
              onPressed: () async {
                  Navigator.of(context).pushNamed('/MyProfile');
                },
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              child: Text('Мои близкие', style: textStyle,),
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              child: Text('Тех. поддержка', style: textStyle,),
              onPressed: () => Navigator.of(context).pushNamed('/TechSupport'),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          ProfileNewsWidget()
        ],
      ),
    );
  }
}

class ProfileNewsWidget extends StatefulWidget{
  _ProfileNewsWidgetState createState() => _ProfileNewsWidgetState();
}

class _ProfileNewsWidgetState extends State<ProfileNewsWidget>{
  List<Widget> news = List();

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    if (news.length > 0){
      return Expanded(
        child: ListView.builder(
          itemCount: news.length,
            itemBuilder: (context, index){
              return news[index];
            }
        ),
      );
    } else {
      return Container();
    }
  }

  void getNews() async {
    news = await ServerNews.getNewsCard(page: "Profile");
    print("Get news");
    setState(() {

    });
  }

}

class MyProfile extends StatefulWidget{
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile>{
  final upTextStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final botTextStyle = const TextStyle(fontSize: 14);
  final topTextPadding = const EdgeInsets.only(bottom: 8);

  String surname = "";
  String name = "";
  String patronymic = "";
  String date = "";
  String town = "";
  String snils = "";
  String number = "";
  String mail = "";
  String snilsConfirm = "";

  @override
  void initState() {
    super.initState();
    setDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мой профиль'),
        actions: <Widget>[
          FlatButton(
            child: Text('Выйти'),
            onPressed: () async {
              SharedPreferencesWrap.setLoginInfo(false);
              SharedPreferencesWrap.setConfirmationToken("");
              SharedPreferencesWrap.setAccessToken("");
              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: topTextPadding ,child: Text("Фамилия", style: upTextStyle)),
                      Text("$surname", style: botTextStyle,)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(child: Text("Имя", style: upTextStyle), padding: topTextPadding),
                      Text("$name" ,style: botTextStyle,)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(child: Text("Отчество", style: upTextStyle), padding: topTextPadding),
                      Text("$patronymic", style: botTextStyle,)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(child: Text("Дата рождения", style: upTextStyle), padding: topTextPadding),
                      Text("$date", style: botTextStyle,)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(child: Text("Мой город", style: upTextStyle), padding: topTextPadding),
                      Text("$town", style: botTextStyle,)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(child: Text("СНИЛС", style: upTextStyle,), padding: topTextPadding,),
                      Text("$snils", style: botTextStyle,)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(child: Text("Номер телефона", style: upTextStyle), padding: topTextPadding),
                      Text("$number", style: botTextStyle,)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(child: Text("Электронная почта", style: upTextStyle), padding: topTextPadding),
                      Text("$mail", style: botTextStyle,)
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FlatButton(
                      color: Colors.blueAccent,
                      child: Text("Заполнить профиль"),
                      onPressed: () => Navigator.of(context).pushNamed('/EditProfile', arguments: {
                        "surname": surname, "name": name, "patronymic": patronymic, "date": convertDate(date), "mail": mail})
                  ),
                  FlatButton(
                    child: Text("Отправить СНИЛС"),
                    onPressed: () => Navigator.of(context).pushNamed('/Snils'),
                    color: Colors.blueAccent,
                  ),
                  FlatButton(
                    child: Text("Авторизация через Госуслуги"),
                    onPressed: () async {
                      var url = await ServerLogin.loginEsia();
                      Navigator.of(context).pushNamed("/Webview", arguments: url);
                    },
                    color: Colors.blueAccent,
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  static String convertDate(String date){
    if (date.length < 10) return "";
    return date[8] + date[9] + "/" + date[5] + date[6] + "/" +  date[0] + date[1] + date[2] + date[3] ;
  }

  void setDataFromServer() async {
    final data = await ServerProfile.getUserProfile();
    name = data["Name"].toString() ?? "";
    surname = data["Surname"].toString() ?? "";
    patronymic = data["MiddleName"].toString() ?? "";
    date = data["Birthday"].toString().replaceAll("T", " ") ?? "";
    number = "8-" + data["Phone"].toString() ?? "";
    mail = data["eMail"].toString() ?? "";
    try{
      town = data["Towns"][0]["Town"].toString() ?? "";
    } catch (e){
      town = "";
    }
    switch (data["SNILSConfirm"].toString()){
      case "0":
        snils = "СНИЛС не вводился";
        break;
      case "1":
        snils = data["SNILS"].toString();
        break;
      case "2":
        snils = "СНИЛС не распознан";
        break;
      case "3":
        snils = "СНИЛС на распознавании";
        break;
    }
    setState(() {

    });
  }

}

class ProfileEdit extends StatefulWidget{
  final data;

  const ProfileEdit({Key key, this.data}) : super(key: key);

  ProfileEditState createState() => ProfileEditState();
}

class ProfileEditState extends State<ProfileEdit>{
  final topTextPadding = const EdgeInsets.only(bottom: 8);
  final upTextStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  final _key = GlobalKey<FormState>();

  //final phoneMask = MaskTextInputFormatter(mask: '###-###-##-##', filter: {'#': RegExp(r'[0-9]')});
  final dateMask = MaskTextInputFormatter(mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});

  String surname = "";
  String name = "";
  String patronymic = "";
  String date = "";
  //String town;
  //String snils;
  //String number;
  String mail = "";
  bool male = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14),
      child: ListView(
        children: [
          Form(
            key: _key,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: widget.data["surname"] ?? "",
                  validator: (value) {if (value.isEmpty){return 'Введите фамилию';} else {
                  return null;}
                  },

                  onSaved: (value) => surname = toUpFirstLetter(value),
                    decoration: InputDecoration(
                        hintText: "Ваша фамилия",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.person),
                        labelText: "Фамилия"
                    )
                ),
              ), //surname
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                    initialValue: widget.data["name"] ?? "",
                    validator: (value) {if (value.isEmpty){return 'Введите имя';} else {
                      return null;}
                    },
                    onSaved: (value) => name = toUpFirstLetter(value),
                    decoration: InputDecoration(
                        hintText: "Ваше имя",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.person),
                        labelText: "Имя"
                    )
                ),
              ), //name
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                    initialValue: widget.data["patronymic"] ?? "",
                    validator: (value) {if (value.isEmpty){return 'Введите отчество';} else {
                      return null;}
                    },
                    onSaved: (value) => patronymic = toUpFirstLetter(value),
                    decoration: InputDecoration(
                        hintText: "Ваше отчество",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.person),
                        labelText: "Отчество"
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: widget.data["date"] ?? "",
                    validator: (value) {if (value.isEmpty){return 'Введите дату рождения';} else if (value.length < 10){return null;} else {
                      return null;}
                    },
                  maxLength: 10,
                  onSaved: (value) => date = value,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [dateMask],
                    decoration: InputDecoration(
                        hintText: "дд/мм/гггг",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.date_range),
                        labelText: "Дата рождения"
                    )
                ),
              ),
              /*Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                    validator: (value) {if (value.isEmpty)
                    {return 'Введите город';}
                    else {
                      return null;}
                    },
                    onSaved: (value) => town = value,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.location_city),
                        labelText: "Город"
                    )
                ),
              ),*/
              /*Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                    validator: (value) {if (value.isEmpty){return 'Введите номер';}
                    else if (value.length < 13){
                      return null;
                    }
                    else {
                      return null;}
                    },
                  onSaved: (value) => number = value,
                  inputFormatters: [phoneMask],
                  maxLength: 13,
                  keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      hintText: "999-999-99-99",
                      prefixText: "8-",
                      prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.phone_android),
                      labelText: "Номер телефона"
                    )
                ),
              ),*/
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: widget.data["mail"] ?? "",
                  onSaved: (value) => mail = value,
                  decoration: InputDecoration(
                      hintText: "example@mail.ru",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.mail),
                      labelText: "Электронная почта"
                  )
                ),
              ),
              Text("Пол", style: TextStyle(fontSize: 20),),
              Container(
                child: Row(
                  children: <Widget>[
                    ChoiceChip(
                      onSelected: (_) {setState(() {male = true;});},
                      label: Text("Мужской"),
                      selected: male == true,
                    ),
                    Container(
                      width: 10,
                    ),
                    ChoiceChip(
                      onSelected: (_) {setState(() {male = false;});},
                      label: Text("Женский"),
                      selected: male == false,
                    ),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 40,
                child: FlatButton(
                  color: Color.fromARGB(255, 68, 156, 202),
                  child: Text("Сохранить", style: TextStyle(fontSize: 18, color: Colors.grey[900]), textAlign: TextAlign.center),
                  onPressed: () async {
                    if (_key.currentState.validate()){
                      _key.currentState.save();

                      Map<String, String> data = {"Surname": surname, "Name": name, "MiddleName": patronymic,
                      "Gender": male == true ? "М" : "Ж", "Birthday": convertDate(date), "eMail": mail};
                      await ServerProfile.changeUserData(data);

                      Navigator.of(context).pushNamedAndRemoveUntil('/MyProfile', ModalRoute.withName('/'));
                    }
                  },
                ),
              ),
              ],
            ),
          ),
        ]
      ),
    );
  }

  static String toUpFirstLetter(String input) {
    if (input == null) {
      throw new ArgumentError("string: $input");
    }
    if (input.length == 0) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  static String convertDate(String date){
    String newDate = date[6] + date[7] + date[8] + date[9] + date[3] + date[4] + date[5] + date[0] + date[1] + date[2];
    return newDate;
  }
}

class SnilsCameraWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CameraWidget(),
    );
  }

}
