import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/components/feed/create_feed.dart';
import 'package:divoc/components/feed/feed_details.dart';
import 'package:divoc/data/feed_list.dart';
import 'package:divoc/models/feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  static const title = "Feed";

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RefreshIndicator(
          onRefresh: () => Future.delayed(Duration(seconds: 2)),
          child: ListView(
            children: <Widget>[for (var feed in feeds) FeedListTile(feed: feed)],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateFeed(),
            ),
          );
        },
      ),
    );
  }
}

class FeedListTile extends StatelessWidget {
  final Feed feed;

  const FeedListTile({this.feed});

  @override
  Widget build(BuildContext context) {
    final formatter = new DateFormat('EEE d MMM h:mm a');
    return Card(
      elevation: 3.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(feed.image),
          radius: 30.0,
        ),
        contentPadding: EdgeInsets.all(8.0),
        title: Text(feed.name),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.person, size: 18.0),
                SizedBox(width: 8.0),
                Text(feed.gender + ", "),
                Text(feed.age.toString()),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.place, size: 18.0),
                SizedBox(width: 8.0),
                Text(feed.city + ", "),
                Text(feed.state),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.calendar_today, size: 18.0),
                SizedBox(width: 8.0),
                Text(formatter.format(feed.created))
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.local_hospital, size: 18.0),
                SizedBox(width: 8.0),
                Transform(
                  transform: new Matrix4.identity()..scale(0.8),
                  child: Chip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Text(feed.category),
                  ),
                ),
              ],
            )
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedDetails(feed: feed),
            ),
          );
        },
      ),
    );
  }
}
