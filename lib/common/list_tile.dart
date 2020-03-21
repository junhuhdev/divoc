import 'package:divoc/models/feed.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedListTileColumn extends StatelessWidget {
  final Feed feed;

  const FeedListTileColumn({this.feed});

  @override
  Widget build(BuildContext context) {
    final formatter = new DateFormat('EEE d MMM h:mm a');

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.person, size: 18.0),
            SizedBox(width: 8.0),
            Text(feed.name + ", "),
          ],
        ),
        Row(
          children: <Widget>[
            if (feed.gender != null && feed.age != null) ...[
              Icon(Icons.person, size: 18.0),
              SizedBox(width: 8.0),
              Text(toBeginningOfSentenceCase(feed.gender.toLowerCase()) + ", "),
              Text("${feed.age}"),
            ],
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (feed.city.isNotEmpty && feed.state.isNotEmpty) ...[
              Icon(Icons.place, size: 18.0),
              SizedBox(width: 8.0),
              Text(feed.state + ", "),
              Text(feed.city),
            ],
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.calendar_today, size: 18.0),
            SizedBox(width: 8.0),
            Text(formatter.format(feed.created))
          ],
        ),
        if (feed.category != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.category, size: 18.0),
              SizedBox(width: 8.0),
              Text(feed.category),
            ],
          ),
        ],
      ],
    );
  }
}
