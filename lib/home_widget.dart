import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:pharmacy_app/main.dart';
import 'package:pharmacy_app/news_card_widget.dart';
import 'package:pharmacy_app/recipe_widget.dart';
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
    _homeWidgets = [HomePageWidget(), ChooseRecipe(recipeID: "226292e1-f981-4aaa-93c9-3199c3df1802",), PlaceHolderWidget(color: Colors.green,), MainProfile()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_titleTexts[_selectedIndex]),
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

  PlaceHolderWidget({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
      child: FlatButton(
        color: Colors.blue,
        child: Text("Geolocation debug"),
        onPressed: () async {

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
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  List<Widget> mainContent = new List<Widget>();
  List<Widget> persistantContent = new List<Widget>();

  @override
  void initState() {
    super.initState();
      refreshNews();
      webViewListener();
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                ChipsWidget(
                  onTap: filterNews,
                ),
              ],
            )
          ),
          Container(
            child: Expanded(
              child: RefreshIndicator(
                onRefresh: () async { refreshNews();},
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: persistantContent.length,
                    itemBuilder: (context, pos) => (
                        persistantContent[pos]
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
    filterNews();
    setState(() {
    });
  }

  void filterNews() {
    List<Widget> filteredContent = new List();
    var chipName = _ChipWithBadgeState.activeWidgetName;
    if (chipName == "Все") {
      persistantContent = mainContent;
      setState(() {});
      return;
    }
    for (int i = 0; i < mainContent.length; i++){
      switch(mainContent[i].toStringShort()){
        case "NewsCard":
          if (chipName == "Новости"){
            filteredContent.add(mainContent[i]);
          }
          break;
        case "RecipeCard":
          if (chipName == "Рецепты"){
            filteredContent.add(mainContent[i]);
          }
          break;
      }
    }
    persistantContent = filteredContent;
    setState(() {});
  }

  void webViewListener(){
    flutterWebViewPlugin.onUrlChanged.listen((url){
      print(url);
    });
  }
}

class ChipsWidget extends StatefulWidget{
  final Function onTap;

  const ChipsWidget({Key key, this.onTap}) : super(key: key);

  _ChipsWidgetState createState() => _ChipsWidgetState();
}

class _ChipsWidgetState extends State<ChipsWidget>{
  List<Widget> chips = new List<Widget>();
  List<dynamic> homePages;
  List<GlobalKey> keys = new List();

  @override
  void initState() {
    super.initState();
    getPages();
    _ChipWithBadgeState.activeWidgetName = "Все";
    refreshChipsFast();
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
    chips.clear();
    keys.add(GlobalKey<_ChipWithBadgeState>());
    chips.add(ChipWithBadge(
      key: keys[0],
      name: "Все",
      newsCount: "0",
      id: "Все",
      onTap: () {
        refreshChipsFast();
        widget.onTap();
      },
    ));
    for (int i = 0; i < homePages.length; i++) {
      keys.add(GlobalKey<_ChipWithBadgeState>());
      chips.add(
          ChipWithBadge(
            key: keys[i+1],
            name: homePages[i]["Name"].toString(),
            newsCount: homePages[i]["New"].toString(),
            id: homePages[i]["Name"].toString(),
            onTap: () {
              refreshChipsFast();
              widget.onTap();
            },
          )
      );
    }
    setState(() {});
  }

  void refreshChipsFast() {
    for (int i = 0; i < keys.length; i++){
      keys[i].currentState.setState((){});
    }
  }
}

class ChipWithBadge extends StatefulWidget{
  final Function onTap;
  final String name;
  final String newsCount;
  final String id;

  const ChipWithBadge({Key key, this.name, this.newsCount, this.id, this.onTap}) : super(key: key);

  _ChipWithBadgeState createState() => _ChipWithBadgeState();
}

class _ChipWithBadgeState extends State<ChipWithBadge>{
  static String activeWidgetName;
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
              activeWidgetName = widget.id;
              widget.onTap();
            },
            selected: widget.id == activeWidgetName
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: ChoiceChip(
          label: Text(widget.name),
          onSelected: (_) {
            activeWidgetName = widget.id;
            widget.onTap();
          },
          selected: widget.id == activeWidgetName,
        ),
      );
    }
  }
}