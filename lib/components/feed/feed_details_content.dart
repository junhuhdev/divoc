import 'package:flutter/material.dart';

class FeedDetailsContent extends StatefulWidget {
  @override
  _FeedDetailsContentState createState() => _FeedDetailsContentState();
}

class _FeedDetailsContentState extends State<FeedDetailsContent> {
  List<String> tabs = ['Info', 'Comments', 'Location'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(

        resizeToAvoidBottomPadding: true,
        appBar: TabBar(
          labelColor: Colors.indigo,
          tabs: <Widget>[
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            FeedInfo(),
            FeedComments(),
            FeedLocation(),
          ],
        ),
      ),
    );
  }
}

class FeedInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
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

class FeedLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
