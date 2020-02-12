import 'package:flutter/material.dart';
import 'package:pharmacy_app/news_widget.dart';

class NewsCard extends StatelessWidget{
  final String titleText;
  final String bodyText;
  final String botSource;
  final String date;

  const NewsCard({Key key, this.titleText, this.bodyText, this.botSource, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.fromARGB(255, 195, 243, 208), Color.fromARGB(255, 73, 201, 224)]
            )
        ),
        height: 100.0,
        child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      Scaffold(
                        appBar: AppBar(title: Text('Главная - Новости')),
                        body: NewsWidget(
                          titleText: 'Мишустин назначил Александра Грибова замглавы аппарата правительства РФ',
                          bodyText: """Советский и российский актёр театра и кино Андрей Ургант прокомментировал журналистам скандал, развернувшийся вокруг его сына, известного телеведущего Ивана Урганта. Ранее СМИ сообщали, что православные активисты собирают подписи под требованием лишить телеведущего российского гражданства из-за недавнего эфира, в котором они усмотрели признаки оскорбления веруюших. Кроме этого православные активисты пожелали Ивану Урганту "заболеть раком".

Андрей Ургант отметил, что ничего не знает об этой ситуации.

"Мне совершенно все равно, что думают активисты, и поэтому я к этому никак не отношусь", - передает издание "Собеседник" слова актера.

Андрей Ургант добавил, что если эти люди правомочны лишать актера гражданства за его выступление, тогда вообще непонятно что происходит в стране.

"Кстати, несколько лет назад подобные организации в Украине предлагали тому, кто отрежет голову Ивану, десять тысяч долларов", - также рассказал актер телеведущего.

Речь тогда шла о высказывании Ивана Урганта в программе "Смак". Он неудачно пошутил, что порубил зелень, как "красный комиссар жителей украинской деревни".

Андрей Ургант также не исключил, что завтра еще кто-то что-то предложит. Советский и российский актёр театра и кино Андрей Ургант прокомментировал журналистам скандал, развернувшийся вокруг его сына, известного телеведущего Ивана Урганта. Ранее СМИ сообщали, что православные активисты собирают подписи под требованием лишить телеведущего российского гражданства из-за недавнего эфира, в котором они усмотрели признаки оскорбления веруюших. Кроме этого православные активисты пожелали Ивану Урганту "заболеть раком".

Андрей Ургант отметил, что ничего не знает об этой ситуации.

"Мне совершенно все равно, что думают активисты, и поэтому я к этому никак не отношусь", - передает издание "Собеседник" слова актера.

Андрей Ургант добавил, что если эти люди правомочны лишать актера гражданства за его выступление, тогда вообще непонятно что происходит в стране.

"Кстати, несколько лет назад подобные организации в Украине предлагали тому, кто отрежет голову Ивану, десять тысяч долларов", - также рассказал актер телеведущего.

Речь тогда шла о высказывании Ивана Урганта в программе "Смак". Он неудачно пошутил, что порубил зелень, как "красный комиссар жителей украинской деревни".

Андрей Ургант также не исключил, что завтра еще кто-то что-то предложит.""",
                          date: '15 января 2020 в 19:45',
                          source: 'Источник: Правительство РФ ',
                          url: 'https://google.com',
                        ),
                      )
              )
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment(-1.0, -1.0),
                child: Text(
                  titleText,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                ),
                padding: EdgeInsets.fromLTRB(4, 4, 0, 0),
                height: 30,
              ),
              Expanded(
                child: Container(
                    child: Text(
                      bodyText,
                      maxLines: 2,
                      style: TextStyle(fontSize: 11),
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(4)
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        botSource,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                        date,
                        style: TextStyle(fontSize: 11)
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}