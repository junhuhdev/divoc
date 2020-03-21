import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/common/chips.dart';
import 'package:divoc/common/list_tile.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/feed_request.dart';
import 'package:divoc/services/db.dart';
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
        stream: feedService.streamOwnerFeeds(currentUser.uid),
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
      child: Card(
        elevation: 3.0,
        child: ListTile(
          contentPadding: EdgeInsets.all(15.0),
          subtitle: FeedListTileColumn(feed: feed),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetails(feed: feed),
          ),
        );
      },
    );
  }
}

class ActivityDetails extends StatefulWidget {
  final Feed feed;

  const ActivityDetails({this.feed});

  @override
  _ActivityDetailsState createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  Future<List<FeedRequest>> _feedRequests;

  @override
  void initState() {
    super.initState();
    _feedRequests =
        Collection<FeedRequest>(path: 'feeds/${widget.feed.id}/requests').getDataByEqualTo('status', 'requested');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Pending Requests'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _feedRequests,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
            }
            return LoadingScreen();
          } else {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ActivityDetailsCard(feed: widget.feed, feedRequest: snapshot.data[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class ActivityDetailsCard extends StatelessWidget {
  final Feed feed;
  final FeedRequest feedRequest;

  ActivityDetailsCard({this.feed, this.feedRequest});

  final FeedService feedService = new FeedService();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(15.0),
        subtitle: FeedListTileColumn(feed: Feed(name: feedRequest.name, created: feedRequest.created)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.check_circle, color: Colors.green),
              onPressed: () async {
                feedService.acceptUserRequest(feed.id, feedRequest.userId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
