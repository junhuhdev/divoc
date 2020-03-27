import 'package:divoc/components/main_app_bar.dart';
import 'package:divoc/components/menu_drawer.dart';
import 'package:divoc/screens/activity_screen.dart';
import 'package:divoc/screens/contributors_screen.dart';
import 'package:divoc/screens/delivery_screen.dart';
import 'package:divoc/screens/feed_screen.dart';
import 'package:divoc/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _appBarTitle = "Flöde";

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
    DeliveryScreen(),
    ProfileScreen(),
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
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        inactiveColor: Colors.white54,
        activeColor: Colors.white,
        iconSize: 22.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            title: Text('Flöde', style: TextStyle(fontSize: 12.0)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Medhjälpare', style: TextStyle(fontSize: 12.0)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            title: Text('Status', style: TextStyle(fontSize: 12.0)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            title: Text('Leverans', style: TextStyle(fontSize: 12.0)),
          ),
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
}
