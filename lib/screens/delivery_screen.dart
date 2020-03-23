import 'package:divoc/common/chips.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/list_tile.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/components/maps/static_google_map.dart';
import 'package:divoc/components/speeddial/speed_dial.dart';
import 'package:divoc/components/speeddial/speed_dial_controller.dart';
import 'package:divoc/components/unicorn_fab/unicorn_button.dart';
import 'package:divoc/models/address.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/feed_request.dart';
import 'package:divoc/services/db.dart';
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
        stream: feedService.streamFeedRequests(currentUser.uid),
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
                    return DeliveryCard(
                      feedRequest: snapshot.data[index],
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

class DeliveryCard extends StatelessWidget {
  final FeedRequest feedRequest;

  DeliveryCard({this.feedRequest});

  final formatter = new DateFormat('EEE d MMM h:mm a');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 3.0,
        child: ListTile(
          contentPadding: EdgeInsets.all(15.0),
          subtitle: FeedListTileColumn(feed: Feed(name: feedRequest.name, created: feedRequest.created)),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FeedStatusBox(status: feedRequest.status),
            ],
          ),
        ),
      ),
      onTap: () {
        if (feedRequest.status == 'requested') {}
        if (feedRequest.status == 'pending' || feedRequest.status == 'completed') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryDetails(feedRequest: feedRequest),
            ),
          );
        }
      },
    );
  }
}

/// (1) See delivery location
/// (2) Upload recipe image
/// (3) Upload delivered image
/// (4) Mark as delivered
class DeliveryDetails extends StatefulWidget {
  final FeedRequest feedRequest;

  const DeliveryDetails({this.feedRequest});

  @override
  _DeliveryDetailsState createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  Future<Feed> _feed;
  SpeedDialController _controller = SpeedDialController();

  @override
  void initState() {
    super.initState();
    _feed = Document<Feed>(path: 'feeds/${widget.feedRequest.feedId}').getData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.unfold();
  }



  @override
  Widget build(BuildContext context) {

    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Choo choo",
        currentButton: FloatingActionButton(
          heroTag: "train",
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.train),
          onPressed: () {},
        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "airplane",
            backgroundColor: Colors.greenAccent,
            mini: true,
            child: Icon(Icons.airplanemode_active))));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "directions",
            backgroundColor: Colors.blueAccent,
            mini: true,
            child: Icon(Icons.directions_car))));


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Delivery Details'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _feed,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
            }
            return LoadingScreen();
          } else {
            return SafeArea(
              child: FormContainer(
                horizontal: 0.0,
                vertical: 0.0,
                children: <Widget>[
                  StaticGoogleMap(
                    apiKey: "AIzaSyCbr_dJZ6aQorm5JC2l31lzC2QnRNuMzWA",
                    address: Address.fromFeed(snapshot.data),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: UnicornDialer(
          backgroundColor: Colors.black54,
          parentButtonBackground: Colors.white,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.check, color: Colors.deepPurple, size: 30.0),
          childButtons: childButtons),
    );
  }

  Widget _buildFloatingActionButton() {
    final icons = [
      SpeedDialAction(child: Icon(Icons.mode_edit)),
      SpeedDialAction(child: Icon(Icons.date_range)),
      SpeedDialAction(child: Icon(Icons.list)),
    ];

    return SpeedDialFloatingActionButton(
      actions: icons,
      controller: _controller,
      // Make sure one of child widget has Key value to have fade transition if widgets are same type.
      childOnFold: Icon(Icons.event_note, key: UniqueKey()),
      childOnUnfold: Icon(Icons.add),
      useRotateAnimation: true,
      animationDuration: 50,
      onAction: _onSpeedDialAction,
    );
  }

  _onSpeedDialAction(int selectedActionIndex) {
    print('$selectedActionIndex Selected');
  }


}
