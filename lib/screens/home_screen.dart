import 'package:divoc/components/main_app_bar.dart';
import 'package:divoc/components/menu_drawer.dart';
import 'package:divoc/screens/feed_screen.dart';
import 'package:divoc/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _appBarTitle = "Feed";

  void _onItemTapped(int index) {
    if (index == 0) {
      _appBarTitle = 'Feed';
    }
    if (index == 1) {
      _appBarTitle = 'Caregiver';
    }
    if (index == 2) {
      _appBarTitle = 'Profile';
    }
    if (index == 3) {
      _appBarTitle = 'Settings';
    }
    if (index == 4) {
      _appBarTitle = 'Settings';
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    FeedScreen(),
    LoginScreen(),
    LoginScreen(),
    LoginScreen(),
    LoginScreen(),
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
            title: Text('Caregiver'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Summary'),
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
