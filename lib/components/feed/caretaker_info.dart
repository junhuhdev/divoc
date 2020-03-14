import 'package:flutter/material.dart';

class CaretakerInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Description', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)),
            SizedBox(height: 10.0),
            Text(
              'Hej allesammans! Min mormor och morfar bor i ett hus i skogen i haninge. De skulle behöva få hjälp med att handla på apoteket. Jag själv bor på andra sidan stan och har ingen bil tyvärr. Finns det någon i haninge (Vega) som skulle vilja handla åt dem idag? Skicka ett PM till mig isåfall',
            )
          ],
        ),
      ),
    );
  }
}
