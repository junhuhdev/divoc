import 'package:divoc/screens/home_screen.dart';
import 'package:divoc/screens/login_screen.dart';
import 'package:divoc/screens/onboarding_screen.dart';
import 'package:divoc/services/globals.dart';
import 'package:divoc/services/auth_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'common/constants.dart';
import 'models/user.dart';

void main() {
//  debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(value: AuthService().user),
        StreamProvider<User>.value(value: Global.userDoc.documentStream),
      ],
      child: MaterialApp(
        title: 'Divoc',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => OnboardingScreen(),
          HomeScreen.id: (context) => HomeScreen(),
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // Add global cupertino localiztions.
        ],
        locale: Locale('sv', 'SE'), // Current locale
        supportedLocales: [
          const Locale('sv', 'SE'), // English
          const Locale('en', 'US'), // English
        ],
        theme: ThemeData(
          primaryColor: kBackgroundColor,
          backgroundColor: kBackgroundColor,
          primarySwatch: Colors.blueGrey,
          fontFamily: 'Raleway',
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(),
        ),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],
      ),
    );
  }
}
