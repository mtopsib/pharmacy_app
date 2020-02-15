import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsWidget extends StatefulWidget{
  final List<String> data;

  const NewsWidget({Key key, this.data}) : super(key: key);

  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget>{

  final scaKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaKey,
      appBar: AppBar(title: Text('Главная - Новости')),
      body: Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.all(4),
        color: Color.fromARGB(255, 217, 253, 255),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Column(
                children: <Widget>[
                  Text(widget.data[0], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(widget.data[1], style: TextStyle(fontSize: 9, color: Colors.black54),),
                      ),
                      Text(widget.data[2], style: TextStyle(fontSize: 9, color: Colors.black54))
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Text(widget.data[3]),
                ],
              ),
            ),
            FlatButton(
              color: Color.fromARGB(255, 68, 156, 202),
              child: Text('Перейти на сайт'),
              onPressed: _launchURL,
            )
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    if (await canLaunch(widget.data[4])) {
      await launch(widget.data[4]);
    } else {
      final snackBar =  SnackBar(
        content: Text("Ошибка при открытии ссылки"),
        action: SnackBarAction(
          label: "ок",
          onPressed: (){},
        ),
      );
      scaKey.currentState.showSnackBar(snackBar);
    }
  }

}