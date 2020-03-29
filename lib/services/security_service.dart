import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/globals.dart';
import 'package:divoc/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SecurityService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookAuth = FacebookLogin();
  final Firestore _db = Firestore.instance;
  final UserService _userService = UserService();

  Future<FirebaseUser> get getCurrentUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> register(String email, String password, User user) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser firebaseUser = result.user;
      await _db.collection('users').document(user.id).setData(
        {
          'id': firebaseUser.uid,
          'email': email,
          'name': user.name,
          'birthdate': user.birthdate,
          'age': user.getAge,
          'gender': user.gender ?? 'Annat',
          'photo': user.photo,
          'mobile': user.mobile ?? firebaseUser.photoUrl,
          'provider': LoginProvider.email,
          'createdAt': DateTime.now(),
        },
      );
      return firebaseUser;
    } catch (error) {
      print("Failed to create user $error");
      return null;
    }
  }

  Future<FirebaseUser> registerSocial(SocialResult socialResult, User user) async {
    await _auth.signInWithCredential(socialResult.credential);
    final FirebaseUser firebaseUser = socialResult.user;
    final QuerySnapshot result = await _db.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      // (1) Create new user
      _db.collection('users').document(firebaseUser.uid).setData(
        {
          'id': firebaseUser.uid,
          'email': firebaseUser.email,
          'name': user.name,
          'birthdate': user.birthdate,
          'age': user.getAge,
          'gender': user.gender ?? 'Annat',
          'photo': socialResult.photo ?? firebaseUser.photoUrl,
          'mobile': user.mobile,
          'provider': socialResult.provider,
          'createdAt': DateTime.now(),
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
    return firebaseUser;
  }

  Future<FirebaseUser> login(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (error) {
      print("Failed to sign in user $error");
      return null;
    }
  }

  Future<FirebaseUser> loginApple() async {
    AuthResult authResult;
    AuthCredential credential;
    AppleIdCredential appleIdCredential;
    try {
      bool isAvailable = await AppleSignIn.isAvailable();
      if (isAvailable) {
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
            print("Apple - Error: ${result.error.localizedDescription}");
            break;
          case AuthorizationStatus.cancelled:
            print('Apple - Cancelled');
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
              'id': user.uid,
              'name': '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}',
              'email': appleIdCredential.email,
              'gender': 'Annat',
              'provider': LoginProvider.apple,
              'createdAt': DateTime.now(),
            },
          );
          print("New apple user created");
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

  Future<SocialResult> loginFacebook() async {
    AuthCredential credentials;
    String token;
    String photo;
    try {
      final FacebookLoginResult loginResult = await _facebookAuth.logIn(['email', 'public_profile']);
      AuthResult authResult;
      switch (loginResult.status) {
        case FacebookLoginStatus.loggedIn:
          token = loginResult.accessToken.token;
          credentials = FacebookAuthProvider.getCredential(accessToken: token);
          authResult = await _auth.signInWithCredential(credentials);
          break;
        case FacebookLoginStatus.cancelledByUser:
          print("Facebook sign in cancelled by user");
          return null;
        case FacebookLoginStatus.error:
          print("Facebook sign in failed");
          return null;
      }
      FirebaseUser user = authResult.user;
      AuthType authType = await verifyStatus(user);
      if (authType == AuthType.COLLECT_INFORMATION) {
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(800).height(800)&access_token=$token');
        var profile = convert.jsonDecode(graphResponse.body);
        photo = profile['picture']['data']['url'];
      }
      return SocialResult(
        user: user,
        authType: authType,
        credential: credentials,
        provider: LoginProvider.facebook,
        photo: photo,
      );
    } catch (error) {
      print("Facebook login error $error");
      return null;
    }
  }

  Future<FirebaseUser> verifySmsCode(String verificationId, String smsCode, SocialResult loginResult) async {
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

  Future<AuthType> verifyStatus(FirebaseUser user) async {
    final QuerySnapshot result = await _db.collection('users').where('id', isEqualTo: user.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      /// Logout user because we need to collect more info
      await _auth.signOut();
      return AuthType.COLLECT_INFORMATION;
    }
    return AuthType.SUCCESS;
  }

  Future<void> logout() async {
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

class SocialResult {
  final FirebaseUser user;
  final AuthType authType;
  final AuthCredential credential;
  final String provider;
  final String photo;

  SocialResult({
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
