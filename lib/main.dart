import 'package:divoc/screens/home_screen.dart';
import 'package:divoc/screens/login_screen.dart';
import 'package:divoc/services/auth_service.dart';
import 'package:divoc/services/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(value: AuthService().user),
        FutureProvider<User>.value(value: Global.userDoc.getDocument()),
      ],
      child: MaterialApp(
        title: 'Divoc',
        debugShowCheckedModeBanner: false,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'OpenSans',
        ),
        home: LoginScreen(),
      ),
    );
  }
}
