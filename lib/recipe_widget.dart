import 'package:flutter/material.dart';
import 'package:pharmacy_app/server_wrapper.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RecipeWidget extends StatefulWidget{
  final recipeId;

  const RecipeWidget({Key key, this.recipeId}) : super(key: key);

  RecipeWidgetState createState() => RecipeWidgetState();
}

class RecipeWidgetState extends State<RecipeWidget>{
  static const TextStyle infoStyle = TextStyle(fontWeight: FontWeight.bold);
  Map<String, dynamic> data;
  var mainWidget = 0;
  List<Widget> recipeWidgets;

  @override
  void initState() {
    super.initState();
    recipeWidgets = [RecipeBody(recipeID: widget.recipeId[0], onTapFindGoods: () => setState(() => mainWidget = 1),),
                     ChooseRecipe(recipeID: widget.recipeId[0], onTapGoods: () => setState(() => mainWidget = 2)),
                     BuyGoods(recipeId: widget.recipeId[0],)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Рецепт " + widget.recipeId[1], style: TextStyle(fontSize: 16),),
          actions: <Widget>[Icon(Icons.share, color: Colors.black87)],
      ),
      body: recipeWidgets[mainWidget]
    );
  }
}

class RecipeBody extends StatefulWidget {
  final recipeID;
  final Function onTapFindGoods;

  const RecipeBody({Key key, this.recipeID, this.onTapFindGoods}) : super(key: key);

  _RecipeBodyState createState() => _RecipeBodyState();
}

class _RecipeBodyState extends State<RecipeBody>{
  static const TextStyle infoStyle = TextStyle(fontWeight: FontWeight.bold);
  Map<String, dynamic> data;
  List<Widget> goodWidgets = new List();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRecipeData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          return Container(
            color: Color.fromARGB(255, 228, 246, 243),
            padding: EdgeInsets.all(5),
            child: ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("Пациент:"),
                      Text(data['Patient'].toString())
                    ],
                  ),
                  alignment: Alignment.topRight,
                ),
                SizedBox(
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Лечебное учреждение:'),
                      Text(data['Hospital'].toString(), style: infoStyle,),
                      Text('Ваш врач:'),
                      Text(data['Doctor'].toString(), style: infoStyle,),
                      //Text('Наименование МНН:'),
                      //Text(data['Goods']["MNN"].toString(), style: infoStyle,),
                      //Text("Действующее вещество:"),
                      //Text(data['Goods']["Purpose"].toString(), style: infoStyle,),
                      Row(
                        children: <Widget>[
                          Text('Количество стандартов: '),
                          Text(data['Goods']["Count_standarts"].toString(), style: infoStyle,),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Дозировка: '),
                          Text(data['Goods']["Dose"].toString(), style: infoStyle,),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Форма выпуска: '),
                          Text(data['Goods']["Form_release"], style: infoStyle,),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Количество дней приёма препарата: '),
                          Text(data['Goods']["Count_days_use_drug"].toString(), style: infoStyle,),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Количество приёма в день: '),
                          Text(data['Goods']["Count_per_day"].toString(), style: infoStyle,),
                        ],
                      ),
                      Text('Описание приёма препарата врачем:'),
                      Text(data['Goods']["DescriptionFromDoctor"].toString(), style: infoStyle),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text('Создать график приёма препората'),
                    onPressed: () {},
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text('Найти препорат выгодно'),
                    onPressed: () async {
                      widget.onTapFindGoods();
                      setState(() {});
                    },
                    color: Colors.blue,
                  ),
                ),
                Divider(color: Colors.black,),
                Container(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 20,
                    itemBuilder: (context, index){
                      return MedicamentCard(
                        recipeId: widget.recipeID,
                        name: "Анальгин gfdssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssdgfdfgfdghfdgjfdjgfdhsssss",
                        pharmName: "Столичная аптека",
                        town: "г. Новокузнецк",
                        street: "пр. Курако, 1 (2.2 км)",
                        phone: "8-917-218-21-97",
                        time: "с 8:00 до 22:00",
                        price: "300",
                        cashback: "10",
                        goodsID: "",
                      );
                    },
                  ),
                ),
                Center(
                    child: Column(
                      children: <Widget>[
                        Text('Покажите этот QR код в аптеке при покупке по рецепту', textAlign: TextAlign.center,),
                        QrImage(
                          data: data["QRCode"].toString(),
                          version: QrVersions.auto,
                          size: 200.0,
                        )
                      ],
                    )
                ),
              ],
            ),
          );
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<void> getRecipeData() async {
    data = await ServerRecipe.getRecipeBody(widget.recipeID);
  }

}

class MedicamentCard extends StatefulWidget{

  final recipeId;
  final goodsID;
  final name;
  final pharmName;
  final town;
  final street;
  final phone;
  final time;
  final price;
  final cashback;

  const MedicamentCard({Key key, this.name, this.pharmName, this.town, this.street, this.phone, this.time, this.price,
    this.cashback, this.goodsID, this.recipeId}) : super(key: key);

  _MedicamentCardState createState() => _MedicamentCardState();
}

