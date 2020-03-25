import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/components/feed/feed_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class FeedListTileCard extends StatelessWidget {
  final String image;
  final String name;
  final String status;
  final String city;
  final String state;
  final DateTime created;
  final VoidCallback onTap;

  const FeedListTileCard({
    this.image,
    this.name,
    this.status,
    this.city,
    this.state,
    this.created,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattertime = new DateFormat('EEE d MMM h:mm a');
    final formatter = new DateFormat('EEE d MMM');

    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: kCardColor),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: CircleAvatar(
              backgroundImage: image == null ? Icon(Icons.person) : CachedNetworkImageProvider(image),
              radius: 30.0,
            ),
          ),
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    // tag: 'hero',
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: getProgressStatus(status),
                        valueColor: AlwaysStoppedAnimation(getColorStatus(status))),
                  )),
            ],
          ),
          isThreeLine: true,
          subtitle: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.spaceBetween,
            children: <Widget>[
              Text("$state, $city", style: TextStyle(color: Colors.white, fontSize: 12.0)),
              SizedBox(height: 3),
              Text(formattertime.format(created), style: TextStyle(color: Colors.white70, fontSize: 12.0))
            ],
          ),
          onTap: () => onTap(),
        ),
      ),
    );
  }
}