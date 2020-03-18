import 'package:divoc/common/loader.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/services/feed_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DeliveryScreen extends StatefulWidget {
  static const title = "Delivery";

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final FeedService feedService = new FeedService();

  @override
  Widget build(BuildContext context) {
    FirebaseUser currentUser = Provider.of<FirebaseUser>(context);
    if (currentUser != null) {
      return StreamBuilder(
        stream: feedService.streamUserFeeds(currentUser.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
            }
            return LoadingScreen();
          } else {
            return Scaffold(
              body: Container(
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ActivityCard(
                      feed: snapshot.data[index],
                    );
                  },
                ),
              ),
            );
          }
        },
      );
    } else {
      return Container();
    }
  }
}

class ActivityCard extends StatelessWidget {
  final Feed feed;

  ActivityCard({this.feed});

  final formatter = new DateFormat('EEE d MMM h:mm a');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.person, size: 18.0),
                      SizedBox(width: 8.0),
                      Text(feed.name),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      Icon(Icons.place, size: 18.0),
                      SizedBox(width: 8.0),
                      Text("Kista, "),
                      Text("Stockholm"),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today, size: 18.0),
                      SizedBox(width: 8.0),
                      Text(formatter.format(feed.created))
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[Icon(Icons.category, size: 18.0), SizedBox(width: 8.0), Text(feed.category)],
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  if (feed.status == 'created') ...[
                    Chip(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      backgroundColor: Colors.red,
                      labelStyle: TextStyle(color: Colors.white),
                      label: Text(feed.status),
                    ),
                  ],
                  if (feed.status == 'pending') ...[
                    Chip(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      backgroundColor: Colors.amber,
                      labelStyle: TextStyle(color: Colors.white),
                      label: Text(feed.status),
                    ),
                  ],
                  if (feed.status == 'completed') ...[
                    Chip(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      backgroundColor: Colors.green,
                      labelStyle: TextStyle(color: Colors.white),
                      label: Text(feed.status),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
