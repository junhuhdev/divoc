import 'package:community_material_icon/community_material_icon.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/images.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:divoc/services/utils.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({this.userId});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<User> _user;

  @override
  void initState() {
    super.initState();
    _user = Document<User>(path: 'users/${widget.userId}').getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _user,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
          }
          return LoadingScreen();
        }
        final User user = snapshot.data;

        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(user.name),
            centerTitle: true,
          ),
          body: Card(
            margin: EdgeInsets.all(0.0),
            child: Container(
              decoration: BoxDecoration(color: kCardColor),
              padding: EdgeInsets.all(10.0),
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Center(child: UserProfileImage(image: user.photo)),
                      Positioned(
                        right: 20.0,
                        bottom: 0.0,
                        child: SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: FloatingActionButton(
                            heroTag: null,
                            mini: true,
                            elevation: 2.0,
                            child: user.mobile.isNullOrEmpty
                                ? const Icon(CommunityMaterialIcons.shield_off, size: 20.0, color: Colors.red)
                                : const Icon(Icons.verified_user, size: 20.0, color: Colors.green),
                            backgroundColor: user.photo.isNullEmptyOrWhitespace ? Colors.white : Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  GenericTextContainer(title: 'Namn', content: user.name, icon: Icons.person),
                  GenericTextContainer(title: 'Ålder', content: user.getAge.toString(), icon: Icons.person),
                  GenericTextContainer(
                      title: 'Kön', content: user.gender, icon: CommunityMaterialIcons.gender_male_female),
                  if (!user.role.isNullOrEmpty) ...[
                    GenericTextContainer(
                      title: 'Roll',
                      content: user.fromRole,
                      icon: CommunityMaterialIcons.hospital,
                    ),
                  ],
                  if (!user.state.isNullOrEmpty && !user.city.isNullOrEmpty) ...[
                    GenericTextContainer(
                      title: 'Plats',
                      content: '${user.state}, ${user.city}',
                      icon: Icons.place,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
