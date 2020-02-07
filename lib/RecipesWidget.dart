import 'package:flutter/material.dart';

class RecipeWidget extends StatelessWidget{
  final String recipeName;
  final String tradeName;
  final String mnn;
  final String dosage;
  final String form;
  final String standartCount;
  final String duration;
  final String tabletsPerDay;
  final String source;
  final String personName;
  final String date;

  const RecipeWidget({Key key, this.recipeName, this.tradeName, this.mnn, this.dosage, this.form, this.standartCount, this.duration, this.tabletsPerDay, this.source, this.personName, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Text("Рецепт $recipeName"),
                Text("Торговое наименование $tradeName"),
                Text("МНН $mnn"),
                Text("Дозировка $dosage"),
                Text("Количество стандартов $standartCount"),
                Text("Количество дней приёма препарата $duration"),
                Text("Количество приёма в день $tabletsPerDay"),
                Text(source)
              ],
            ),
          ),
           Expanded(
             flex: 1,
             child: Column(
               children: <Widget>[
                 Expanded(
                   child: Container(
                     child: Row(
                       children: <Widget>[
                         Icon(Icons.shopping_cart),
                         Icon(Icons.star,
                         color: Colors.yellow)
                       ],
                     ),
                   ),
                 ),
                 Text("Пациент"),
                 Text(personName),
                 Text(date)
               ],
             ),
           )
        ],
      ),
    );
  }

}