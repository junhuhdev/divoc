import 'package:divoc/common/chips.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/list_tile.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/components/feed/create_feed.dart';
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

class _DeliveryDetailsState extends State<DeliveryDetails> with TickerProviderStateMixin {
  Future<Feed> _feed;
  AnimationController parentController;
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 180));
    parentController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _feed = Document<Feed>(path: 'feeds/${widget.feedRequest.feedId}').getData();
    super.initState();
  }

  @override
  dispose() {
    animationController.dispose();
    parentController.dispose();
    super.dispose();
  }

  void closeFloatingButton() {
    if (!animationController.isDismissed) {
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
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
            final Feed feed = snapshot.data;
            return FormContainer(
              onTap: () => this.closeFloatingButton(),
              horizontal: 0.0,
              vertical: 0.0,
              children: <Widget>[
                StaticGoogleMap(
                  apiKey: "AIzaSyCbr_dJZ6aQorm5JC2l31lzC2QnRNuMzWA",
                  address: Address.fromFeed(feed),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: GenericTextContainer(
                    title: 'Location',
                    content: '${feed.street}, ${feed.postalCode}, ${feed.state}, ${feed.city}',
                    icon: Icons.place,
                    height: 80.0,
                    contentPadding: EdgeInsets.only(top: 5.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: GenericTextContainer(title: 'Name', content: feed.name, icon: Icons.person),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: GenericTextContainer(title: 'Phone Number', content: feed.mobile, icon: Icons.phone),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: GenericTextContainer(
                    title: 'Description',
                    content: '${feed.description}',
                    icon: Icons.place,
                    height: 80.0,
                    contentPadding: EdgeInsets.only(top: 5.0),
                  ),
                ),
                SizedBox(height: 80.0),
              ],
            );
          }
        },
      ),
      floatingActionButton: UnicornContainer(
        animationController: animationController,
        parentController: parentController,
        backgroundColor: Colors.black54,
        parentButtonBackground: Colors.white,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.check, color: Theme.of(context).primaryColor, size: 30.0),
        childButtons: <UnicornButton>[
          UnicornButton(
            hasLabel: true,
            labelText: "Upload Recipe",
            currentButton: FloatingActionButton(
              heroTag: "upload-recipe",
              backgroundColor: Colors.white,
              mini: true,
              child: Icon(Icons.camera_alt, color: Colors.deepPurple),
              onPressed: () {},
            ),
          ),
          UnicornButton(
            hasLabel: true,
            labelText: "Upload Delivery",
            currentButton: FloatingActionButton(
              heroTag: "upload-delivery",
              backgroundColor: Colors.white,
              mini: true,
              child: Icon(Icons.camera_alt, color: Colors.deepPurple),
              onPressed: () {},
            ),
          ),
          UnicornButton(
            hasLabel: true,
            labelText: "Delivered",
            currentButton: FloatingActionButton(
              heroTag: "delivery",
              backgroundColor: Colors.white,
              mini: true,
              child: Icon(Icons.arrow_forward, color: Colors.deepPurple),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateFeed(),
                    ));
                print("delivered");
              },
            ),
          ),
        ],
      ),
    );
  }
}
