import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/models/user_comment.dart';
import 'package:divoc/services/user_comment_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedCommentScreen extends StatefulWidget {
  final Feed feed;
  final Stream<List<UserComment>> comments;

  const FeedCommentScreen({Key key, this.feed, this.comments}) : super(key: key);

  @override
  _FeedCommentScreenState createState() => _FeedCommentScreenState();
}

class _FeedCommentScreenState extends State<FeedCommentScreen> {
  final UserCommentService userCommentService = new UserCommentService();
  String _comment;
  String _mobile;

  @override
  void initState() {
    print("new comment view");
    super.initState();
  }

  Widget buildComment(UserComment userComment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormat('dd MMM kk:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(userComment.timestamp))),
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white, fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              Text(
                userComment.userName,
                style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.0),
              Text(
                userComment.content,
                softWrap: true,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(color: Colors.red[400], borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          body: StreamBuilder(
            stream: widget.comments,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingScreen();
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) => buildComment(snapshot.data[index]),
                  itemCount: snapshot.data.length,
                  reverse: true,
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'create new comment',
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                ),
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: ModalFormContainer(
                      children: <Widget>[
                        GenericTextField(
                          title: 'Kommentar',
                          height: 120.0,
                          maxLines: 5,
                          icon: Icons.comment,
                          textInputType: TextInputType.multiline,
                          onChanged: (String val) => setState(() => _comment = val),
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return ActionButton(
                              title: 'SKICKA',
                              onPressed: () async {
                                if (_comment != null) {
                                  userCommentService.insertComment(
                                    UserComment(
                                      feedId: widget.feed.id,
                                      userId: user.id,
                                      userName: user.name,
                                      userImage: user.photo,
                                      content: _comment,
                                    ),
                                  );
                                }
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
