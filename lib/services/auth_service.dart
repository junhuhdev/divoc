import 'dart:math';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'globals.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookAuth = FacebookLogin();
  final Firestore _db = Firestore.instance;
  final UserService _userService = UserService();

  Future<FirebaseUser> get getCurrentUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;
      await refresh(user);
      return user;
    } catch (error) {
      print("Failed to sign in user $error");
      return null;
    }
  }

  Future<LoginResult> signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;
      AuthType authType = await refresh(user);
      return LoginResult(
        user: user,
        authType: authType,
        credential: EmailAuthProvider.getCredential(email: email, password: password),
        provider: LoginProvider.email,
      );
    } catch (error) {
      print("Failed to create user $error");
      return null;
    }
  }

  Future<FirebaseUser> appleSignIn() async {
    AuthResult authResult;
    AuthCredential credential;
    AppleIdCredential appleIdCredential;
    try {
      bool isAvailable = await AppleSignIn.isAvailable();
      if (isAvailable) {
        print("Apple sign in available");
        final AuthorizationResult result = await AppleSignIn.performRequests([
          AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
        ]);
        switch (result.status) {
          case AuthorizationStatus.authorized:
            appleIdCredential = result.credential;
            final oAuthProvider = OAuthProvider(providerId: 'apple.com');
            credential = oAuthProvider.getCredential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
            );
            authResult = await _auth.signInWithCredential(credential);
            break;
          case AuthorizationStatus.error:
            print("Sign in failed: ${result.error.localizedDescription}");
            break;
          case AuthorizationStatus.cancelled:
            print('User cancelled');
            break;
        }
        if (authResult == null) {
          print("User aborted apple login");
          return null;
        }
        FirebaseUser user = authResult.user;
        bool newUser = await isNewUser(user);
        if (newUser) {
          _db.collection('users').document(user.uid).setData(
            {
              'name': '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}',
              'id': user.uid,
              'email': appleIdCredential.email,
              'gender': 'Okänd',
              'createdAt': DateTime.now(),
              'provider': LoginProvider.apple,
            },
          );
          print("New user created");
          return user;
        }
        print("Existing apple user login successfully");
        return user;
      } else {
        print("Apple sign in not available");
        return null;
      }
    } catch (error) {
      print("Apple login error $error");
      return null;
    }
  }

  Future<LoginResult> facebookSignIn() async {
    AuthCredential facebookCredentials;
    String token;
    try {
      final FacebookLoginResult loginResult = await _facebookAuth.logIn(['email', 'public_profile']);
      AuthResult authResult;
      switch (loginResult.status) {
        case FacebookLoginStatus.loggedIn:
          token = loginResult.accessToken.token;
          print("Login successfull $token");
          facebookCredentials = FacebookAuthProvider.getCredential(accessToken: token);
          authResult = await _auth.signInWithCredential(facebookCredentials);
          break;
        case FacebookLoginStatus.cancelledByUser:
          print("Facebook sign in cancelled by user");
          return null;
        case FacebookLoginStatus.error:
          print("Facebook sign in failed");
          return null;
      }
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(800).height(800)&access_token=${token}');
      final profile = convert.jsonDecode(graphResponse.body);
      FirebaseUser user = authResult.user;
      AuthType authType = await refresh(user);
      return LoginResult(
        user: user,
        authType: authType,
        credential: facebookCredentials,
        provider: LoginProvider.facebook,
        photo: profile['picture']['data']['url'],
      );
    } catch (error) {
      print("Facebook login error $error");
      return null;
    }
  }

  Future<FirebaseUser> verifySmsCode(String verificationId, String smsCode, LoginResult loginResult) async {
    try {
      AuthCredential authCreds = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
      // (1) Verify sms
      var authResult = await _auth.signInWithCredential(authCreds);
      // (2) Sign out since firebase creates another user
      await _auth.signOut();
      // (3) Sign back in with previous authenticated method
      authResult = await _auth.signInWithCredential(loginResult.credential);
      print("Successfully verified sms ${authResult.user}");
      return authResult.user;
    } catch (error) {
      print("Failed to verify sms $error");
      return null;
    }
  }

  Future<bool> isNewUser(FirebaseUser user) async {
    final QuerySnapshot result = await _db.collection('users').where('id', isEqualTo: user.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 0;
  }

  Future<AuthType> refresh(FirebaseUser user) async {
    final QuerySnapshot result = await _db.collection('users').where('id', isEqualTo: user.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      await _auth.signOut();
      return AuthType.COLLECT_INFORMATION;
    } else {
      Global.userDoc.upsert(
        ({
          'lastLogin': DateTime.now(),
        }),
      );
    }
    return AuthType.SUCCESS;
  }

  Future<void> updateNewUser(LoginResult loginResult, User user) async {
    await _auth.signInWithCredential(loginResult.credential);
    final FirebaseUser firebaseUser = loginResult.user;
    final QuerySnapshot result = await _db.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      // (1) Create new user
      _db.collection('users').document(firebaseUser.uid).setData(
        {
          'name': user.name,
          'birthdate': user.birthdate,
          'age': _userService.calculateAge(user.birthdate),
          'gender': user.gender ?? 'Annat',
          'photo': loginResult.photo ?? firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'email': firebaseUser.email,
          'mobile': user.mobile,
          'createdAt': DateTime.now(),
          'provider': loginResult.provider,
        },
      );
    } else {
      // (2) Update existing user
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
  COLLECT_INFORMATION,
}

class LoginResult {
  final FirebaseUser user;
  final AuthType authType;
  final AuthCredential credential;
  final String provider;
  final String photo;

  LoginResult({
    this.user,
    this.authType,
    this.credential,
    this.provider,
    this.photo,
  });
}

class LoginProvider {
  static const String facebook = "facebook";
  static const String email = "email";
  static const String apple = "apple";
  static const String google = "google";
}
