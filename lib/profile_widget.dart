import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pharmacy_app/camera_widget.dart';
import 'package:pharmacy_app/server_wrapper.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

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
          /*SizedBox(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              child: Text('Мои близкие', style: textStyle,),
              onPressed: () {},
            ),
          ),*/
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

class MyProfile extends StatefulWidget {
  final bool showSnilsAlert;

  const MyProfile({Key key, this.showSnilsAlert = true}) : super(key: key);

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
  String gender = "";
  bool esiaConfirm = false;
  bool emailConfirm = false;

  Widget snilsButton = SizedBox();

//  @override
//  void initState() {
//    super.initState();
//    setDataFromServer();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мой профиль'),
        actions: <Widget>[
          FlatButton(
            child: Text('Выйти', style: TextStyle(color: Colors.white),),
            onPressed: () async {
              await ServerProfile.logout();
              SharedPreferencesWrap.setLoginInfo(false);
              SharedPreferencesWrap.setConfirmationToken("");
              SharedPreferencesWrap.setAccessToken("");
              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: setDataFromServer(context),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return Container(
              margin: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text("Фамилия", style: upTextStyle),
                            ),
                            Text("$surname", style: botTextStyle,)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text("Имя", style: upTextStyle),
                            ),
                            Text("$name" ,style: botTextStyle,)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text("Отчество", style: upTextStyle),
                            ),
                            Text("$patronymic", style: botTextStyle,)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text("Дата рождения", style: upTextStyle),
                                ),
                                Text("${date.substring(0, 10)}", style: botTextStyle,)
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text("Пол", style: upTextStyle,),
                                ),
                                Text(gender, style: botTextStyle,)
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text("СНИЛС", style: upTextStyle,),
                            ),
                            Text("$snils", style: botTextStyle,)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text("Номер телефона", style: upTextStyle),
                            ),
                            Text("$number", style: botTextStyle,)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Row(
                                children: <Widget>[
                                  Text("Электронная почта   ", style: upTextStyle),
                                  //Icon(Icons.check_circle, color: emailConfirm ? Colors.lightGreen : Colors.red,)
                                ],
                              ),
                            ),
                            Text("$mail", style: botTextStyle,)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text("Авторизация через Госуслуги", style: upTextStyle,),
                            ),
                            Text(esiaConfirm ? "Пройдена" : "Не пройдена", style: botTextStyle,)
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        !esiaConfirm ? FlatButton(
                            color: Colors.blueAccent,
                            child: Text("Заполнить профиль"),
                            onPressed: () => Navigator.of(context).pushNamed('/EditProfile', arguments: {
                              "surname": surname, "name": name, "patronymic": patronymic, "date": convertDate(date), "mail": mail, "gender": gender})
                        ) : SizedBox(),
                        snilsButton,
                        !esiaConfirm ? FlatButton(
                          child: Text("Авторизация через Госуслуги"),
                          onPressed: () async {
                            var url = await ServerLogin.loginEsia();
                            if (url != ""){
                              Navigator.of(context).pushNamed("/Webview", arguments: url);
                            } else {
                              _showSnackBar(context);
                            }
                          },
                          color: Colors.blueAccent,
                        ) : FlatButton(
                          color: Colors.blueAccent,
                          child: Text("Отозвать доступ к Госуслугам"),
                          onPressed: () => showEsiaAlert(context),
                        ),
                        Center(
                          child: GestureDetector(
                              onTap: () => _launchURL("https://кэшбэк.009.рф/terms"),
                              child: Text("Лицензионное соглашение", style: TextStyle(color: Colors.lightBlueAccent))
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () => _launchURL("https://кэшбэк.009.рф/privacy-policy"),
                              child: Text("Политика конфиденциальности", style: TextStyle(color: Colors.lightBlueAccent))
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }

  void _showSnackBar(BuildContext context){
    var snackBar = SnackBar(
      content: Text("Сервер авторизации Госуслуги временно не доступен"),
      action: SnackBarAction(label: "ок", onPressed: () {},)
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static String convertDate(String date){
    if (date.length < 10) return "";
    return date[8] + date[9] + "/" + date[5] + date[6] + "/" +  date[0] + date[1] + date[2] + date[3] ;
  }

  Future<void> setDataFromServer(BuildContext context) async {
    final data = await ServerProfile.getUserProfile();
    name = data["Name"].toString() ?? "";
    surname = data["Surname"].toString() ?? "";
    patronymic = data["MiddleName"].toString() ?? "";
    date = data["Birthday"].toString().replaceAll("T", " ") ?? "";
    number = "8-" + data["Phone"].toString() ?? "";
    mail = data["eMail"].toString() ?? "";
    gender = data["Gender"].toString() == "M" ? "Мужской" : "Женский";
    esiaConfirm = data["ESIAConfirm"] as bool;
    emailConfirm = data["eMailConfirmed"] as bool;

//    if (!esiaConfirm){
//      snilsButton = FlatButton(
//        child: Text("Отправить СНИЛС"),
//        onPressed: () => Navigator.of(context).pushNamed('/Snils'),
//        color: Colors.blueAccent,
//      );
//    }
//    try{
//      town = data["Towns"][0]["Town"].toString() ?? "";
//    } catch (e){
//      town = "";
//    }
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
    if (widget.showSnilsAlert) showSnilsPopUp(context);

  }

  void showSnilsPopUp(BuildContext context){
    AlertDialog alert = AlertDialog(
      content: Text("Документ будет проверен в ближайшее время и Ваш профиль будет автоматически заполнен", textAlign: TextAlign.center),
      actions: <Widget>[
        FlatButton(child: Text("Закрыть"), onPressed: () => Navigator.of(context).pop(),)
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
    );
  }

  void showEsiaAlert(BuildContext context){
    AlertDialog alert = AlertDialog(
      content: Text("Вы действительно хотите отозвать доступ к Госуслугам?", textAlign: TextAlign.center),
      actions: <Widget>[
        FlatButton(child: Text("нет"), onPressed: () => Navigator.of(context).pop(),),
        FlatButton(child: Text("Да"), onPressed: () async {
          ServerProfile.changeUserData({"ESIAConfirm": "false"});
          Navigator.of(context).pushNamedAndRemoveUntil("/MyProfile", ModalRoute.withName('/'), arguments: false);
        },)
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context){
          return alert;
        }
    );
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
  String mail = "";
  bool male;

  @override
  void initState() {
    super.initState();
    male = widget.data["gender"] == "Мужской" ? true : false;
  }

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
                      "Gender": male == true ? "M" : "F", "Birthday": convertDate(date), "eMail": mail};
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
