import 'package:divoc/models/feed.dart';
import 'package:flutter/material.dart';

class CaretakerInfo extends StatelessWidget {
  final Feed feed;

  const CaretakerInfo({this.feed});

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
              feed.description,
              softWrap: true,
            )
          ],
        ),
      ),
    );
  }
}
