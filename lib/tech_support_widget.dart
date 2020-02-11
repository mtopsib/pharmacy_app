import 'package:flutter/material.dart';

class TechSupportWidget extends StatefulWidget{
  _TechSupportWidgetState createState() => _TechSupportWidgetState();
}

class _TechSupportWidgetState extends State<TechSupportWidget>{
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тех. поддержка'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  TechSupportAnswer(text: 'Добрый день, чем мы можем помочь?', date: '01.01.2020',),
                  TechSupportQuestion(text: 'Здравствуйте, как можно вам позвонить?', date: '01.01.2020',)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Form(
                key: formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Введите текст сообщения'
                  ),
                ),
              ),
            ),
            Container(
              child: FlatButton(
                onPressed: () {},
                color: Colors.blue,
                child: Text('Отправить сообщение'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TechSupportAnswer extends StatelessWidget{
  final String text;
  final String date;

  const TechSupportAnswer({Key key, this.text, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Text(date),
                Container(
                    child: Text('Тех поддержка:', textAlign: TextAlign.right,),
                    alignment: Alignment.centerRight, color: Colors.red,
                )
              ],
            ),
          ),
          Text(text),
          Divider(color: Colors.black,)
        ],
      ),
    );
  }

}

class TechSupportQuestion extends StatelessWidget{
  final String text;
  final String date;

  const TechSupportQuestion({Key key, this.text, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Я', style: TextStyle(fontWeight: FontWeight.bold),),
              Text(date)
            ],
          ),
          Text(text)
        ],
      ),
    );
  }

}