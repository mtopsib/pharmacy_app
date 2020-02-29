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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Рецепт " + widget.recipeId[1], style: TextStyle(fontSize: 16),),
          actions: <Widget>[Icon(Icons.share, color: Colors.black87)],
      ),
      body: mainWidget == 0 ? FutureBuilder(
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
                        mainWidget = 1;
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
                        return MedicamentCard();
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
      ) :
          ChooseRecipe(recipeID: widget.recipeId[0],)
    );
  }

  Future<void> getRecipeData() async {
    data = await ServerRecipe.getRecipeBody(widget.recipeId[0]);
  }

}

class MedicamentCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(2),
        width: 270,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Анальгин", style: TextStyle(fontSize: 16)),
                Text("Столичная аптека", style: TextStyle(fontSize: 16)),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_city),
                    Text('г. Новокузнецк')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on),
                    Text('пр. Курако, 1 (2,2 км)')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.phone),
                    Text('8(3843) 20-07-23')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.access_time),
                    Text('с 8:00 до 22:00')
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.star),
                    Text("300 Р")
                  ],
                ),
                Text('Кэшбэк до 10р', style: TextStyle(fontSize: 10),),
                Expanded(
                  child: Container(
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 2),
                  child: FlatButton(
                    color: Colors.lightGreenAccent,
                    onPressed: () {},
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

}

class ChooseRecipe extends StatefulWidget{
  final recipeID;

  const ChooseRecipe({Key key, this.recipeID}) : super(key: key);

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
      ));
    }
    print(goods.length);
  }
}

class PharmacyCard extends StatelessWidget{
  final goodsID;
  final minPrice;
  final maxPrice;
  final title;
  final description;

  const PharmacyCard({Key key, this.minPrice, this.maxPrice, this.title, this.description, this.goodsID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }

}

