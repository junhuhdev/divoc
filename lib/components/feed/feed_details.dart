import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/chips.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/components/unicorn_fab/unicorn_button.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/models/user_comment.dart';
import 'package:divoc/screens/user_profile_screen.dart';
import 'package:divoc/services/feed_service.dart';
import 'package:divoc/services/user_comment_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:divoc/services/utils.dart';

class FeedDetails extends StatefulWidget {
  final Feed feed;

  const FeedDetails({this.feed});

  @override
  _FeedDetailsState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> with TickerProviderStateMixin {
  final FeedService feedService = FeedService();
  final UserCommentService userCommentService = new UserCommentService();
  AnimationController _animationController;

  var formatter = new DateFormat('EEE d MMM h:mm a');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 180));
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.feed.name),
        centerTitle: true,
      ),
      body: FeedInfo(
        feed: widget.feed,
        onTap: closeFloatingButton,
      ),
      floatingActionButton: Consumer<User>(
        builder: (context, currentUser, child) {
          if (currentUser == null) {
            return Container();
          }
          return UnicornContainer(
            animationController: _animationController,
            backgroundColor: Colors.black54,
            parentButtonBackground: Colors.white,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(Icons.check, color: Theme.of(context).primaryColor, size: 30.0),
            childButtons: <UnicornButton>[
              UnicornButton(
                hasLabel: true,
                labelText: "Se Profil",
                currentButton: FloatingActionButton(
                  heroTag: "upload-recipe",
                  backgroundColor: Colors.white,
                  mini: true,
                  child: Icon(Icons.remove_red_eye, color: Colors.blueGrey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(userId: widget.feed.ownerId),
                      ),
                    );
                  },
                ),
              ),

              /// Check if user already has requested or if its created
              if (!widget.feed.requestedUsers.containsKey(currentUser.id) && widget.feed.status == 'created') ...[
                UnicornButton(
                  hasLabel: true,
                  labelText: "Hjälpa",
                  currentButton: FloatingActionButton(
                    heroTag: "upload-delivery",
                    backgroundColor: Colors.white,
                    mini: true,
                    child: Icon(Icons.favorite, color: Colors.redAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssistScreen(feed: widget.feed),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class AssistScreen extends StatefulWidget {
  final Feed feed;

  const AssistScreen({this.feed});

  @override
  _AssistScreenState createState() => _AssistScreenState();
}

class _AssistScreenState extends State<AssistScreen> {
  String _comment;
  String _mobile;
  final FeedService feedService = FeedService();

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, currentUser, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(widget.feed.name),
            centerTitle: true,
          ),
          body: FormContainer(
            children: <Widget>[
              GenericTextField(
                title: 'Mobil nummer (inkl +46)',
                hint: 'Skriv in ditt mobil nummer',
                icon: Icons.phone,
                initialValue: currentUser.mobile,
                onChanged: (String val) => setState(() => _mobile = val),
              ),
              SizedBox(height: 30.0),
              GenericTextField(
                title: 'Kommentar',
                hint: 'Fyll i valfri kommentar',
                height: 100.0,
                maxLines: 5,
                icon: Icons.comment,
                textInputType: TextInputType.multiline,
                onChanged: (String val) => setState(() => _comment = val),
              ),
              Builder(
                builder: (BuildContext context) {
                  return ActionButton(
                    title: 'Skicka förfrågan',
                    onPressed: () async {
                      String mobile = _mobile ?? currentUser.mobile;
                      if (mobile.isNullOrEmpty) {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Fyll i mobil nummer.')));
                        return;
                      }
                      await feedService.updateRequestedUser(currentUser, widget.feed, _comment, mobile);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class FeedInfo extends StatelessWidget {
  final Feed feed;
  final VoidCallback onTap;

  const FeedInfo({Key key, this.feed, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = new DateFormat('EEE d MMM h:mm a');

    return FormContainer(
      onTap: () => onTap(),
      horizontal: 0.0,
      vertical: 30.0,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Align(alignment: Alignment.centerRight, child: FeedStatusBox(status: feed.status)),
        ),
        SizedBox(height: 20.0),
        SizedBox(
          width: 300.0,
          height: 300.0,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: feed.image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(140.0),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) {
                return SizedBox(
                  width: 300.0,
                  height: 300.0,
                  child: Icon(Icons.account_circle, color: Colors.white, size: 300.0),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 20.0),
        GenericTextContainer(title: 'Namn', content: feed.name, icon: Icons.person),
        GenericTextContainer(
          title: 'Plats',
          content: '${feed.state}, ${feed.city}',
          icon: Icons.place,
          contentPadding: EdgeInsets.symmetric(vertical: 30.0),
        ),
        GenericTextContainer(
          title: 'Beskrivning',
          content: '${feed.description}',
          contentPadding: EdgeInsets.all(30.0),
        ),
        GenericTextContainer(title: 'Skapad', content: formatter.format(feed.created), icon: Icons.calendar_today),
      ],
    );
  }
}

