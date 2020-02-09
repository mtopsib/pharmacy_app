import 'package:flutter/material.dart';
import 'package:pharmacy_app/NewsCardWidget.dart';
import 'package:pharmacy_app/NewsWidget.dart';
import 'package:pharmacy_app/RecipesCardWidget.dart';
import 'dart:math';
import 'package:pharmacy_app/Profile.dart';

class Home extends StatefulWidget{
  _HomeState createState(){
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  int _selectedIndex = 0;

  Widget newsWidget = new NewsWidget(
    titleText: 'Мишустин назначил Александра Грибова замглавы аппарата правительства РФ',
    bodyText: """Советский и российский актёр театра и кино Андрей Ургант прокомментировал журналистам скандал, развернувшийся вокруг его сына, известного телеведущего Ивана Урганта. Ранее СМИ сообщали, что православные активисты собирают подписи под требованием лишить телеведущего российского гражданства из-за недавнего эфира, в котором они усмотрели признаки оскорбления веруюших. Кроме этого православные активисты пожелали Ивану Урганту "заболеть раком".

Андрей Ургант отметил, что ничего не знает об этой ситуации.

"Мне совершенно все равно, что думают активисты, и поэтому я к этому никак не отношусь", - передает издание "Собеседник" слова актера.

Андрей Ургант добавил, что если эти люди правомочны лишать актера гражданства за его выступление, тогда вообще непонятно что происходит в стране.

"Кстати, несколько лет назад подобные организации в Украине предлагали тому, кто отрежет голову Ивану, десять тысяч долларов", - также рассказал актер телеведущего.

Речь тогда шла о высказывании Ивана Урганта в программе "Смак". Он неудачно пошутил, что порубил зелень, как "красный комиссар жителей украинской деревни".

Андрей Ургант также не исключил, что завтра еще кто-то что-то предложит. Советский и российский актёр театра и кино Андрей Ургант прокомментировал журналистам скандал, развернувшийся вокруг его сына, известного телеведущего Ивана Урганта. Ранее СМИ сообщали, что православные активисты собирают подписи под требованием лишить телеведущего российского гражданства из-за недавнего эфира, в котором они усмотрели признаки оскорбления веруюших. Кроме этого православные активисты пожелали Ивану Урганту "заболеть раком".

Андрей Ургант отметил, что ничего не знает об этой ситуации.

"Мне совершенно все равно, что думают активисты, и поэтому я к этому никак не отношусь", - передает издание "Собеседник" слова актера.

Андрей Ургант добавил, что если эти люди правомочны лишать актера гражданства за его выступление, тогда вообще непонятно что происходит в стране.

"Кстати, несколько лет назад подобные организации в Украине предлагали тому, кто отрежет голову Ивану, десять тысяч долларов", - также рассказал актер телеведущего.

Речь тогда шла о высказывании Ивана Урганта в программе "Смак". Он неудачно пошутил, что порубил зелень, как "красный комиссар жителей украинской деревни".

Андрей Ургант также не исключил, что завтра еще кто-то что-то предложит.""",
    date: '15 января 2020 в 19:45',
    source: 'Источник: Правительство РФ ',
    url: 'https://google.com',
  );
  Widget myProfile = ProfileMyProfile(surname: "Рыжов", name: "Станислав", patronymic: "Витальевич", date: "13.02.1999", town: "Санкт-Петербург", snils: "1241-4124-4124-5436", number: "+7 (917) 218-21-97", mail: "99rsw99@mail.ru");

  List<String> _titleTexts = ['Главная', 'Рецепты', 'Главная - новость', 'профиль'];
  List<Widget> _homeWidgets;

  @override
  void initState(){
    super.initState();
    _homeWidgets = [HomePageWidget(), PlaceHolderWidget(color: Colors.green,), newsWidget, ProfileMain()];
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
  } //BottomNavBar item chang

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
    return ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, pos) => (
            children[pos]
        )
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
      date: 'Дата: 01 января 2020'
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
                    child: ActionChip(
                      label: Text('Все'),
                      onPressed: _onTapAllChip,
                    )
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ActionChip(
                    label: Text('Новости'),
                    onPressed: _onTapNewsChip,
                  ),
                ),
                Container(
                  child: ActionChip(
                    label: Text('Рецепты'),
                    onPressed: _onTapRecipeChip,
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
