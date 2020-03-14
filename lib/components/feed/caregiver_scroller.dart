import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/data/feed_list.dart';
import 'package:divoc/models/caregiver.dart';
import 'package:flutter/material.dart';

class CaregiverScroller extends StatelessWidget {
  final List<Caregiver> caregiverlist;
  final String title;

  const CaregiverScroller({this.caregiverlist, this.title});

  Widget _buildCaregiverAvatar(BuildContext ctx, int index) {
    var caregiver = caregiverlist[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(caregiver.image),
            radius: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(caregiver.name),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                title,
                style: textTheme.subhead.copyWith(fontSize: 16.0),
              ),
            ),
          ),
          SizedBox.fromSize(
            size: const Size.fromHeight(120.0),
            child: ListView.builder(
              itemCount: caregiverlist.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 8.0, left: 20.0),
              itemBuilder: _buildCaregiverAvatar,
            ),
          ),
        ],
      ),
    );
  }
}
