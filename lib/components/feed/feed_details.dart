import 'package:divoc/components/feed/caregiver_scroller.dart';
import 'package:divoc/components/feed/caretaker_details.dart';
import 'package:divoc/data/feed_list.dart';
import 'package:divoc/models/feed.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedDetails extends StatefulWidget {
  final Feed feed;

  const FeedDetails({this.feed});

  @override
  _FeedDetailsState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.local_hospital),
          onPressed: () {},
        ),
      ),
    );
  }
}

class FeedInfo extends StatelessWidget {
  final Feed feed;

  const FeedInfo({Key key, this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        CaretakerDetails(feed: feed),
        CaregiverScroller(title: 'Contact group', caregiverlist: contactGroups),
        CaregiverScroller(title: 'Caretaker', caregiverlist: careTaker),
        CaregiverScroller(title: 'Caregivers', caregiverlist: caregivers),
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
