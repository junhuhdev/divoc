import 'package:divoc/common/chips.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/services/feed_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatelessWidget {
  static const title = "Activity";

  final FeedService feedService = new FeedService();

  @override
  Widget build(BuildContext context) {
    FirebaseUser currentUser = Provider.of<FirebaseUser>(context);
    if (currentUser != null) {
      return StreamBuilder(
        stream: feedService.streamUserFeeds(currentUser.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("Error: ${snapshot.error}");
            return LoadingScreen();
          } else {
            return Scaffold(
              body: Container(
                child: ListView.builder(
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
      radius: 35.0,
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
                    FeedStatusChip(status: feed.status, backgroundColor: Colors.red),
                  ],
                  if (feed.status == 'pending') ...[
                    FeedStatusChip(status: feed.status, backgroundColor: Colors.amber),
                  ],
                  if (feed.status == 'completed') ...[
                    FeedStatusChip(status: feed.status, backgroundColor: Colors.green),
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
