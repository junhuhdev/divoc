import 'package:divoc/common/loader.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/services/feed_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    return ActivityCard(
                      feed: snapshot.data[index],
                    );
                  },
                  itemCount: snapshot.data.length,
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

  const ActivityCard({this.feed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(feed.name),
              ],
            ),
            Column(
              children: <Widget>[
                if (feed.status == 'created') ...[
                  Chip(
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                    label: Text(feed.status),
                  ),
                ],
                if (feed.status == 'pending') ...[
                  Chip(
                    backgroundColor: Colors.amber,
                    labelStyle: TextStyle(color: Colors.white),
                    label: Text(feed.status),
                  ),
                ],
                Chip(
                  labelPadding: EdgeInsets.symmetric(horizontal: 6.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  label: Text(feed.category),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
