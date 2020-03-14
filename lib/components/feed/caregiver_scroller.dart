import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/data/feed_list.dart';
import 'package:divoc/models/caregiver.dart';
import 'package:flutter/material.dart';

class CaregiverScroller extends StatelessWidget {
  final List<Caregiver> caregiverlist;

  const CaregiverScroller({this.caregiverlist});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Caregivers',
            style: textTheme.subhead.copyWith(fontSize: 18.0),
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(120.0),
          child: ListView.builder(
            itemCount: caregiverlist.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 12.0, left: 20.0),
            itemBuilder: _buildCaregiverAvatar,
          ),
        ),
      ],
    );
  }
}
