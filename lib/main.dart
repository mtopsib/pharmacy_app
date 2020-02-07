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
  int _selectedIndex = 0;

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

          body: _bodyWidget(),

          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                title: Text('Business'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                title: Text('School'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
      ),
    );
  }

  void _onItemTapped(int index){
      _selectedIndex = index;
      print(_selectedIndex);
  }

  Widget _bodyWidget(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Chip(
                      label: Text('Все'),
                    autofocus: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Chip(
                      label: Text('Новости')
                  ),
                ),
                Container(
                  child: Chip(
                      label: Text('Рецепты')
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: _buildNewsList(),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList(){
    return ListView.builder(
      itemBuilder: (context, position) {
        return NewsWidget(
          titleText: 'interesting news',
          bodyText: 'sff;saknf ;saf n;dsa f;sad fsda foyewaf ksadbf pqwiuf jksd bf spaufkjdsa; fwe ;ipfu gbsafkj ',
          botSource: "BBC",
          date: '13.02.1999',
        );
      },
    );
  }

}


