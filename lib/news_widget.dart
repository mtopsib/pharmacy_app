import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsWidget extends StatelessWidget{
  final String titleText;
  final String date;
  final String source;
  final String bodyText;
  final String url;

  const NewsWidget({Key key, this.titleText, this.date, this.source, this.bodyText, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(4),
      color: Color.fromARGB(255, 217, 253, 255),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Column(
              children: <Widget>[
                Text(titleText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(date, style: TextStyle(fontSize: 9, color: Colors.black54),),
                    ),
                    Text(source, style: TextStyle(fontSize: 9, color: Colors.black54))
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Text(bodyText),
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
    );
  }

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}