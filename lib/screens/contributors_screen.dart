import 'package:divoc/common/cards.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/screens/user_profile_screen.dart';
import 'package:divoc/services/globals.dart';
import 'package:divoc/services/user_service.dart';
import 'package:flutter/material.dart';

class ContributorsScreen extends StatefulWidget {
  static const title = "Topphjälpare";

  @override
  _ContributorsScreenState createState() => _ContributorsScreenState();
}

class _ContributorsScreenState extends State<ContributorsScreen> {
  Stream<List<User>> _users;
  UserService userService = new UserService();
  @override
  void initState() {
    super.initState();
    _users = userService.streamTopUsers();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _users,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
          }
          return LoadingScreen();
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(ContributorsScreen.title),
              centerTitle: true,
            ),
            backgroundColor: kBackgroundColor,
            body: Container(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  User user = snapshot.data[index];
                  return ContributorCard(
                    image: user.photo,
                    name: user.name,
                    city: user.city,
                    gender: user.gender,
                    age: user.age,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(userId: user.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
