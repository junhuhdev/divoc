import 'package:community_material_icon/community_material_icon.dart';
import 'package:divoc/screens/onboarding_inside_screen.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Divoc',
              style: TextStyle(
                letterSpacing: 10.0,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(CommunityMaterialIcons.comment_question),
            title: Text('Så funkar Divoc'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OnboardingInsideScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information),
            title: Text('Version 1.0.14'),
          ),

//          ListTile(
//            leading: Icon(Icons.settings),
//            title: Text('Settings'),
//          ),
//          ListTile(
//            leading: Icon(Icons.account_circle),
//            title: Text('About'),
//          ),
//          ListTile(
//            leading: Icon(Icons.account_circle),
//            title: Text('Contact'),
//          ),
        ],
      ),
    );
  }
}
