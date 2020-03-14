import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/components/feed/caretaker_details.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.feed.name),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CaretakerDetails(feed: widget.feed),
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_hospital),
        onPressed: () {},
      ),
    );
  }
}
