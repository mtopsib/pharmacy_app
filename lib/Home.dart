import 'package:flutter/material.dart';
import 'package:pharmacy_app/NewsCardWidget.dart';
import 'package:pharmacy_app/NewsWidget.dart';
import 'package:pharmacy_app/RecipesCardWidget.dart';

class Home extends StatefulWidget{
  _HomeState createState(){
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  int _selectedIndex = 0;

  Widget recipeWidget = RecipeCard(
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
  List<String> _titleTexts = ['Главная', 'Рецепты', 'Главная - новость', 'профиль'];
  List<Widget> _homeWidgets = [PlaceHolderWidget(color: Colors.red,), PlaceHolderWidget(color: Colors.black45,), PlaceHolderWidget(color: Colors.green,), PlaceHolderWidget(color: Colors.yellow,)];

  @override
  Widget build(BuildContext context) {
    _homeWidgets[0] = _homeWidget();
    _homeWidgets[1] = recipeWidget;
    _homeWidgets[2] = NewsWidget(
      titleText: 'Мишустин назначил Александра Грибова замглавы аппарата правительства РФ',
      date: '15 января 2020 в 19:45',
      source: 'Источник: Правительство РФ',
      bodyText: 'Советский и российский актёр театра и кино Андрей Ургант прокомментировал журналистам скандал, развернувшийся вокруг его сына, известного телеведущего Ивана Урганта. Ранее СМИ сообщали, что православные активисты собирают подписи под требованием лишить телеведущего российского гражданства из-за недавнего эфира, в котором они усмотрели признаки оскорбления веруюших. Кроме этого православные активисты пожелали Ивану Урганту "заболеть раком".Андрей Ургант отметил, что ничего не знает об этой ситуации."Мне совершенно все равно, что думают активисты, и поэтому я к этому никак не отношусь", - передает издание "Собеседник" слова актера.Андрей Ургант добавил, что если эти люди правомочны лишать актера гражданства за его выступление, тогда вообще непонятно что происходит в стране."Кстати, несколько лет назад подобные организации в Украине предлагали тому, кто отрежет голову Ивану, десять тысяч долларов", - также рассказал актер телеведущего.Речь тогда шла о высказывании Ивана Урганта в программе "Смак". Он неудачно пошутил, что порубил зелень, как "красный комиссар жителей украинской деревни".Андрей Ургант также не исключил, что завтра еще кто-то что-то предложит. Советский и российский актёр театра и кино Андрей Ургант прокомментировал журналистам скандал, развернувшийся вокруг его сына, известного телеведущего Ивана Урганта. Ранее СМИ сообщали, что православные активисты собирают подписи под требованием лишить телеведущего российского гражданства из-за недавнего эфира, в котором они усмотрели признаки оскорбления веруюших. Кроме этого православные активисты пожелали Ивану Урганту "заболеть раком".Андрей Ургант отметил, что ничего не знает об этой ситуации."Мне совершенно все равно, что думают активисты, и поэтому я к этому никак не отношусь", - передает издание "Собеседник" слова актера.Андрей Ургант добавил, что если эти люди правомочны лишать актера гражданства за его выступление, тогда вообще непонятно что происходит в стране."Кстати, несколько лет назад подобные организации в Украине предлагали тому, кто отрежет голову Ивану, десять тысяч долларов", - также рассказал актер телеведущего.Речь тогда шла о высказывании Ивана Урганта в программе "Смак". Он неудачно пошутил, что порубил зелень, как "красный комиссар жителей украинской деревни".Андрей Ургант также не исключил, что завтра еще кто-то что-то предложит.',
      url: 'https://google.com'
    );
    return Scaffold(
      appBar: AppBar(
          title: Text(_titleTexts[_selectedIndex]),
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
        return NewsCard(
          titleText: 'Новое приложение для электронных рецептов',
          bodyText: 'Сегодня на аппаратном совещании о развитии региональных авиаперевозок доложили гендиректор ООО «Международный Аэропорт Кемерово имени ...',
          botSource: "Источние РИА НОВОСТИ",
          date: 'Дата: 01 января 2020',
        );
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