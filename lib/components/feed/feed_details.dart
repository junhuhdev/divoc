import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/chips.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/models/user_comment.dart';
import 'package:divoc/services/feed_service.dart';
import 'package:divoc/services/user_comment_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../unicorn_fab/unicorn_button.dart';



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
            parentButton: Icon(Icons.local_hospital, color: Theme.of(context).primaryColor, size: 30.0),
            childButtons: <UnicornButton>[
              UnicornButton(
                hasLabel: true,
                labelText: "Se Profil",
                currentButton: FloatingActionButton(
                  heroTag: "upload-recipe",
                  backgroundColor: Colors.white,
                  mini: true,
                  child: Icon(Icons.remove_red_eye, color: Colors.blueGrey),
                  onPressed: () {},
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
                      await feedService.updateRequestedUser(currentUser, widget.feed, _comment);
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

class AssistButton extends StatelessWidget {
  const AssistButton({
    Key key,
    @required this.feedService,
    @required this.feed,
  }) : super(key: key);

  final FeedService feedService;
  final Feed feed;

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, currentUser, child) {
        if (currentUser != null && feed.requestedUsers.containsKey(currentUser.id) || feed.status != 'created') {
          return Container();
        }
        return FloatingActionButton(
          heroTag: 'assist-button',
          child: Icon(Icons.local_hospital),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.thumb_up),
                        title: Text('Assistera'),
                        onTap: () async {
//                          await feedService.updateRequestedUser(feed.id, currentUser, feed);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text('Dela'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                );
              },
            );
          },
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
          title: 'Beskrivning och inköpslista',
          content: '${feed.description}',
          contentPadding: EdgeInsets.all(30.0),
        ),
        GenericTextContainer(title: 'Skapad', content: formatter.format(feed.created), icon: Icons.calendar_today),
      ],
    );
  }
}

class FeedCommentScreen extends StatefulWidget {
  final Feed feed;
  final Stream<List<UserComment>> comments;

  const FeedCommentScreen({Key key, this.feed, this.comments}) : super(key: key);

  @override
  _FeedCommentScreenState createState() => _FeedCommentScreenState();
}

class _FeedCommentScreenState extends State<FeedCommentScreen> {
  final UserCommentService userCommentService = new UserCommentService();
  String _comment;

  @override
  void initState() {
    print("new comment view");
    super.initState();
  }

  Widget buildComment(UserComment userComment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormat('dd MMM kk:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(userComment.timestamp))),
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white, fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              Text(
                userComment.userName,
                style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.0),
              Text(
                userComment.content,
                softWrap: true,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(color: Colors.red[400], borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          body: StreamBuilder(
            stream: widget.comments,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingScreen();
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) => buildComment(snapshot.data[index]),
                  itemCount: snapshot.data.length,
                  reverse: true,
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'create new comment',
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                ),
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: ModalFormContainer(
                      children: <Widget>[
                        GenericTextField(
                          title: 'Kommentar',
                          height: 120.0,
                          maxLines: 5,
                          icon: Icons.comment,
                          textInputType: TextInputType.multiline,
                          onChanged: (String val) => setState(() => _comment = val),
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return ActionButton(
                              title: 'SKICKA',
                              onPressed: () async {
                                if (_comment != null) {
                                  userCommentService.insertComment(
                                    UserComment(
                                      feedId: widget.feed.id,
                                      userId: user.id,
                                      userName: user.name,
                                      userImage: user.photo,
                                      content: _comment,
                                    ),
                                  );
                                }
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
            },
          ),
        );
      },
    );
  }
}
