import 'package:flutter/material.dart';
import 'package:pharmacy_app/NewsWidget.dart';
import 'package:pharmacy_app/RecipesWidget.dart';

class Home extends StatefulWidget{
  _HomeState createState(){
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  int _selectedIndex = 0;
  List<Widget> _children = [PlaceHolderWidget(color: Colors.red,), PlaceHolderWidget(color: Colors.black45,), PlaceHolderWidget(color: Colors.green,), PlaceHolderWidget(color: Colors.yellow,)];

  @override
  Widget build(BuildContext context) {
    _children[0] = _homeWidget();
    return Scaffold(
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

      body: _children[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Главная'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Рецепты'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            title: Text('Уведомления'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Профиль'),
          ),
        ],
      ),
    );
  }

  Widget _homeWidget(){
    return Container(
      child: Column(
        children: <Widget>[
          Chips(),
          Container(
              child: Expanded(
                child: _buildNewsList(),
              )
          ),
        ],
      ),
    );
  } //Home widget builder func

  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  } //BottomNavBar item chang

  Widget _buildNewsList(){
    return ListView.builder(
      itemBuilder: (context, position) {
        return RecipeWidget(

        );
        /*NewsWidget(
          titleText: 'Новое приложение для электронных рецептов',
          bodyText: 'Сегодня на аппаратном совещании о развитии региональных авиаперевозок доложили гендиректор ООО «Международный Аэропорт Кемерово имени ...',
          botSource: "Источние РИА НОВОСТИ",
          date: 'Дата: 01 января 2020',
        );*/
      },
    );
  }
}

class Chips extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: ActionChip(
              label: Text('Все'),
              onPressed: _chipPressed,
            )
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ActionChip(
                label: Text('Новости'),
                onPressed: _chipPressed,
            ),
          ),
          Container(
            child: ActionChip(
                label: Text('Рецепты'),
              onPressed: _chipPressed,
            ),
          ),
        ],
      ),
    );
  }

  void _chipPressed(){
    print('I was pressed');
  }

}

class PlaceHolderWidget extends StatelessWidget{
  final Color color;

  const PlaceHolderWidget({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
    );
  }


} //Widget for testing