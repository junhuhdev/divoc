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
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: getColorByStatus(),
      labelStyle: TextStyle(color: Colors.white),
      label: Text(status),
    );
  }
}
