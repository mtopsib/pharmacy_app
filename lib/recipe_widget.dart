import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecipeWidget extends StatelessWidget{
  final Map<String, String> data;
  static const TextStyle infoStyle = TextStyle(fontWeight: FontWeight.bold);

  const RecipeWidget({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Рецепт " + data['name'], style: TextStyle(fontSize: 16),),
          actions: <Widget>[Icon(Icons.share, color: Colors.black87)],
      ),
      body: Container(
        color: Color.fromARGB(255, 228, 246, 243),
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Пациент:"),
                        Text(data['personName'])
                      ],
                    ),
                    alignment: Alignment.topRight,
                  ),
                  Text('Лечебное учреждение:'),
                  Text(data['hospital'], style: infoStyle,),
                  Text('Ваш врач:'),
                  Text(data['doctor'], style: infoStyle,),
                  Text('Наименование МНН:'),
                  Text(data['mnn'], style: infoStyle,),
                  Text("Действующее вещество:"),
                  Text(data['activeSuspens'], style: infoStyle,),
                  Row(
                    children: <Widget>[
                      Text('Количество стандартов: '),
                      Text(data['standartCount'], style: infoStyle,),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Дозировка: '),
                      Text(data['dosage'], style: infoStyle,),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Форма выпуска: '),
                      Text(data['form'], style: infoStyle,),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Количество дней приёма препарата: '),
                      Text(data['duration'], style: infoStyle,),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Количество приёма в день: '),
                      Text(data['tabletsPerDay'], style: infoStyle,),
                    ],
                  ),
                  Text('Описание приёма препарата врачем:'),
                  Text(data['description'], style: infoStyle),
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
                ],
              ),
            ),
            // TODO: Исправить
            Expanded(
              flex: 2,
              child: ListView(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: 20,
                      itemBuilder: (context, index){
                        return MedicamentCard();
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: <Widget>[
                              Text('Покажите этот QR код в аптеке при покупке по рецепту', textAlign: TextAlign.center,),
                              Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey,
                              )
                            ],
                          )
                        ),

                      ],
                    ),
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
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