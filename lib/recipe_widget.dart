import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmacy_app/server_wrapper.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RecipeWidget extends StatefulWidget{
  final recipeId;

  const RecipeWidget({Key key, this.recipeId}) : super(key: key);

  RecipeWidgetState createState() => RecipeWidgetState();
}

class RecipeWidgetState extends State<RecipeWidget>{
  static const TextStyle infoStyle = TextStyle(fontWeight: FontWeight.bold);
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Рецепт " + widget.recipeId[1], style: TextStyle(fontSize: 16),),
          actions: <Widget>[Icon(Icons.share, color: Colors.black87)],
      ),
      body: FutureBuilder(
        future: getRecipeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            return Container(
              color: Color.fromARGB(255, 228, 246, 243),
              padding: EdgeInsets.all(5),
              child: ListView(
                //physics: BouncingScrollPhysics(),
                //crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text('Лечебное учреждение:'),
                  Text(data['Hospital'].toString(), style: infoStyle,),
                  Text('Ваш врач:'),
                  Text(data['Doctor'].toString(), style: infoStyle,),
                  Text('Наименование МНН:'),
                  Text(data['Goods']["MNN"].toString(), style: infoStyle,),
                  Text("Действующее вещество:"),
                  Text(data['Goods']["Purpose"].toString(), style: infoStyle,),
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
                  Container(
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: Text('Создать график приёма препората'),
                      onPressed: () {},
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: Text('Найти препорат выгодно'),
                      onPressed: () {},
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
      ),
    );
  }

  Future<void> getRecipeData() async {
    data = await ServerRecipe.getRecipeBody(widget.recipeId[0]);
    print(data);
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