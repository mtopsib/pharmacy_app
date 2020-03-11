import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';
import 'package:http/http.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'server_wrapper.dart';

class LoginWidget extends StatefulWidget{
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget>{
  final formKey = GlobalKey<FormState>();
  final phoneMask = MaskTextInputFormatter(mask: '###-###-##-##', filter: {'#': RegExp(r'[0-9]')});
  final scaKey = GlobalKey<ScaffoldState>();
  final snackBar = SnackBar(
    content: Text('Ошибка на сервере. Повторите запрос позже'),
    duration: Duration(seconds: 3),
    action: SnackBarAction(
      label: 'Назад',
      onPressed: () {},
    ),
  );

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
      key: scaKey,
      body: Container(
        margin: EdgeInsets.only(left: 10, top: 40, right: 10, bottom: 10),
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
                    validator: (value) {
                      if (value.isEmpty){
                        return 'Введите номер';
                      } else if (value.length < 13){
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
                      prefixText: "8-",
                      contentPadding: EdgeInsets.only(left: 85),
                      hintText: '___-___-__-__',
                      prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Продолжая регистрацию я подтверждаю, что ознакомился c ',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Лицензионным соглашением',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () => _launchURL("https://кэшбэк.009.рф/terms")
                    ),
                    TextSpan(text: ' и '),
                    TextSpan(
                      text: 'Политикой конфидециальности,',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () => _launchURL("https://кэшбэк.009.рф/privacy-policy")
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _tapNextButton() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Response response = await ServerLogin.loginPhone(phoneNumber);
      if (response.statusCode == 200) {
        String token = jsonDecode(response.body);
        await SharedPreferencesWrap.setConfirmationToken(token);
        Navigator.of(context).pushNamed('/LoginCheckNumber');
      }
      else {
        scaKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  void _getNews() async {
    var news = await ServerNews.getNewsCard(page: "Login");
    if (news != null) {
      newsCardWidget = news;
    } else {
      throw ("Error");
    }
    setState(() {

    });
  }

}

class LoginCheckNumberWidget extends StatefulWidget{
  _LoginCheckNumberWidgetState createState() => _LoginCheckNumberWidgetState();
}

class _LoginCheckNumberWidgetState extends State<LoginCheckNumberWidget>{
  final formKey = new GlobalKey<FormState>();
  final scaKey = new GlobalKey<ScaffoldState>();
  final snackBar = SnackBar(
    content: Text("Проблемы с интернет соединением, повторите запрос позже"),
    action: SnackBarAction(label: "Ок", onPressed: () {},),
  );

  List<Widget> newsCardWidget = List<Widget>();
  String sms;

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaKey,
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
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
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

  void _onPressedNext() async {

    if (formKey.currentState.validate()){
      formKey.currentState.save();

      final token = await SharedPreferencesWrap.getConfirmationToken();
      final info = await SharedPreferencesWrap.getDeviceInfo();
      info.remove("AccessToken");

      final url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/Phone/Login?ConfirmationCode=$sms&ConfirmationToken=$token";

      Response response = await put(url, headers: info);

      if (response.statusCode == 200){
        await SharedPreferencesWrap.setLoginInfo(true);
        var tokens = jsonDecode(response.body);
        await SharedPreferencesWrap.setRefreshToken(tokens["RefreshToken"]);
        await SharedPreferencesWrap.setAccessToken(tokens["AccessToken"]);
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      } else {
        scaKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  void _getNews() async {
    var news = await ServerNews.getNewsCard(page: "Login");
    if (news != null) {
      newsCardWidget = news;
    } else {
      throw ("Error");
    }
    setState(() {

    });
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
              child: SvgPicture.asset('assets/logo.svg', width: 300),
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