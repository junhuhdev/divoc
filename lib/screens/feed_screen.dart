import 'package:divoc/common/cards.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/components/feed/create_feed.dart';
import 'package:divoc/components/feed/feed_details.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/feed_service.dart';
import 'package:divoc/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  static const title = "Väntar på hjälp";

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Stream<List<Feed>> _feeds;
  FeedService feedService = FeedService();

  @override
  void initState() {
    super.initState();
    _feeds = feedService.streamFeeds();
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
            backgroundColor: kBackgroundColor,
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
            floatingActionButton: Consumer<User>(
              builder: (context, user, child) {
                if (user == null) {
                  return LoadingScreen();
                } else {
                  bool isHelper = user.isHelper;
                  if (isHelper) {
                    return Container();
                  } else {
                    return FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.add, color: Colors.blueGrey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateFeed(),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          );
        }
      },
    );
  }
}
