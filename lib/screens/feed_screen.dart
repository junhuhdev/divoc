import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/data/feed_list.dart';
import 'package:divoc/models/feed.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Widget buildListTile(Feed feed) {
    return Card(
      elevation: 3.0,
      child: ListTile(
//        isThreeLine: true,
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(feed.image),
          radius: 30.0,
        ),
        contentPadding: EdgeInsets.all(8.0),
//        dense: true,
        title: Text(feed.name),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(feed.gender + ", "),
                Text(feed.age.toString()),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(feed.city + ", "),
                Text(feed.state),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: Text(feed.severity.toString()),
                  ),
                  label: Text(feed.type),
                ),
              ],
            )
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[for (var feed in feeds) buildListTile(feed)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
