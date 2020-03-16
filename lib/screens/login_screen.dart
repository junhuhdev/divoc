import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/common/text_field.dart';
import 'package:divoc/screens/home_screen.dart';
import 'package:divoc/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum FormType { login, register, phone_verification }

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = true;
  bool _rememberMe = false;
  AuthService authService = AuthService();

  String _email;
  String _password;
  String _phoneNumber;
  FormType _formType = FormType.phone_verification;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    authService.getCurrentUser.then((user) {
      if (user != null) {
        _isLoading = false;
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    });
    _isLoading = false;
  }

  Future<FirebaseUser> login() async {
    FirebaseUser user;
    try {
      user = await authService.signIn(_email, _password);
      print('Signed in: ${user.email}');
    } catch (e) {
      print('Error: $e');
    }
    return user;
  }

  Future<FirebaseUser> register() async {
    FirebaseUser user;
    try {
      user = await authService.signUp(_email, _password);
      print('Signed in: ${user.email}');
    } catch (e) {
      print('Error: $e');
    }
    return user;
  }

  Widget _rememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          var user = await login();
          if (user != null) {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          var user = await register();
          if (user != null) {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'REGISTER',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _socialButtonRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _socialButton(
            () async {
              setState(() {
                _isLoading = true;
              });
              LoginResult result = await authService.facebookSignIn();
              if (result != null && result.authType == AuthType.PHONE_VERIFICATION) {
                _isLoading = false;
                _formType = FormType.phone_verification;
              } else if (result != null) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pushReplacementNamed(context, HomeScreen.id);
              }
            },
            AssetImage(
              'assets/img/facebook.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }

    return new Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: kLinearGradient,
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (_formType == FormType.phone_verification) ...[
                        Text('Phone Verification', style: kLoginStyle),
                        SizedBox(height: 30.0),
                        PhoneNumberField(callback: (String val) => setState(() => _phoneNumber = val)),
                      ],
                      if (_formType == FormType.login) ...[
                        Text('Sign In', style: kLoginStyle),
                        SizedBox(height: 30.0),
                        EmailField(callback: (String val) => setState(() => _email = val)),
                        SizedBox(height: 30.0),
                        PasswordField(callback: (String val) => setState(() => _password = val)),
                        ForgottenPasswordButton(),
                        _rememberMeCheckbox(),
                        _loginButton(),
                        SocialLoginText(),
                        _socialButtonRow(),
                        RedirectRegisterButton(onTap: () => setState(() => _formType = FormType.register)),
                      ],
                      if (_formType == FormType.register) ...[
                        Text('Register', style: kLoginStyle),
                        SizedBox(height: 30.0),
                        EmailField(callback: (String val) => setState(() => _email = val)),
                        SizedBox(height: 30.0),
                        PasswordField(callback: (String val) => setState(() => _password = val)),
                        _registerButton(),
                        SocialLoginText(),
                        _socialButtonRow(),
                        RedirectLoginButton(onTap: () => setState(() => _formType = FormType.login)),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
