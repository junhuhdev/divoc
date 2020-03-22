import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/chips.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/list_tile.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/address.dart';
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
  static const title = "Activity Status";

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
  final FeedService feedService = new FeedService();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: ActivityListTile(feed: feed)),
              PopupMenuButton(
                onSelected: (val) {
                  if (val == 'pending') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityShowPending(feed: feed),
                      ),
                    );
                  }
                  if (val == 'delete') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Are you sure you want to delete?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Confirm'),
                              onPressed: () {
                                feedService.deleteFeed(feed.id);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Icon(
                  Icons.more_vert,
                  size: 20.0,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'pending',
                    child: Text('Pending Requests'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
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
  String _name;
  String _mobile;
  String _category;
  String _description;
  String _shoppingInfo;
  Address _address;
  final FeedService feedService = FeedService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Activity Details'),
        centerTitle: true,
      ),
      body: FormContainer(
        children: <Widget>[
          GenericTextField(
            title: 'Name',
            hint: 'Enter name of person involved',
            icon: Icons.person,
            initialValue: widget.feed.name,
            textInputType: TextInputType.text,
            onChanged: (String val) => setState(() => _name = val),
          ),
          SizedBox(height: 30.0),
          GenericTextField(
            title: 'Mobile Number',
            hint: 'Enter number of contact person',
            icon: Icons.phone,
            initialValue: widget.feed.mobile,
            textInputType: TextInputType.phone,
            onChanged: (String val) => setState(() => _mobile = val),
          ),
          SizedBox(height: 30.0),
          GenericDropdownField(
            title: 'Category',
            hint: 'Select category',
            icon: Icons.category,
            initialValue: widget.feed.category,
            options: ['Food', 'Medicine', 'Other'],
            onChanged: (String val) => setState(() => _category = val),
          ),
          SizedBox(height: 30.0),
          GenericTextField(
            title: 'Description',
            hint: 'Enter a detailed description',
            height: 100.0,
            maxLines: 5,
            icon: Icons.comment,
            initialValue: widget.feed.description,
            textInputType: TextInputType.multiline,
            onChanged: (String val) => setState(() => _description = val),
          ),
          SizedBox(height: 30.0),
          GenericTextField(
            title: 'Shopping List',
            hint: 'Enter a detailed shopping list with name and quantity',
            height: 100.0,
            maxLines: 5,
            icon: Icons.add_shopping_cart,
            initialValue: widget.feed.shoppingInfo,
            textInputType: TextInputType.multiline,
            onChanged: (String val) => setState(() => _shoppingInfo = val),
          ),
          SizedBox(height: 30.0),
          GenericGoogleMapField(
            title: 'Location',
            hint: 'Select location',
            onSelected: (Address adress) {
              _address = adress;
            },
          ),
          ActionButton(
            title: 'Update',
            onPressed: () async {
              await feedService.updateFeed(
                widget.feed.id,
                Feed(
                  name: _name,
                  mobile: _mobile,
                  category: _category,
                  description: _description,
                  shoppingInfo: _shoppingInfo,
                  city: _address.city,
                  state: _address.state,
                  street: _address.street,
                  postalCode: _address.postalCode,
                  geolocation: GeoPoint(_address.geolocation.latitude, _address.geolocation.longitude),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ActivityShowPending extends StatefulWidget {
  final Feed feed;

  const ActivityShowPending({this.feed});

  @override
  _ActivityShowPendingState createState() => _ActivityShowPendingState();
}

class _ActivityShowPendingState extends State<ActivityShowPending> {
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

/// Accept or cancel pending requests
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
              onPressed: () async {},
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
