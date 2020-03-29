import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/images.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/db.dart';
import 'package:flutter/material.dart';

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
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(user.name),
              centerTitle: true,
            ),
            body: FormContainer(
              children: <Widget>[
                UserProfileImage(image: user.photo),
                GenericTextContainer(title: 'Namn', content: user.name, icon: Icons.person),
                GenericTextContainer(
                  title: 'Plats',
                  content: '${user.state}, ${user.city}',
                  icon: Icons.place,
                ),
              ],
            ),
          );
        });
  }
}
