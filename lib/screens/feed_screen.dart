import 'package:divoc/common/cards.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/components/feed/create_feed.dart';
import 'package:divoc/components/feed/feed_details.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  static const title = "Flöde";

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
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            body: Container(
              child: RefreshIndicator(
                onRefresh: () => Future.delayed(Duration(seconds: 2)),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Feed feed = snapshot.data[index];
                    return FeedListTileCard(
                      image: feed.image,
                      name: feed.name,
                      status: feed.status,
                      city: feed.city,
                      state: feed.state,
                      created: feed.created,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedDetails(feed: feed),
                          ),
                        );
                      },
                    );
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
