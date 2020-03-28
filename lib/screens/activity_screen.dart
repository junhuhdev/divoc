import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/list_tile.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/address.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/feed_request.dart';
import 'package:divoc/screens/user_profile_screen.dart';
import 'package:divoc/services/db.dart';
import 'package:divoc/services/feed_service.dart';
import 'package:divoc/services/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatelessWidget {
  static const title = "Mina Ärenden";

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
              backgroundColor: kBackgroundColor,
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
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: SettingsMenu(feed: feed),
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
          subtitle: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 3),
              Text("${feed.state}, ${feed.city}", style: TextStyle(color: Colors.white, fontSize: 12.0)),
              SizedBox(height: 3),
              Text(formatter.format(feed.created), style: TextStyle(color: Colors.white70, fontSize: 12.0))
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetails(feed: feed),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettingsMenu extends StatelessWidget {
  final Feed feed;
  final FeedService feedService = FeedService();

  SettingsMenu({this.feed});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
        Icons.settings,
        size: 25.0,
        color: Colors.white,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'pending',
          child: Text('Ändra'),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Ta bort'),
        ),
      ],
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
        title: Text('Förfrågan detaljer'),
        centerTitle: true,
      ),
      body: FormContainer(
        children: <Widget>[
          GenericTextField(
            title: 'Namn',
            hint: 'Skriv in ditt namn',
            icon: Icons.person,
            initialValue: widget.feed.name,
            textInputType: TextInputType.text,
            onChanged: (String val) => setState(() => _name = val),
          ),
          SizedBox(height: 30.0),
          GenericTextField(
            title: 'Mobil Nummer',
            hint: 'Skriv in ditt mobil nummer',
            icon: Icons.phone,
            initialValue: widget.feed.mobile,
            textInputType: TextInputType.phone,
            onChanged: (String val) => setState(() => _mobile = val),
          ),
          SizedBox(height: 30.0),
          GenericTextField(
            title: 'Beskrivning och inköpslista',
            hint: 'Skriv in detaljerad beskrivning och inköpslista',
            height: 100.0,
            maxLines: 5,
            icon: Icons.comment,
            initialValue: widget.feed.description,
            textInputType: TextInputType.multiline,
            onChanged: (String val) => setState(() => _description = val),
          ),
          SizedBox(height: 30.0),
          GenericTextField(
            title: 'Leverans information',
            hint: 'Skriv in detaljerad leverans information som portkod och våning',
            height: 100.0,
            maxLines: 5,
            icon: Icons.add_shopping_cart,
            initialValue: widget.feed.shoppingInfo,
            textInputType: TextInputType.multiline,
            onChanged: (String val) => setState(() => _shoppingInfo = val),
          ),
          SizedBox(height: 30.0),
          GenericGoogleMapField(
            title: 'Plats',
            hint: 'Välj plats',
            initialValue: widget.feed.formattedAddress,
            onSelected: (Address address) {
              _address = address;
            },
          ),
          ActionButton(
            title: 'Update',
            onPressed: () async {
              await feedService.updateFeed(
                widget.feed.id,
                Feed(
                  name: _name.isNullOrEmpty ? widget.feed.name : _name,
                  mobile: _mobile.isNullOrEmpty ? widget.feed.mobile : _mobile,
                  category: _category.isNullOrEmpty ? widget.feed.category : _category,
                  description: _description.isNullOrEmpty ? widget.feed.description : _description,
                  shoppingInfo: _shoppingInfo.isNullOrEmpty ? widget.feed.shoppingInfo : _shoppingInfo,
                  city: _address != null ? _address.city : '',
                  state: _address != null ? _address.state : '',
                  street: _address != null ? _address.street : '',
                  postalCode: _address != null ? _address.postalCode : '',
                  geolocation:
                      _address != null ? GeoPoint(_address.geolocation.latitude, _address.geolocation.longitude) : null,
                ),
              );
              Navigator.pop(context);
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
        title: Text('Förfrågningar'),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
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
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: kCardColor),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          subtitle: FeedListTileColumn(feed: Feed(name: feedRequest.name, created: feedRequest.created)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.cancel, color: Colors.red),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.check_circle, color: Colors.green),
                onPressed: () async {
                  await feedService.acceptUserRequest(feed.id, feedRequest.userId);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
