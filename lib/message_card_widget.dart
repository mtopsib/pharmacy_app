import 'package:flutter/material.dart';
import 'package:pharmacy_app/server_wrapper.dart';

class MessageCard extends StatelessWidget{
  final String messageID;
  final String titleText;
  final String bodyText;
  final String botSource;
  final String date;
  final String url;
  final bool read;

  const MessageCard({Key key, this.messageID, this.titleText, this.bodyText, this.botSource, this.date, this.url, this.read}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 195, 243, 208), Color.fromARGB(255, 73, 201, 224)]
          )
      ),
      height: 100.0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("/Messages/Chat", arguments: messageID);
        },
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 300,
                  alignment: Alignment(-1.0, -1.0),
                  child: Text(
                    titleText,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                  padding: EdgeInsets.fromLTRB(4, 4, 0, 0),
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: read ? Icon(
                      Icons.brightness_1,
                      color: Colors.red,
                      size: 10,
                    ) : SizedBox()
                )
              ],
            ),
            Expanded(
              child: Container(
                  child: Text(
                    bodyText,
                    maxLines: 2,
                    style: TextStyle(fontSize: 11),
                  ),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(4)
              ),
            ),
            Container(
              padding: EdgeInsets.all(4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      botSource,
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                  Text(
                      date.substring(0, 10),
                      style: TextStyle(fontSize: 11)
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void readMessage(String newsID) async {
    await ServerNews.readNews(newsID);
  }
}