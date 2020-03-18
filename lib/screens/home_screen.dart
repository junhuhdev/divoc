import 'package:divoc/components/main_app_bar.dart';
import 'package:divoc/components/menu_drawer.dart';
import 'package:divoc/screens/activity_screen.dart';
import 'package:divoc/screens/delivery_screen.dart';
import 'package:divoc/screens/feed_screen.dart';
import 'package:divoc/screens/login_screen.dart';
import 'package:divoc/screens/profile_screen.dart';
import 'package:divoc/screens/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _appBarTitle = "Feed";

  void _onItemTapped(int index) {
    if (index == 0) {
      _appBarTitle = FeedScreen.title;
    }
    if (index == 1) {
      _appBarTitle = ActivityScreen.title;
    }
    if (index == 2) {
      _appBarTitle = DeliveryScreen.title;
    }
    if (index == 3) {
      _appBarTitle = ProfileScreen.title;
    }
    if (index == 4) {
      _appBarTitle = SettingsScreen.title;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    FeedScreen(),
    ActivityScreen(),
    DeliveryScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MainAppBar(title: _appBarTitle),
      ),
      drawer: MenuDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.black54,
        inactiveColor: Colors.white54,
        activeColor: Colors.white,
        iconSize: 24.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            title: Text('Feed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            title: Text('Activity'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            title: Text('Delivery'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
