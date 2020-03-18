import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/common/list_tile.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/components/feed/create_feed.dart';
import 'package:divoc/components/feed/feed_details.dart';
import 'package:divoc/data/feed_list.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/services/globals.dart';
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
  Stream<List<Feed>> _feeds;

  @override
  void initState() {
    super.initState();
    _feeds = Global.feedCollection.streamData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _feeds,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
          }
          return LoadingScreen();
        } else {
          return Scaffold(
            body: Container(
              child: RefreshIndicator(
                onRefresh: () => Future.delayed(Duration(seconds: 2)),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return FeedListTile(feed: snapshot.data[index]);
                  },
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
      },
    );
  }
}

class FeedListTile extends StatelessWidget {
  final Feed feed;

  const FeedListTile({this.feed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: ListTile(
        contentPadding: EdgeInsets.all(15.0),
        leading: CircleAvatar(
          backgroundImage: feed.image == null ? Icon(Icons.person) : CachedNetworkImageProvider(feed.image),
          radius: 30.0,
        ),
        subtitle: FeedListTileColumn(name: feed.name, created: feed.created, category: feed.category),
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
