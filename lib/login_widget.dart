import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';
import 'package:http/http.dart';
import 'package:pharmacy_app/news_card_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginWidget extends StatefulWidget{
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget>{
  final formKey = GlobalKey<FormState>();
  final phoneMask = MaskTextInputFormatter(mask: '8-###-###-##-##', filter: {'#': RegExp(r'[0-9]')});

  String phoneNumber;
  int newsCount = 20;

  List<Widget> newsCardWidget = List<Widget>();

  @override
  void initState() {
    super.initState();
    _getNews();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('009. Электронные рецепты', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SvgPicture.asset('assets/logo.svg', width: 180),
              Text('Введите номер телефона', style: TextStyle(fontSize: 16),),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    autofocus: true,
                    validator: (value) {
                      if (value.isEmpty){
                        return 'Введите номер';
                      } else if (value.length < 15){
                        return 'Введите корректный номер телефона';
                      } else {
                        return null;
                      }
                    },
                    inputFormatters: [phoneMask],
                    keyboardType: TextInputType.numberWithOptions(),
                    textAlign: TextAlign.start,
                    onSaved: (value) => phoneNumber = value,
                    style: TextStyle(fontSize: 20, letterSpacing: 1),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 85),
                      hintText: '8-___-___-__-__',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Продолжая регистрация я подтверждаю, что ознакомился c ',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Лицензионным соглашением',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () => print("Tap on license")
                    ),
                    TextSpan(text: ' и '),
                    TextSpan(
                      text: 'Политикой конфидециальности,',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () => print("Tap on confidence")
                    ),
                    TextSpan(
                      text: ' и выражаю своё согласие на обработку персональных данных'
                    )
                  ]
                )
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: 300,
                child: FlatButton(
                  color: Color.fromARGB(255, 68, 156, 202),
                  textColor: Colors.black,
                  child: Text("Далее"),
                  onPressed: _tapNextButton
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: newsCardWidget.length,
                    itemBuilder: (context, index){
                      return newsCardWidget[index];
                    }
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text('Версия 0.8.0'),
              ),
            ],
          )
        ),
    );
  }

  void _tapNextButton() async {
    if (formKey.currentState.validate()){
      formKey.currentState.save();
    }
    String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Phone/Login?Phone=' + phoneNumber;
    String deviceID = '41bf1a6712334';
    String appID = 'ea1f1bc1-c552-4787-8d99-9cac5b5b377d';
    String instanceID = '41bf1a67-0653-4aac-8941-89c7b4016792';
    String basic = 'Basic UmVjaXBlOip3c2VXU0U1NSo=';
    Map<String, String> headers = {"DeviceID" : deviceID, 'AppID': appID,  'InstanceID': instanceID, 'Authorization': basic, 'accept': 'application/json'};
    Response response = await post(url, headers: headers);
    if (response.statusCode == 200)
      {
        String token = jsonDecode(response.body);
        await SharedPreferencesWrap.setConfirmationToken(token);
        print(response.body);
        Navigator.of(context).pushNamed('/LoginCheckNumber');
      }
  }

  void _getNews() async {
    String page = "Profile";
    String From;
    String onlyNew;
    String accessToken;
    String deviceID = '41bf1a6712334';
    String appID = 'ea1f1bc1-c552-4787-8d99-9cac5b5b377d';
    String instanceID = '41bf1a67-0653-4aac-8941-89c7b4016792';
    String basic = 'Basic UmVjaXBlOip3c2VXU0U1NSo=';

    final String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/MainPage?Count=' + newsCount.toString() + "&Page=$page";

    Map<String, String> headers = {"DeviceID" : deviceID, 'AppID': appID,  'InstanceID': instanceID, 'Authorization': basic, 'accept': 'application/json'};
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200){
      List<dynamic> news = jsonDecode(response.body)['Records'];
      //print(news[0]['Data']);
      for(int i = 0; i < news.length; i++){
        Map<String, dynamic> data = news[i]['Data'];
        newsCardWidget.add(new NewsCard(
          titleText: data['Header'].toString(),
          bodyText: data['Body'].toString(),
          botSource: data['Source'].toString(),
          date: data['Date'].toString().replaceAll("T", ' '),
          )
        );
      }
      print(newsCardWidget.length);
      setState(() {

      });
    }
  }

}

