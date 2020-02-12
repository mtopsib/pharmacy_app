import 'package:flutter/material.dart';

class TechSupportWidget extends StatefulWidget{
  _TechSupportWidgetState createState() => _TechSupportWidgetState();
}

class _TechSupportWidgetState extends State<TechSupportWidget>{
  final formKey = GlobalKey<FormState>();
  
  List<Widget> messages = List<Widget>();
  String newMessage;
  
  @override
  void initState() {
    super.initState();
    messages.add(TechSupportAnswer(text: 'Добрый день, чем мы можем помочь?', date: '01.01.2020',));
    messages.add(TechSupportQuestion(text: 'Здравствуйте, как можно вам позвонить?', date: '01.01.2020',));
  }

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
              flex: 3,
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index){
                  return messages[index];
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Form(
                key: formKey,
                child: TextFormField(
                  onSaved: (value) {newMessage = value;},
                  validator: (value){
                    if (value.isEmpty){
                      return 'Введите сообщение';
                    } else {
                      return null;
                    }
                  },
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Введите текст сообщения'
                  ),
                ),
              ),
            ),
            Container(
              child: FlatButton(
                onPressed: _sendMessage,
                color: Colors.blue,
                child: Text('Отправить сообщение'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendMessage(){
    if (formKey.currentState.validate()){
      formKey.currentState.save();
      messages.add(TechSupportQuestion(text: newMessage, date: "12.02.2020",));
      setState(() {
      });
    }
  }

}

class TechSupportAnswer extends StatelessWidget{
  final String text;
  final String date;

  const TechSupportAnswer({Key key, this.text, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Text(date),
                Expanded(
                  child: Text('Тех поддержка:', textAlign: TextAlign.right,)
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
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Text('Я', style: TextStyle(fontWeight: FontWeight.bold),),
                Expanded(child: Text(date, textAlign: TextAlign.right,))
              ],
            ),
          ),
          Text(text, textAlign: TextAlign.left,),
          Divider(color: Colors.black,)
        ],
      ),
    );
  }

}