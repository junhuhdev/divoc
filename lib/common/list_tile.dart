import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedListTileColumn extends StatelessWidget {
  final String name;
  final DateTime created;
  final String category;

  const FeedListTileColumn({Key key, this.name, this.created, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = new DateFormat('EEE d MMM h:mm a');

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.person, size: 18.0),
            SizedBox(width: 8.0),
            Text(name + ", "),
            Text("Male, "),
            Text("70 y"),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.place, size: 18.0),
            SizedBox(width: 8.0),
            Text("Kista, "),
            Text("Stockholm"),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.calendar_today, size: 18.0),
            SizedBox(width: 8.0),
            Text(formatter.format(created))
          ],
        ),
        if (category != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.category, size: 18.0),
              SizedBox(width: 8.0),
              Text(category),
            ],
          ),
        ],
      ],
    );
  }
}
