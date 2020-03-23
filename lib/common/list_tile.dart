import 'package:divoc/common/chips.dart';
import 'package:divoc/models/feed.dart';
import 'package:flutter/cupertino.dart';
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
            Icon(Icons.person, size: 18.0, color: Colors.white),
            SizedBox(width: 8.0),
            Text(feed.name, style: TextStyle(color: Colors.white)),
          ],
        ),
        if (feed.gender != null && feed.age != null) ...[
          SizedBox(height: 5.0),
          Row(
            children: <Widget>[
              Icon(Icons.info_outline, size: 18.0),
              SizedBox(width: 8.0),
              Text(toBeginningOfSentenceCase(feed.gender.toLowerCase()) + ", "),
              Text("${feed.age}"),
            ],
          ),
        ],
        if (feed.city != null && feed.state != null) ...[
          SizedBox(height: 5.0),
          Row(
            children: <Widget>[
              Flexible(child: Icon(Icons.place, size: 18.0)),
              SizedBox(width: 8.0),
              Flexible(fit: FlexFit.loose, flex: 2, child: Text(feed.state + ", ")),
              Flexible(fit: FlexFit.loose, flex: 2, child: Text(feed.city)),
            ],
          ),
        ],
        if (feed.category != null) ...[
          SizedBox(height: 5.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.category, size: 18.0),
              SizedBox(width: 8.0),
              Text(feed.category),
            ],
          ),
        ],
        SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            Icon(Icons.calendar_today, size: 18.0),
            SizedBox(width: 8.0),
            Text(formatter.format(feed.created), style: TextStyle(color: Colors.white))
          ],
        ),
      ],
    );
  }
}

class ActivityListTile extends StatelessWidget {
  final Feed feed;

  const ActivityListTile({this.feed});

  @override
  Widget build(BuildContext context) {
    final formatter = new DateFormat('EEE d MMM h:mm a');

    return Column(
      children: <Widget>[
        if (feed.city != null && feed.state != null) ...[
          SizedBox(height: 5.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.place, size: 18.0),
              SizedBox(width: 8.0),
              Text(feed.state + ", "),
              Text(feed.city),
            ],
          ),
        ],
        SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            Icon(Icons.calendar_today, size: 18.0),
            SizedBox(width: 8.0),
            Text(formatter.format(feed.created))
          ],
        ),
        if (feed.status != null) ...[
          SizedBox(height: 5.0),
          Row(
            children: <Widget>[
              Icon(Icons.trip_origin, size: 18.0),
              SizedBox(width: 8.0),
              FeedStatusBox(status: feed.status),
            ],
          )
        ],
      ],
    );
  }
}
