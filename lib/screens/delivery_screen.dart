import 'package:divoc/common/chips.dart';
import 'package:divoc/common/list_tile.dart';
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
        stream: feedService.streamOwnerFeeds(currentUser.uid),
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
          subtitle: FeedListTileColumn(name: feed.name, created: feed.created, category: feed.category),
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
      onTap: () {},
    );
  }
}
