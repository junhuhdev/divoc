import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/common/chips.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/list_tile.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/components/feed/create_feed.dart';
import 'package:divoc/components/feed/feed_details.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              backgroundImage: feed.image == null ? Icon(Icons.person) : CachedNetworkImageProvider(feed.image),
              radius: 30.0,
            ),
          ),
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  feed.name,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    // tag: 'hero',
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: getProgressStatus(feed.status),
                        valueColor: AlwaysStoppedAnimation(getColorStatus(feed.status))),
                  )),
            ],
          ),
          isThreeLine: true,
          subtitle: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.spaceBetween,
            children: <Widget>[
              Text("${feed.state}, ${feed.city}", style: TextStyle(color: Colors.white, fontSize: 12.0)),
              SizedBox(height: 3),
              Text(formatter.format(feed.created), style: TextStyle(color: Colors.white70, fontSize: 12.0))
            ],
          ),
//          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeedDetails(feed: feed),
              ),
            );
          },
        ),
      ),
    );
  }

}
