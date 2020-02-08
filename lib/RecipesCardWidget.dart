import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget{
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

  const RecipeCard({Key key, this.recipeName, this.tradeName, this.mnn, this.dosage, this.form, this.standartCount, this.duration, this.tabletsPerDay, this.source, this.personName, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 10, color: Colors.black);

    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.lightBlue[50],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 152, 236, 255), Color.fromARGB(255, 25, 155, 242)]
          )
      ),
      height: 110,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(3),
              child: Column(
                children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text("Рецепт $recipeName", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.start), heightFactor: 1.2, ),
                  Align(alignment: Alignment.centerLeft, child: RichText(text: TextSpan(style: textStyle, children: <TextSpan>[ TextSpan(text: "Торговое наименование: "), TextSpan(text: tradeName, style: TextStyle(fontWeight: FontWeight.bold))]))),
                  Align(alignment: Alignment.centerLeft, child: RichText(text: TextSpan(style: textStyle, children: <TextSpan>[ TextSpan(text: "МНН: "), TextSpan(text: mnn, style: TextStyle(fontWeight: FontWeight.bold))]))),
                  Align(alignment: Alignment.centerLeft, child: RichText(text: TextSpan(style: textStyle, children: <TextSpan>[ TextSpan(text: "Дозировка: "), TextSpan(text: dosage, style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "  Форма выпуска: "), TextSpan(text: form, style: TextStyle(fontWeight: FontWeight.bold))]))),
                  Align(alignment: Alignment.centerLeft, child: RichText(text: TextSpan(style: textStyle, children: <TextSpan>[ TextSpan(text: "Количество стандартов: "), TextSpan(text: standartCount, style: TextStyle(fontWeight: FontWeight.bold))]))),
                  Align(alignment: Alignment.centerLeft, child: RichText(text: TextSpan(style: textStyle, children: <TextSpan>[ TextSpan(text: "Количество дней приёма препарата: "), TextSpan(text: duration, style: TextStyle(fontWeight: FontWeight.bold))]))),
                  Align(alignment: Alignment.centerLeft, child: RichText(text: TextSpan(style: textStyle, children: <TextSpan>[ TextSpan(text: "Количество приёмав день: "), TextSpan(text: tabletsPerDay, style: TextStyle(fontWeight: FontWeight.bold))]))),
                  Align(alignment: Alignment.centerLeft, child: Text(source, style: TextStyle(fontSize: 10, color: Colors.black45)))
                ],
              ),
            )
          ),
           Expanded(
             child: Column(
               children: <Widget>[
                 Expanded(
                   child: Container(
                     padding: EdgeInsets.all(5),
                     alignment: Alignment.topRight,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: <Widget>[
                         Icon(Icons.shopping_cart),
                         Icon(Icons.star)
                       ],
                     ),
                   ),
                 ),
                 Align(alignment: Alignment.centerRight, child: Text("Пациент", style: TextStyle(fontSize: 10, color: Colors.black45))),
                 Align(alignment: Alignment.centerRight, child: Text(personName, style: textStyle)),
                 Align(alignment: Alignment.centerRight, child: Text('Дата: $date', style: TextStyle(fontSize: 10, color: Colors.black45)))
               ],
             ),
           )
        ],
      ),
    );
  }

  void buttonDebug(){
    print ("button tapped");
  }

}

class MyIconButton extends GestureDetector{

}