import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/server_wrapper.dart';

class RecipeCard extends StatelessWidget{
  final String id;
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

  const RecipeCard({Key key, this.recipeName, this.tradeName, this.mnn, this.dosage, this.form, this.standartCount, this.duration, this.tabletsPerDay, this.source, this.personName, this.date, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 10, color: Colors.black);

    return GestureDetector(
      onTap: () async {
        Map<String, String> data = {'name': recipeName, 'doctor': 'Айболит Иван Петрович', 'mnn': tradeName, 'activeSuspens': mnn, 'standartCount': standartCount,
        'dosage': dosage, 'form': form, 'duration': duration, 'tabletsPerDay': tabletsPerDay, 'description': "по 5 мг рвд на 30 дней", 'personName': personName,
        'hospital': 'Новокузнецкая клиническая больница №1'};
        Navigator.of(context).pushNamed("/RecipeWidget", arguments: data);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey),
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
                           ColoredIcon(
                             icon: Icons.shopping_cart,
                             color: Colors.black,
                             activeColor: Colors.red[800],
                           ),
                           ColoredIcon(
                             icon: Icons.star,
                             color: Colors.black,
                             activeColor: Colors.yellow,
                           )
                         ],
                       ),
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 4, bottom: 2),
                     child: Column(
                       children: <Widget>[
                         Align(alignment: Alignment.centerRight, child: Text("Пациент", style: TextStyle(fontSize: 10, color: Colors.black45))),
                         Align(alignment: Alignment.centerRight, child: Text(personName, style: textStyle)),
                         Align(alignment: Alignment.centerRight, child: Text('Дата: $date', style: TextStyle(fontSize: 10, color: Colors.black45)))
                       ],
                     ),
                   )
                 ],
               ),
             )
          ],
        ),
      ),
    );
  }

  void buttonDebug(){
    print ("button tapped");
  }

}

class ColoredIcon extends StatefulWidget{
  final IconData icon;
  final Color activeColor;
  final Color color;

  const ColoredIcon({Key key, this.icon, this.activeColor, this.color}) : super(key: key);

  @override
  ColorIconState createState(){
    return ColorIconState();
  }
}

class ColorIconState extends State<ColoredIcon>{
  IconData icon;
  Color color;
  bool isActive = false;

  @override initState(){
    super.initState();
    color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: changeIconColor,
      child: Icon(widget.icon, color: color),
    );
  }

  changeIconColor(){
    setState(() {
      isActive = !isActive;
      color = isActive == true ? widget.activeColor : widget.color;
    });
  }
}