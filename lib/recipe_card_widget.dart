import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/server_wrapper.dart';

class RecipeCard extends StatelessWidget{
  final String id;
  final String recipeName;
  final String goods;
  final String hospital;
  final String personName;
  final String date;
  final bool notRead;

  const RecipeCard({Key key, this.recipeName, this.personName, this.date, this.id, this.goods, this.hospital, this.notRead}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 10, color: Colors.black);

    return GestureDetector(
      onTap: () async {
        await ServerRecipe.readRecipe(id);
        Navigator.of(context).pushNamed("/RecipeWidget", arguments: [id, recipeName]);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Рецепт $recipeName", style: TextStyle(fontWeight: FontWeight.bold),),
                    Text("Препарат: $goods"),
                    Text("Источник: $hospital", style: TextStyle(fontSize: 10, color: Colors.black45),)
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
                           /*ColoredIcon(
                             icon: Icons.shopping_cart,
                             color: Colors.black,
                             activeColor: Colors.red[800],
                           ),*/
                           notRead ? Icon(
                             Icons.brightness_1,
                             color: Colors.red,
                             size: 10,
                           ) : SizedBox()
                         ],
                       ),
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 4, bottom: 2),
                     child: Column(
                       children: <Widget>[
                         Align(alignment: Alignment.centerRight, child: Text("Пациент", style: TextStyle(fontSize: 10, color: Colors.black45))),
                         Align(alignment: Alignment.centerRight, child: Text(personName, style: textStyle, textAlign: TextAlign.right,)),
                         Align(alignment: Alignment.centerRight, child: Text('Дата: ${date.substring(0, 10)}', style: TextStyle(fontSize: 10, color: Colors.black45)))
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

/*class ColoredIcon extends StatefulWidget{
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
}*/