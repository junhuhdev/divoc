import 'package:flutter/material.dart';

class CreateFeed extends StatefulWidget {
  @override
  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Create new feed'),
        centerTitle: true,
      ),
      body: Container(

      ),
    );
  }
}
