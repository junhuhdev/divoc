import 'package:flutter/material.dart';

class FeedStatusChip extends StatelessWidget {
  final String status;
  final Color backgroundColor;

  const FeedStatusChip({this.status, this.backgroundColor});

  Color getColorByStatus() {
    if (status == 'pending') {
      return Colors.amber;
    }
    if (status == 'completed') {
      return Colors.green;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: getColorByStatus(),
      labelStyle: TextStyle(color: Colors.white),
      label: Text(status),
    );
  }
}

class FeedStatusBox extends StatelessWidget {
  final String status;

  const FeedStatusBox({this.status});

  Color getColorByStatus() {
    if (status == 'pending') {
      return Colors.amber;
    }
    if (status == 'completed') {
      return Colors.green;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      decoration: BoxDecoration(color: getColorByStatus(), borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Text(
        status,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
