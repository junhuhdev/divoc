import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/screens/home_screen.dart';
import 'package:divoc/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'globals.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookAuth = FacebookLogin();
  final Firestore _db = Firestore.instance;

  Future<FirebaseUser> get getCurrentUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> signUp(String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseUser user = result.user;
    await refresh(user);
    return user;
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseUser user = result.user;
    await refresh(user);
    return user;
  }

  Future<LoginResult> facebookSignIn() async {
    try {
      final FacebookLoginResult loginResult = await _facebookAuth.logIn(['email', 'public_profile']);
      AuthResult authResult;
      switch (loginResult.status) {
        case FacebookLoginStatus.loggedIn:
          final token = loginResult.accessToken.token;
          print("Login successfull $token");
          final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: token);
          authResult = await FirebaseAuth.instance.signInWithCredential(credential);
          break;
        case FacebookLoginStatus.cancelledByUser:
          print("Facebook sign in cancelled by user");
          break;
        case FacebookLoginStatus.error:
          print("Facebook sign in failed");
          break;
      }
      FirebaseUser user = authResult.user;
      var authType = await refresh(user);
      return LoginResult(user, authType);
    } catch (error) {
      print("Facebook login error $error");
      return null;
    }
  }

  Future<AuthType> refresh(FirebaseUser user) async {
    final QuerySnapshot result = await _db.collection('users').where('id', isEqualTo: user.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      // (1) Verify phone
      return AuthType.PHONE_VERIFICATION;
//      _auth.verifyPhoneNumber(
//        phoneNumber: null,
//        timeout: Duration(seconds: 60),
//        verificationCompleted: null,
//        verificationFailed: null,
//        codeSent: null,
//        codeAutoRetrievalTimeout: null,
//      );

      // (2) Create new user
      _db.collection('users').document(user.uid).setData(
        {
          'name': user.email,
          'photo': user.photoUrl,
          'id': user.uid,
          'email': user.email,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        },
      );
    } else {
      Global.userDoc.upsert(
        ({
          'lastLogin': DateTime.now().toIso8601String(),
        }),
      );
    }
    return AuthType.SUCCESS;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _auth.currentUser();
    return user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _auth.currentUser();
    return user.isEmailVerified;
  }
}

enum AuthType {
  SUCCESS,
  FAILED,
  PHONE_VERIFICATION,
}

class LoginResult {
  final FirebaseUser user;
  final AuthType authType;

  LoginResult(this.user, this.authType);
}