class LoginCheckNumberWidget extends StatefulWidget{
  _LoginCheckNumberWidgetState createState() => _LoginCheckNumberWidgetState();
}

class _LoginCheckNumberWidgetState extends State<LoginCheckNumberWidget>{
  final formKey = new GlobalKey<FormState>();

  List<Widget> newsCardWidget = List<Widget>();
  String sms;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('009. Электронные рецепты', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text('На номер указанного Вами телефона отправленна СМС с 4-х значным кодом доступа в приложение', textAlign: TextAlign.center,),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    onSaved: (value) => sms = value,
                    validator: (value) {
                      if (value.isEmpty){
                        return 'Введите код из смс';
                      } else if (value.length < 4){
                        return 'Код должен быть 4-х значным';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.numberWithOptions(),
                    textAlign: TextAlign.center,
                    maxLength: 4,
                    autofocus: true,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                        hintText: '****',
                        border: OutlineInputBorder(),
                        labelText: 'Введите 4-х значный код из СМС'
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: 300,
                child: FlatButton(
                    color: Color.fromARGB(255, 68, 156, 202),
                    textColor: Colors.black,
                    child: Text("Продолжить"),
                    onPressed: _onPressedNext,
                ),
              ),
              Container(
                height: 20,
              ),
              Text('Если СМС не пришло, проверьте правильность введеного Вами номера телефона и повторите запрос'),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: 300,
                child: FlatButton(
                    color: Color.fromARGB(255, 68, 156, 202),
                    textColor: Colors.black,
                    child: Text("Назад"),
                    onPressed: () => Navigator.pop(context)
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: newsCardWidget.length,
                    itemBuilder: (context, index) {
                      return newsCardWidget[index];
                      }
                    ),
              ),
              Text('Версия 0.8.0')
            ],
          )
      ),
    );
  }

  void _getNews() async {
    final String url = 'https://es.svodnik.pro:55443/es_test/ru_RU/hs/recipe/MainPage?Count=20';
    String page;
    String From;
    String onlyNew;
    String accessToken;
    String deviceID = '41bf1a6712334';
    String appID = 'ea1f1bc1-c552-4787-8d99-9cac5b5b377d';
    String instanceID = '41bf1a67-0653-4aac-8941-89c7b4016792';
    String basic = 'Basic UmVjaXBlOip3c2VXU0U1NSo=';
    Map<String, String> headers = {"DeviceID" : deviceID, 'AppID': appID,  'InstanceID': instanceID, 'Authorization': basic, 'accept': 'application/json'};
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200){
      List<dynamic> news = jsonDecode(response.body)['Records'];
      //print(news[0]['Data']);
      for(int i = 0; i < news.length; i++){
        Map<String, dynamic> data = news[i]['Data'];
        newsCardWidget.add(new NewsCard(
          titleText: data['Header'].toString(),
          bodyText: data['Body'].toString(),
          botSource: data['Source'].toString(),
          date: data['Date'].toString().replaceAll("T", ' '),
        )
        );
      }
      setState(() {

      });
    }
  }

  void _onPressedNext() async {

    if (formKey.currentState.validate()){
      formKey.currentState.save();

      final String token = await SharedPreferencesWrap.getConfirmationToken();
      final String deviceID = '41bf1a6712334';
      final String appID = 'ea1f1bc1-c552-4787-8d99-9cac5b5b377d';
      final String instanceID = '41bf1a67-0653-4aac-8941-89c7b4016792';
      final url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Phone/Login?ConfirmationCode=$sms&ConfirmationToken=$token";//+token.replaceAll('"', '');
      print(url);
      Map<String, String> headers = {"DeviceID": deviceID, "AppID": appID, "InstanceID": instanceID, "Authorization": 'Basic UmVjaXBlOip3c2VXU0U1NSo='};
      Response response = await put(url, headers: headers);
      if (response.statusCode == 200){
        await SharedPreferencesWrap.setLogginInfo(true);
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      } else {
        print(response.statusCode);
      }
    }
  }

}

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Text("009. Электронные рецепты", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: Image.asset('assets/logo.png', width: 300,),
            ),
            Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text("Версия 0.8.0")
              ),
            )
          ],
        ),
      ),
    );
  }

}