import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/common/chips.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CaretakerDetails extends StatefulWidget {
  final Feed feed;

  const CaretakerDetails({this.feed});

  @override
  _CaretakerDetailsState createState() => _CaretakerDetailsState();
}

class _CaretakerDetailsState extends State<CaretakerDetails> {
  var formatter = new DateFormat('EEE d MMM h:mm a');

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        return Container(
          decoration: kBoxDecorationStyle,
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(20.0),
//                child: CircleAvatar(
//                  backgroundImage: CachedNetworkImageProvider(widget.feed.image),
//                  radius: 60.0,
//                ),
//              ),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.feed.status == 'created' &&
                      user != null &&
                      widget.feed.requestedUsers.containsKey(user.id)) ...[
                    FeedStatusBox(status: 'requested'),
                  ],
                  if (widget.feed.status != 'created') ...[
                    FeedStatusBox(status: widget.feed.status),
                  ],
                  SizedBox(height: 10.0),
                  if (user != null) ...[
                    Row(
                      children: <Widget>[
                        Text(widget.feed.name, style: TextStyle(fontSize: 20.0)),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Icon(Icons.person, size: 18.0),
                        SizedBox(width: 8.0),
                        Text(widget.feed.gender + ", "),
                        Text(widget.feed.age.toString() + " years old"),
                      ],
                    ),
//                    Row(
//                      children: <Widget>[
//                        Flexible(child: Icon(Icons.place, size: 18.0)),
//                        SizedBox(width: 8.0),
//                        Flexible(fit: FlexFit.loose, flex: 2, child: Text(widget.feed.state + ", ")),
//                        Flexible(fit: FlexFit.loose, flex: 2,child: Text(widget.feed.city)),
//                      ],
//                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today, size: 18.0),
                        SizedBox(width: 8.0),
                        Text(formatter.format(widget.feed.created))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.local_hospital, size: 18.0),
                        SizedBox(width: 8.0),
                        Text(widget.feed.category),
                      ],
                    ),
                  ],
                  if (user == null) ...[
                    Container(),
                  ]
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
