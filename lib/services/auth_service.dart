import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'globals.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookAuth = FacebookLogin();
  final Firestore _db = Firestore.instance;
  final UserService _userService = UserService();

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
    AuthCredential facebookCredentials;
    try {
      final FacebookLoginResult loginResult = await _facebookAuth.logIn(['email', 'public_profile']);
      AuthResult authResult;
      switch (loginResult.status) {
        case FacebookLoginStatus.loggedIn:
          final token = loginResult.accessToken.token;
          print("Login successfull $token");
          facebookCredentials = FacebookAuthProvider.getCredential(accessToken: token);
          authResult = await _auth.signInWithCredential(facebookCredentials);
          break;
        case FacebookLoginStatus.cancelledByUser:
          print("Facebook sign in cancelled by user");
          break;
        case FacebookLoginStatus.error:
          print("Facebook sign in failed");
          break;
      }
      FirebaseUser user = authResult.user;
      AuthType authType = await refresh(user);
      if (authType == AuthType.COLLECT_INFORMATION) {
        await _auth.signOut();
      }
      return LoginResult(user, authType, facebookCredentials);
    } catch (error) {
      print("Facebook login error $error");
      return null;
    }
  }

  Future<FirebaseUser> verifySmsCode(String verificationId, String smsCode, LoginResult loginResult) async {
    try {
      AuthCredential authCreds = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
      // (1) Verify sms
//      var authResult = await _auth.signInWithCredential(authCreds);
      // (2) Sign out since firebase creates another user
//      await _auth.signOut();
      // (3) Sign back in with previous authenticated method
      var authResult = await _auth.signInWithCredential(loginResult.credential);
      print("Successfully verified sms ${authResult.user}");
      return authResult.user;
    } catch (error) {
      print("Failed to verify sms $error");
      return null;
    }
  }

  Future<AuthType> refresh(FirebaseUser user) async {
    final QuerySnapshot result = await _db.collection('users').where('id', isEqualTo: user.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
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
          'gender': user.gender,
          'photo': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'email': firebaseUser.email,
          'mobile': user.mobile,
          'createdAt': DateTime.now(),
          'chattingWith': null
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

  LoginResult(this.user, this.authType, this.credential);
}
