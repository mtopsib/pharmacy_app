import 'package:flutter/material.dart';

class NewsWidget extends StatefulWidget{
  final String titleText;
  final String bodyText;
  final String botSource;
  final String date;

  const NewsWidget({Key key, this.titleText, this.bodyText, this.botSource, this.date}) : super(key: key);

  @override
  _NewsWidgetState createState() => _NewsWidgetState(titleText, bodyText, botSource, date);
}

class _NewsWidgetState extends State<NewsWidget>{
  final String titleText;
  final String bodyText;
  final String botSource;
  final String date;

  _NewsWidgetState(this.titleText, this.bodyText, this.botSource, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(6),
      ),
      height: 100.0,
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
                titleText,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left
            ),
            padding: EdgeInsets.all(2),
          ),
          Expanded(
            child: Container(
              child: Text(
                  bodyText,
                  maxLines: 3,
              ),
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(4),
            ),

          ),
          Container(
            padding: EdgeInsets.all(4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(botSource),
                ),
                Text(date)
              ],
            ),
          ),
        ],
      ),
    );
  }

}