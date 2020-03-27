import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharmacy_app/server_wrapper.dart';

class MessagesWidget extends StatefulWidget{
  final String messageId;

  const MessagesWidget({Key key, this.messageId}) : super(key: key);

  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget>{
  final formKey = GlobalKey<FormState>();
  
  String newMessage;
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сообщения'),
      ),
      body: FutureBuilder(
        future: ServerMessages.getMessage(widget.messageId),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            List<dynamic> messages = snapshot.data["Messages"];
            return Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Тема: ${snapshot.data["Header"]}", style: TextStyle(fontSize: 16)),
                  Divider(),
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index){
                        Map<String, dynamic> data = messages[index];
                        if (data["Source"] == "Service"){
                          return MessageAnswer(
                            text: data["Body"],
                            date: data["Date"],
                            sourceName: data["SourceName"],
                          );
                        } else {
                          return MessageQuestion(
                            text: data["Body"],
                            date: data["Date"],
                          );
                        }
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
                        controller: _textController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Введите текст сообщения'
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      onPressed: () {_sendMessage(snapshot.data["Header"].toString());},
                      color: Colors.blue,
                      child: Text('Отправить сообщение'),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }

  void _sendMessage(String header) async {
    if (formKey.currentState.validate()){
      formKey.currentState.save();
      Map<String, String> mData = {"ParentID": widget.messageId, "Header": header, "Body": newMessage};
    await ServerMessages.sendMessage(mData);
      setState(() {
      });
    }
  }

}

class MessageAnswer extends StatelessWidget{
  final String text;
  final String date;
  final String sourceName;

  const MessageAnswer({Key key, this.text, this.date, this.sourceName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(date.substring(0, 10)),
              Expanded(
                  child: Text('$sourceName:', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold),)
              )
            ],
          ),
          SizedBox(height: 10),
          Container(child: Text(text, textAlign: TextAlign.right,), alignment: Alignment.centerRight,),
          Divider(color: Colors.black,)
        ],
      ),
    );
  }

}

class MessageQuestion extends StatelessWidget{
  final String text;
  final String date;

  const MessageQuestion({Key key, this.text, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Я', style: TextStyle(fontWeight: FontWeight.bold),),
              Expanded(child: Text(date.substring(0, 10), textAlign: TextAlign.right,))
            ],
          ),
          SizedBox(height: 10),
          Container(child: Text(text, textAlign: TextAlign.left,), alignment: Alignment.centerLeft,),
          Divider(color: Colors.black,)
        ],
      ),
    );
  }

}

class MessagesListWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Сообщения"),),
      body: FutureBuilder(
        future: ServerMessages.getMessageList(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            List<dynamic> mList = snapshot.data;
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: mList.length,
                        itemBuilder: (context, index){
                          var data = mList[index];
                          return Message(
                            nickName: data["Nikname"].toString(),
                            read: !data["NotRead"],
                            messageId: data["MessageID"].toString(),
                            header: data["Header"].toString(),
                            body: data["Data"]["Body"].toString(),
                            date: data["Data"]["Date"].toString(),
                          );
                        }),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      child: Text("Новое обращение"),
                      color: Colors.blue,
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Message extends StatelessWidget{
  final String nickName;
  final String date;
  final bool read;
  final String header;
  final String messageId;
  final String body;

  const Message({Key key, this.nickName, this.date, this.read, this.header, this.messageId, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed("/Messages/Chat", arguments: messageId),
      child: Container(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("$nickName: ", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(child: Text(header, maxLines: 2,), width: 150,),
                Expanded(child: Text(date.substring(0, 10), textAlign: TextAlign.right,))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(body, maxLines: 2,),
                !read ? Icon(Icons.brightness_1, color: Colors.red, size: 10,) : SizedBox(),
              ],
            ),
            Divider(color: Colors.black,)
          ],
        ),
      ),
    );
  }

}

class NewMessage extends StatefulWidget{
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}