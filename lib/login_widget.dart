import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';

class LoginWidget extends StatefulWidget{
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget>{
  final formKey = GlobalKey<FormState>();
  final phoneMask = MaskTextInputFormatter(mask: '+7-###-###-##-##', filter: {'#': RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('009. Электронные рецепты', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SvgPicture.asset('assets/Farmacia2.svg', width: 200,),
              Text('Введите номер телефона'),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    inputFormatters: [phoneMask],
                    keyboardType: TextInputType.numberWithOptions(),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '+7-___-___-__-__',
                      border: InputBorder.none
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
                  onPressed: () {
                    SharedPreferencesWrap.setLogginInfo(true).then((_) => Navigator.of(context).pushNamed('/LoginCheckNumber'));
                  }
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text('Версия 0.8.0'),
                ),
              )
            ],
          )
        ),
    );
  }

}

class LoginCheckNumberWidget extends StatefulWidget{
  _LoginCheckNumberWidgetState createState() => _LoginCheckNumberWidgetState();
}

class _LoginCheckNumberWidgetState extends State<LoginCheckNumberWidget>{
  final formKey = new GlobalKey<FormState>();
  String sms;

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
                    onPressed: () async {
                      if (formKey.currentState.validate()){
                        formKey.currentState.save();
                        Navigator.of(context).pushNamed('/');
                    }
                  },
                ),
              ),
              Container(
                height: 50,
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
            ],
          )
      ),
    );
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
              child: SvgPicture.asset('assets/Farmacia2.svg'),
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