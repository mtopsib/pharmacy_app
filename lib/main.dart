import 'package:flutter/material.dart';
import 'package:pharmacy_app/NewsWidget.dart';

void main() => runApp(MainPage());

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyMaterialApp();
  }
}

class MyMaterialApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "mainPage",
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              title: Text('Главная'),
              leading: Container(
                margin: EdgeInsets.fromLTRB(8, 4, 4, 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')
                  ),
                ),
              )


          ),

          body: Container(
            child: Column(
              children: <Widget>[
                NewsWidget(
                  titleText: 'Bla Bla Bla',
                  bodyText: 'sdgaklbgsdbghdsglsdgsdfklk lsahfjklsahfl kjfhds flkj sdajkf dalkjshf jlkdhs ajlkfh sadlkjf lkjafhsadkjl hfkjlasd fsdfa kjbhl sdgaklbgsdbghdsglsdgsdfklk lsahfjklsahfl kjfhds flkj sdajkf dalkjshf jlkdhs ajlkfh sadlkjf lkjafhsadkjl hfkjlasd fsdfa kjbhl sdgaklbgsdbghdsglsdgsdfklk lsahfjklsahfl kjfhds flkj sdajkf dalkjshf jlkdhs ajlkfh sadlkjf lkjafhsadkjl hfkjlasd fsdfa kjbhl',
                  botSource: 'source NBC',
                  date: '13.02.1999',
                ),

              ],
            ),
          ),

          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(
              height: 60.0,
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.black45, Colors.black54],
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.circular(5.0)
              ),
              child: Row(
                children: <Widget>[
                ],
              ),
            ),
          )
      ),
    );
  }

}


