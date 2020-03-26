import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/material.dart';

class TabletsMain extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("У вас нет ни одного курса.\nКак только у вас будет рецепт,\nВы сможете создать курс приёма лекарств", textAlign: TextAlign.center,),
      ),
    );
  }

}

class TabletsWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: CalendarStrip(
        startDate: DateTime.parse("20200201"),
        endDate: DateTime.parse("20200330"),
        selectedDate: DateTime.now(),
        onDateSelected: onSelect,
      ),
    );
  }

  void onSelect(DateTime dateTime){
    print(dateTime);
  }

}