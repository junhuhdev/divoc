import 'package:divoc/common/cards.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/images.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/components/feed/create_feed.dart';
import 'package:divoc/components/maps/static_google_map.dart';
import 'package:divoc/components/unicorn_fab/unicorn_button.dart';
import 'package:divoc/models/address.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/feed_request.dart';
import 'package:divoc/services/db.dart';
import 'package:divoc/services/feed_service.dart';
import 'package:divoc/services/image_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryScreen extends StatefulWidget {
  static const title = "Leverans";

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
              backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
              body: Container(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    FeedRequest feedRequest = snapshot.data[index];
                    return FeedListTileCard(
                      image: feedRequest.image,
                      name: feedRequest.name,
                      status: feedRequest.status,
                      city: feedRequest.city,
                      state: feedRequest.state,
                      created: feedRequest.created,
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
  Stream<Feed> _feed;
  AnimationController _animationController;
  ImageService imageService = ImageService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 180));
    _feed = Document<Feed>(path: 'feeds/${widget.feedRequest.feedId}').streamData();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void closeFloatingButton() {
    if (!_animationController.isDismissed) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _feed,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
          }
          return LoadingScreen();
        }
        final Feed feed = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Leverans detaljer'),
            centerTitle: true,
          ),
          body: FormContainer(
            onTap: () => this.closeFloatingButton(),
            horizontal: 0.0,
            vertical: 0.0,
            children: <Widget>[
              StaticGoogleMap(
                apiKey: "AIzaSyCbr_dJZ6aQorm5JC2l31lzC2QnRNuMzWA",
                address: Address.fromFeed(feed),
              ),
              GenericTextContainer(
                title: 'Plats',
                content: '${feed.street}, ${feed.postalCode}, ${feed.state}, ${feed.city}',
                icon: Icons.place,
                contentPadding: EdgeInsets.symmetric(vertical: 30.0),
              ),
              GenericTextContainer(title: 'Namn', content: feed.name, icon: Icons.person),
              GenericTextContainer(title: 'Mobil nummer', content: feed.mobile, icon: Icons.phone),
              GenericTextContainer(
                title: 'Beskrivning och inköpslista',
                content: '${feed.description}',
                contentPadding: EdgeInsets.all(30.0),
              ),
              GenericTextContainer(
                title: 'Leverans information',
                content: '${feed.deliveryInfo}',
                contentPadding: EdgeInsets.all(30.0),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeImageFullScreen(image: feed.recipeImage),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Kvitto', style: kLabelStyle),
                      SizedBox(height: 10.0),
                      RecipeImage(image: feed.recipeImage),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 80.0),
            ],
          ),
          floatingActionButton: UnicornContainer(
            animationController: _animationController,
            backgroundColor: Colors.black54,
            parentButtonBackground: Colors.white,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(Icons.check, color: Theme.of(context).primaryColor, size: 30.0),
            childButtons: <UnicornButton>[
              UnicornButton(
                hasLabel: true,
                labelText: "Ladda upp kvitto",
                currentButton: FloatingActionButton(
                  heroTag: "upload-recipe",
                  backgroundColor: Colors.white,
                  mini: true,
                  child: Icon(Icons.camera_alt, color: Colors.deepPurple),
                  onPressed: () async {
                    await imageService.uploadRecipeImage(feed.id);
                  },
                ),
              ),
              UnicornButton(
                hasLabel: true,
                labelText: "Ladda upp leverans",
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
                labelText: "Levererad",
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
      },
    );
  }
}
