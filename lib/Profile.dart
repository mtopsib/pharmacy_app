import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProfileMain extends StatelessWidget{
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
              onPressed: () => Navigator.of(context).pushNamed('/MyProfile'),
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
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}

class ProfileMyProfile extends StatelessWidget{
  final String surname;
  final String name;
  final String patronymic;
  final String date;
  final String town;
  final String snils;
  final String number;
  final String mail;

  /*String surname;
  String name;
  String patronymic;
  String date;
  String town;
  String snils;
  String number;
  String mail; */

  final upTextStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final botTextStyle = const TextStyle(fontSize: 14);
  final topTextPadding = const EdgeInsets.only(bottom: 8);

  const ProfileMyProfile({Key key, this.surname, this.name, this.patronymic, this.date, this.town, this.snils, this.number, this.mail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: topTextPadding ,child: Text("Фамилия", style: upTextStyle)),
                Text("$surname", style: botTextStyle,)
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(child: Text("Имя", style: upTextStyle), padding: topTextPadding),
                Text("$name" ,style: botTextStyle,)
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(child: Text("Отчество", style: upTextStyle), padding: topTextPadding),
                Text("$patronymic", style: botTextStyle,)
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(child: Text("Дата рождения", style: upTextStyle), padding: topTextPadding),
                Text("$date", style: botTextStyle,)
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(child: Text("Мой город", style: upTextStyle), padding: topTextPadding),
                Text("$town", style: botTextStyle,)
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(child: Text("СНИЛС", style: upTextStyle,), padding: topTextPadding,),
                Text("$snils", style: botTextStyle,)
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(child: Text("Номер телефона", style: upTextStyle), padding: topTextPadding),
                Text("$number", style: botTextStyle,)
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(child: Text("Электронная почта", style: upTextStyle), padding: topTextPadding),
                Text("$mail", style: botTextStyle,)
              ],
            ),
          ),
          Center(
            child: FlatButton(
              color: Colors.blueAccent,
              child: Text("Заполнить профиль"),
              onPressed: () => Navigator.of(context).pushNamed('/EditProfile'),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileEdit extends StatefulWidget{
  ProfileEditState createState() => ProfileEditState();
}

class ProfileEditState extends State<ProfileEdit>{
  final topTextPadding = const EdgeInsets.only(bottom: 8);
  final upTextStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final key = GlobalKey();

  var snilsMask = MaskTextInputFormatter(mask: '###-###-###-##', filter: {"#": RegExp(r'[0-9]')});
  var phoneMask = MaskTextInputFormatter(mask: '(###) ### ##-##', filter: {'#': RegExp(r'[0-9]')});
  var dateMask = MaskTextInputFormatter(mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14),
      child: ListView(
        children: [
          Form(
          key: this.key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Ваша фамилия",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.person),
                        labelText: "Фамилия"
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Ваше имя",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.person),
                        labelText: "Имя"
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
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
                    keyboardType: TextInputType.numberWithOptions(),
                    maxLength: 14,
                    inputFormatters: [snilsMask],
                    decoration: InputDecoration(
                        hintText: "XXX-XXX-XXX-XX",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.assignment_ind),
                        labelText: "СНИЛС"
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  inputFormatters: [phoneMask],
                  maxLength: 14,
                  keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      prefixText: '+7 ',
                      hintText: "(999) 999-99-99",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.phone_android),
                      labelText: "Номер телефона"
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "example@mail.ru",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.mail),
                        labelText: "Электронная почта"
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 40,
                child: FlatButton(
                  color: Color.fromARGB(255, 68, 156, 202),
                  child: Text("Сохранить", style: TextStyle(fontSize: 18, color: Colors.grey[900]), textAlign: TextAlign.center),
                  onPressed: () {},
                ),
              ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
