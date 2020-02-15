import 'package:flutter/material.dart';
import 'package:pharmacy_app/login_widget.dart';
import 'package:pharmacy_app/news_card_widget.dart';
import 'package:pharmacy_app/news_widget.dart';
import 'package:pharmacy_app/recipe_card_widget.dart';
import 'dart:math';
import 'package:pharmacy_app/profile_widget.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';


class Home extends StatefulWidget{
  _HomeState createState(){
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  Widget startPage = SplashScreen();

  @override
  void initState() {
    super.initState();
    SharedPreferencesWrap.firstOpen().then((_){
      SharedPreferencesWrap.getLoginInfo().then((logState) {
        startPage = logState == false ? LoginWidget() : HomeLogged();
        setState(() {
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return startPage;
  }
}

class HomeLogged extends StatefulWidget{
  _HomeLoggedState createState() => _HomeLoggedState();
}

class _HomeLoggedState extends State<HomeLogged>{
  int _selectedIndex = 0;

  List<String> _titleTexts = ['Главная', 'Рецепты', 'Главная - новость', 'профиль'];
  List<Widget> _homeWidgets;

  @override
  void initState(){
    super.initState();
    _homeWidgets = [HomePageWidget(), PlaceHolderWidget(color: Colors.red,), PlaceHolderWidget(color: Colors.green,), MainProfile()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_titleTexts[_selectedIndex]),
          leading: Container(
            margin: EdgeInsets.all(3),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage('https://sun9-34.userapi.com/c851528/v851528050/18be99/nCNut-hmPpI.jpg')
                )
            ),
          )
      ),

      body: _homeWidgets[_selectedIndex],

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

  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
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

class HomeListView extends StatelessWidget{
  final List<Widget> children;

  const HomeListView({Key key, @required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await new Future.delayed(new Duration(seconds: 3));
        return null;
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: children.length,
        itemBuilder: (context, pos) => (
            children[pos]
        )
      ),
    );
  }

}

class HomePageWidget extends StatefulWidget{
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>{
  final random = Random();

  List<Widget> homeListViewWidgets;
  List<Widget> currentHomeListViewWidgets;

  final Widget newsCard = new NewsCard(
      titleText: 'Новое приложение для электронных рецептов',
      bodyText: 'Сегодня на аппаратном совещании о развитии региональных авиаперевозок доложили гендиректор ООО «Международный Аэропорт Кемерово имени ...',
      botSource: 'Источник: РИА НОВОСТИ',
      date: 'Дата: 01 января 2020',
      url: "https://google.com",
  );
  final Widget recipeWidget = new RecipeCard(
    recipeName: '32ЛП000001-000001',
    tradeName: "Анальгин",
    mnn: "Метамизол натрия (Metamizole sodium)",
    dosage: "0.003",
    form: "тюб",
    standartCount: 1.toString(),
    duration: 20.toString(),
    tabletsPerDay: 2.toString(),
    source: 'НКГБ №1',
    personName: 'Иванов Иван Иванович',
    date: '01 нваря 2020',
  );

  int _selectedValue = 0;

  @override
  void initState() {
    super.initState();
    homeListViewWidgets = List<Widget>.generate(20, (index) => random.nextInt(2) == 0 ? newsCard : recipeWidget);
    currentHomeListViewWidgets = homeListViewWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: ChoiceChip(
                      label: Text('Все'),
                      selected: 0 == _selectedValue,
                      onSelected: (selecet) => setState(() {
                        _selectedValue = 0;
                        _onTapAllChip();
                      }),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    selected: 1 == _selectedValue,
                    label: Text('Новости'),
                    onSelected: (select) => setState((){
                      _selectedValue = 1;
                      _onTapNewsChip();
                    }),
                  ),
                ),
                Container(
                  child: ChoiceChip(
                    selected: 2 == _selectedValue,
                    label: Text('Рецепты'),
                    onSelected: (select) => setState((){
                      _selectedValue = 2;
                      _onTapRecipeChip();
                    }),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: HomeListView(children: currentHomeListViewWidgets),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapAllChip(){
    setState(() {
      currentHomeListViewWidgets = homeListViewWidgets;
    });
    /*setState(() {
      currentHomeListViewWidgets = homeListViewWidgets;
      print(currentHomeListViewWidgets.length);
      homeListView = HomeListView(children: currentHomeListViewWidgets);
    });*/
  }

  void _onTapNewsChip(){
    setState(() {
      currentHomeListViewWidgets = new List<Widget>();
      for (int i = 0; i < homeListViewWidgets.length; i++){
        if (homeListViewWidgets[i].toStringShort() == 'NewsCard'){
          currentHomeListViewWidgets.add(homeListViewWidgets[i]);
        }
      }
      print(currentHomeListViewWidgets.length);
    });
  }

  void _onTapRecipeChip(){
    setState(() {
      currentHomeListViewWidgets = new List<Widget>();
      for (int i = 0; i < homeListViewWidgets.length; i++){
        if (homeListViewWidgets[i].toStringShort() == 'RecipeCard'){
          currentHomeListViewWidgets.add(homeListViewWidgets[i]);
        }
      }
      print(currentHomeListViewWidgets.length);
    });
  }
}
