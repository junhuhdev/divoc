import 'package:flutter/material.dart';

class FeedStatusChip extends StatelessWidget {
  final String status;
  final Color backgroundColor;

  const FeedStatusChip({this.status, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Chip(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: backgroundColor,
      labelStyle: TextStyle(color: Colors.white),
      label: Text(status),
    );
  }
}
