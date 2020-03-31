import 'package:divoc/screens/home_screen.dart';
import 'package:divoc/screens/signin_screen.dart';
import 'package:divoc/services/globals.dart';
import 'package:divoc/services/security_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/constants.dart';
import 'models/user.dart';

void main() {
//  debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(value: SecurityService().user),
        StreamProvider<User>.value(value: Global.userDoc.documentStream),
      ],
      child: MaterialApp(
        title: 'Divoc',
        debugShowCheckedModeBanner: false,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
        },
        theme: ThemeData(
//          brightness: Brightness.dark,
            primaryColor: kBackgroundColor,
            backgroundColor: kBackgroundColor,
            primarySwatch: Colors.blueGrey,
            fontFamily: 'Raleway',
            iconTheme: IconThemeData(color: Colors.white),
            textTheme: TextTheme(
//              subtitle1: TextStyle(color: Colors.white),
//              subtitle2: TextStyle(color: Colors.white),
//              headline1: TextStyle(color: Colors.white),
//              bodyText2: TextStyle(color: Colors.white),
//              bodyText1: TextStyle(color: Colors.white),
                )),
        home: SigninScreen(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
      ),
    );
  }
}
