import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/server_wrapper.dart';
import 'package:pharmacy_app/login_widget.dart';
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
    _homeWidgets = [HomePageWidget(), PlaceHolderWidget(color: Colors.blue,), PlaceHolderWidget(color: Colors.green,), MainProfile()];
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
      child: FlatButton(
        color: Colors.blue,
        child: Text("Token debug"),
        onPressed: () async {
          //await ServerWrapper.getNewsBody("e7fd225c-02e6-40df-b2eb-5715723413b4");
          print(await SharedPreferencesWrap.getCurrentCity());
        },
      ),
    );
  }

}

class HomePageWidget extends StatefulWidget{
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>{
  final random = Random();

  List<Widget> mainContent = new List<Widget>();

  @override
  void initState() {
    super.initState();
      refreshNews();
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ChipsWidget(),
          Container(
            child: Expanded(
              child: RefreshIndicator(
                onRefresh: () async { refreshNews();},
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: mainContent.length,
                    itemBuilder: (context, pos) => (
                        mainContent[pos]
                    )
                ),
              )
            ),
          ),
        ],
      ),
    );
  }

  void refreshNews() async {
    ServerWrapper.refreshAccessToken();
    mainContent = await ServerNews.getNewsCard();
    setState(() {

    });
  }
}

class ChipsWidget extends StatefulWidget{
  _ChipsWidgetState createState() => _ChipsWidgetState();
}

class _ChipsWidgetState extends State<ChipsWidget>{
  List<Widget> chips = new List<Widget>();
  List<dynamic> homePages;

  @override
  void initState() {
    super.initState();
    getPages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: chips
      ),
    );
  }

  void getPages() async {
    homePages = await ServerNews.getPages();
    refreshChips();

  }

  void refreshChips(){
    chips = new List<Widget>();
    for (int i = 0; i < homePages.length; i++) {
      chips.add(
          ChipWithBadge(
              name: homePages[i]["Name"].toString(),
              newsCount: homePages[i]["New"].toString(),
              id: i,
              onTap: getPages
          )
      );
    }
    setState(() {
    });
  }
}

class ChipWithBadge extends StatefulWidget{
  final Function onTap;
  final String name;
  final String newsCount;
  final int id;

  const ChipWithBadge({Key key, this.name, this.newsCount, this.id, this.onTap}) : super(key: key);

  _ChipWithBadgeState createState() => _ChipWithBadgeState();
}

class _ChipWithBadgeState extends State<ChipWithBadge>{
  static int activeWidget = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.newsCount != "0"){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Badge(
          position: BadgePosition.topRight(top: 0, right: -4),
          badgeColor: Colors.red,
          badgeContent: Text(widget.newsCount, style: TextStyle(fontSize: 10, color: Colors.white)),
          child: ChoiceChip(
            label: Text(widget.name),
            onSelected: (_) {
              activeWidget = widget.id;
              widget.onTap();
            },
            selected: widget.id == activeWidget
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: ChoiceChip(
          label: Text(widget.name),
          onSelected: (_) {
            activeWidget = widget.id;
            widget.onTap();
          },
          selected: widget.id == activeWidget,
        ),
      );
    }
  }

}