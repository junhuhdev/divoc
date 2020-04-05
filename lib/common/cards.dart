import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:divoc/components/feed/feed_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class FeedListTileCard extends StatelessWidget {
  final String image;
  final String name;
  final String status;
  final String city;
  final String state;
  final DateTime created;
  final VoidCallback onTap;

  const FeedListTileCard({
    this.image,
    this.name,
    this.status,
    this.city,
    this.state,
    this.created,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattertime = new DateFormat('EEE d MMM h:mm a', 'sv_SE');
    final formatter = new DateFormat('EEE d MMM');

    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: kCardColor),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: CircleAvatar(
              backgroundImage: image == null ? Icon(Icons.person) : CachedNetworkImageProvider(image),
              radius: 30.0,
            ),
          ),
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    // tag: 'hero',
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: getProgressStatus(status),
                        valueColor: AlwaysStoppedAnimation(getColorStatus(status))),
                  )),
            ],
          ),
          isThreeLine: true,
          subtitle: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.spaceBetween,
            children: <Widget>[
              Text("$state, $city", style: TextStyle(color: Colors.white, fontSize: 12.0)),
              SizedBox(height: 3),
              Text(formattertime.format(created), style: TextStyle(color: Colors.white70, fontSize: 12.0))
            ],
          ),
          onTap: () => onTap(),
        ),
      ),
    );
  }
}

class ContributorCard extends StatelessWidget {
  final String name;
  final String image;
  final String gender;
  final int age;
  final String city;
  final VoidCallback onTap;

  const ContributorCard({
    this.name,
    this.image,
    this.gender,
    this.age,
    this.city,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: kCardColor),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: CircleAvatar(
              backgroundImage: image == null ? Icon(Icons.person) : CachedNetworkImageProvider(image),
              radius: 30.0,
            ),
          ),
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: RatingBar(
                    itemSize: 10.0,
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
//                    itemPadding: EdgeInsets.all(30.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
              )
            ],
          ),
          isThreeLine: true,
          subtitle: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.spaceBetween,
            children: <Widget>[
              Text("$gender, $age", style: TextStyle(color: Colors.white, fontSize: 10.0)),
              SizedBox(height: 3),
              Text("$city", style: TextStyle(color: Colors.white, fontSize: 10.0)),
            ],
          ),
          onTap: () => onTap(),
        ),
      ),
    );
  }

  String getSwedishGender() {
    if (gender =='MALE') {
      return "Man";
    }
    return "Kvinna";
  }

  Icon getGenderIcon() {
    if (gender == 'MALE') {
      return const Icon(CommunityMaterialIcons.gender_male, size: 13.0);
    }
    return const Icon(CommunityMaterialIcons.gender_female, size: 13.0);
  }
}
