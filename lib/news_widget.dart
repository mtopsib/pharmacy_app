import 'package:flutter/material.dart';
import 'package:pharmacy_app/server_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsWidget extends StatefulWidget{
  final String newsID;
  const NewsWidget(this.newsID, {Key key}) : super(key: key);

  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget>{
  final scaKey = GlobalKey<ScaffoldState>();
  Map<String, String> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaKey,
      appBar: AppBar(
          title: Text('Главная - Новости'),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false)),
           ),
      body: FutureBuilder(
        future: _initializeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            return Container(
              //margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(4),
              color: Color.fromARGB(255, 217, 253, 255),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Text(data['Header'], style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(data["Date"], style: TextStyle(
                                  fontSize: 9, color: Colors.black54),),
                            ),
                            Text(data["Source"], style: TextStyle(
                                fontSize: 9, color: Colors.black54))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Text(data["Body"]),
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
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> _initializeData() async {
    data = await ServerNews.getNewsBody(widget.newsID);
  }

  _launchURL() async {
    if (await canLaunch(data["ext_link"])) {
      await launch(data["ext_link"]);
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
