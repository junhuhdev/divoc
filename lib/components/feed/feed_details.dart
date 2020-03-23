import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/common/chips.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/components/feed/caregiver_scroller.dart';
import 'package:divoc/components/feed/caretaker_details.dart';
import 'package:divoc/data/feed_list.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/feed_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedDetails extends StatefulWidget {
  final Feed feed;

  const FeedDetails({this.feed});

  @override
  _FeedDetailsState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {
  final FeedService feedService = FeedService();
  var formatter = new DateFormat('EEE d MMM h:mm a');

  List<Tab> tabs = [
    Tab(text: 'Info'),
    Tab(text: 'Comments'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(widget.feed.name),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            FeedInfo(feed: widget.feed),
            FeedComments(),
          ],
        ),
        floatingActionButton: AssistButton(feedService: feedService, feed: widget.feed),
      ),
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
                        title: Text('Assist'),
                        onTap: () async {
                          await feedService.updateRequestedUser(feed.id, currentUser);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text('Share'),
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

  const FeedInfo({Key key, this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = new DateFormat('EEE d MMM h:mm a');

    return FormContainer(
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
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        GenericTextContainer(title: 'Name', content: feed.name, icon: Icons.person),
        GenericTextContainer(
          title: 'Location',
          content: '${feed.state}, ${feed.city}',
          icon: Icons.place,
          contentPadding: EdgeInsets.symmetric(vertical: 30.0),
        ),
        GenericTextContainer(
          title: 'Description',
          content: '${feed.description}',
          contentPadding: EdgeInsets.all(30.0),
        ),
        GenericTextContainer(
          title: 'Shopping Info',
          content: '${feed.shoppingInfo}',
          contentPadding: EdgeInsets.all(30.0),
        ),
        GenericTextContainer(title: 'Created', content: formatter.format(feed.created), icon: Icons.calendar_today),
      ],
    );
  }
}

class FeedComments extends StatefulWidget {
  @override
  _FeedCommentsState createState() => _FeedCommentsState();
}

class _FeedCommentsState extends State<FeedComments> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