class _MedicamentCardState extends State<MedicamentCard>{
  bool handled = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(5),
        width: 330,
        height: 170,
        child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.name, style: TextStyle(fontSize: 16), maxLines: 2,),
                    Text(widget.pharmName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_city),
                        Text(widget.town)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on),
                        Text(widget.street)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.phone),
                        Text(widget.phone)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.access_time),
                        Text(widget.time)
                      ],
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.star, color: handled ? Colors.yellow : Colors.black),
                      Text("${widget.price} ₽")
                    ],
                  ),
                  Text('Кэшбэк до ${widget.cashback} ₽', style: TextStyle(fontSize: 10),),
                  Expanded(
                    child: Container(
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 2),
                    child: FlatButton(
                      color: Colors.lightGreenAccent,
                      onPressed: () => handlePharmacy(context),
                      child: Text('Отложить'),
                    ),
                  )
                ],
              )
            ]
        ),
      ),
    );
  }

  void handlePharmacy(BuildContext context) async {
    await ServerRecipe.handlePharmacies(widget.recipeId);
    handled = !handled;
    setState(() {});
    Scaffold.of(context).showSnackBar(SnackBar(
      content: handled ? Text("Рецепт успешно добавлен в корзину") : Text("Рецепт убран из корзины"),
    ));
  }
}

class ChooseRecipe extends StatefulWidget{
  final recipeID;
  final Function onTapGoods;

  const ChooseRecipe({Key key, this.recipeID, this.onTapGoods}) : super(key: key);

  _ChooseRecipeState createState() => _ChooseRecipeState();
}

class _ChooseRecipeState extends State<ChooseRecipe>{
  List<dynamic> data;
  List<Widget> goods = new List<Widget>();
  String city = "Неизвестно";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getGoodsData(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          return Container(
            color: Color.fromARGB(255, 228, 246, 243),
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("Поиск выгодной покупки", style: TextStyle(fontSize: 16),),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text("Ваш город: $city   "),
                    SizedBox(
                      height: 25,
                      child: FlatButton(
                        color: Colors.grey,
                        child: Text("Изменить"),
                        onPressed: (){},
                      ),
                    )
                  ],
                ),
                Divider(),
                Expanded(
                    child: ListView.builder(
                      itemCount: goods.length,
                      itemBuilder: (context, pos){
                        return goods[pos];
                      }
                    )
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
    );
  }
  Future<void> getGoodsData() async {
    goods.clear();
    data = await ServerRecipe.getGoodsList(widget.recipeID);
    city = await SharedPreferencesWrap.getCurrentCity();
    for (int i = 0; i < data.length; i++){
      goods.add(PharmacyCard(
        goodsID: data[i]["GoodsID"].toString(),
        title: data[i]["GoodsName"].toString(),
        description: data[i]['Description'].toString(),
        minPrice: data[i]['MinPrice'].toString(),
        maxPrice: data[i]['MaxPrice'].toString(),
        recipeID: widget.recipeID,
        onTap: widget.onTapGoods,
      ));
    }
    print(goods.length);
  }
}

class PharmacyCard extends StatelessWidget{
  final recipeID;
  final goodsID;
  final minPrice;
  final maxPrice;
  final title;
  final description;
  final Function onTap;

  const PharmacyCard({Key key, this.minPrice, this.maxPrice, this.title, this.description, this.goodsID, this.recipeID, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await ServerRecipe.handleGoods(recipeID, goodsID);
        print("Tap card");
        onTap();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 16),),
              Container(child: Text('Описание:'), margin: EdgeInsets.symmetric(vertical: 4),),
              Text(description),
              SizedBox(height: 6,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Минимальная цена:"),
                      Text(minPrice, style: TextStyle(fontSize: 26),)
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text('Максимальная цена:'),
                      Text(maxPrice, style: TextStyle(fontSize: 26))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}

class BuyGoods extends StatefulWidget{
  final Function onTapPharm;
  final recipeId;

  const BuyGoods({Key key, this.onTapPharm, this.recipeId}) : super(key: key);

  _BuyGoodsState createState() => _BuyGoodsState();
}

class _BuyGoodsState extends State<BuyGoods>{
  List<Widget> widgets = List<Widget>();

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Выбор аптеки", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                ),
                Expanded(
                  child: ListView(
                    children: widgets,
                  ),
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
    );
  }

  Future<void> getData() async {
    widgets.clear();
    var data = await ServerRecipe.getPharmacies(widget.recipeId);
    for (int i = 0; i < data.length; i++){
      widgets.add(MedicamentCard(
        recipeId: widget.recipeId,
        goodsID: data[i]["Goods009ID"].toString(),
        name: data[i]["Goods009Name"].toString(),
        pharmName: data[i]["Apteka"]["Name"].toString(),
        town: data[i]["Apteka"]["Town"].toString(),
        street: data[i]["Apteka"]["Address"].toString(),
        phone: data[i]["Apteka"]["Phone"].toString(),
        time: data[i]["Apteka"]["Schedule"].toString(),
        price: data[i]["Price"].toString(),
        cashback: "10",
      ));
    }

  }

}
