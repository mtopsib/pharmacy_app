import 'package:flutter/material.dart';
import 'package:pharmacy_app/server_wrapper.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';

class ChooseRecipe extends StatefulWidget{
  final List<String> recipeData;

  const ChooseRecipe(this.recipeData, {Key key,}) : super(key: key);

  _ChooseRecipeState createState() => _ChooseRecipeState();
}

class _ChooseRecipeState extends State<ChooseRecipe>{
  List<dynamic> data;
  List<Widget> goods = new List<Widget>();
  String city = "Неизвестно";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Рецепт " + widget.recipeData[1], style: TextStyle(fontSize: 16))),
      body: FutureBuilder(
        future: getGoodsData(context),
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
                      child: Text("Выберите препарат", style: TextStyle(fontSize: 16),),
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
                          onPressed: () => changeTown(context),
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
      ),
    );
  }

  void changeTown(BuildContext context) async {
    var townsData = await ServerRecipe.getRecipeTowns();
    List<Widget> townButtons = List();
    for (int i = 0; i < townsData.length; i++){
      townButtons.add(
        FlatButton(
          onPressed: ()  {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/ChooseRecipe", arguments: [widget.recipeData[0], widget.recipeData[1], townsData[i]["ID"].toString(), townsData[i]["Town"].toString()]);
          },
          child: Text(townsData[i]["Town"].toString()),
        )
      );
    }
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Выберите город"),
            children: townButtons
          );
        }
    );
  }

  Future<void> getGoodsData(BuildContext context) async {
    goods.clear();
    var geoInfo = await SharedPreferencesWrap.getCurrentCity();
    if (widget.recipeData.length == 2){
      data = await ServerRecipe.getGoodsList(widget.recipeData[0]);
      city = geoInfo[0] ?? "Неизвестно";
    } else {
      data = await ServerRecipe.getGoodsList(widget.recipeData[0], town: widget.recipeData[2]);
      city = widget.recipeData[3];
    }
    for (int i = 0; i < data.length; i++){
      goods.add(PharmacyCard(
          goodsID: data[i]["GoodsID"].toString(),
          title: data[i]["GoodsName"].toString(),
          description: data[i]['Description'].toString(),
          minPrice: data[i]['MinPrice'].toString(),
          maxPrice: data[i]['MaxPrice'].toString(),
          recipeID: widget.recipeData[0],
          onTap: () => Navigator.of(context).pushReplacementNamed('/BuyGoods', arguments: [widget.recipeData[0], widget.recipeData[1]])
      ));
    }
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
        elevation: 7,
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