import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/components/main_app_bar.dart';
import 'package:divoc/components/menu_drawer.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/screens/activity_screen.dart';
import 'package:divoc/screens/contributors_screen.dart';
import 'package:divoc/screens/delivery_screen.dart';
import 'package:divoc/screens/feed_screen.dart';
import 'package:divoc/screens/profile_screen.dart';
import 'package:divoc/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:divoc/services/utils.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _appBarTitle = FeedScreen.title;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final AuthService securityService = AuthService();

  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.blueGrey,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
      iosSubscription = _fcm.onIosSettingsRegistered.listen((event) {
        print(event);
      });
      _saveDeviceToken();
    } else {
      _saveDeviceToken();
    }
  }

  @override
  void dispose() {
    if (iosSubscription != null) iosSubscription.cancel();
    super.dispose();
  }

  /// Get the token, save it to the database for current user
  _saveDeviceToken() async {
    FirebaseUser user = await securityService.getCurrentUser;
    String fcmToken = await _fcm.getToken();
    if (!fcmToken.isNullOrEmpty) {
      var tokens = _db.collection('users').document(user.uid);

      await tokens.setData({
        'token': fcmToken,
      }, merge: true);
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      _appBarTitle = FeedScreen.title;
    }
    if (index == 1) {
      _appBarTitle = ContributorsScreen.title;
    }
    if (index == 2) {
      _appBarTitle = ActivityScreen.title;
    }
    if (index == 3) {
      _appBarTitle = DeliveryScreen.title;
    }
    if (index == 4) {
      _appBarTitle = ProfileScreen.title;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    FeedScreen(),
    ContributorsScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  List<Widget> _helperOptions = <Widget>[
    FeedScreen(),
    ContributorsScreen(),
    DeliveryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        if (user == null) {
          return LoadingScreen();
        } else {
          bool isHelper = user.isHelper;
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: MainAppBar(title: _appBarTitle),
            ),
            drawer: MenuDrawer(),
            body: Center(
              child: isHelper ? _helperOptions.elementAt(_selectedIndex) : _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
              inactiveColor: Colors.white54,
              activeColor: Colors.white,
              iconSize: 22.0,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.language),
                  title: Text('Uppdrag', style: TextStyle(fontSize: 12.0)),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  title: Text('Hjälpare', style: TextStyle(fontSize: 12.0)),
                ),
                if (!isHelper) ...[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_hospital),
                    title: Text('Ärenden', style: TextStyle(fontSize: 12.0)),
                  ),
                ],
                if (isHelper) ...[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_shipping),
                    title: Text('Leverans', style: TextStyle(fontSize: 12.0)),
                  ),
                ],
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  title: Text('Profil', style: TextStyle(fontSize: 12.0)),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}
