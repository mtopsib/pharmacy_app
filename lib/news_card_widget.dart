import 'package:flutter/material.dart';
import 'package:pharmacy_app/news_widget.dart';
import 'package:pharmacy_app/server_wrapper.dart';

class NewsCard extends StatelessWidget{
  final String newsID;
  final String titleText;
  final String bodyText;
  final String botSource;
  final String date;
  final String url;
  final bool read;

  const NewsCard({Key key, this.titleText, this.bodyText, this.botSource, this.date, this.url, this.newsID, this.read}) : super(key: key);

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
          readNews(newsID);
          Navigator.of(context).pushNamed('/News', arguments: newsID);
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
                    child: Icon(Icons.star, size: 14, color: read ? Colors.white : Colors.black,),
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
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                        date,
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

  void readNews(String newsID) async {
    await ServerNews.readNews(newsID);
  }
}