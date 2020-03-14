import 'package:flutter/material.dart';

class FeedDetailsContent extends StatefulWidget {
  @override
  _FeedDetailsContentState createState() => _FeedDetailsContentState();
}

class _FeedDetailsContentState extends State<FeedDetailsContent> with SingleTickerProviderStateMixin {
  List<Tab> tabs = [
    Tab(text: 'Info'),
    Tab(text: 'Comments'),
    Tab(text: 'Location'),
  ];

  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          tabs: tabs,
        ),
      ],
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
