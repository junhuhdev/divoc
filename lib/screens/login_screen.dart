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

enum FormType { login, register, phone_verification, finalize_registration }

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = true;
  String _email;
  String _password;
  String _phoneNumber;
  String _verificationId;
  String _smsCode;
  bool _codeSent = false;
  LoginResult _result;
  FormType _formType = FormType.login;
  AuthService authService = AuthService();

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

  Widget _loginButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          var user = await authService.signIn(_email, _password);
          if (user != null) {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text('LOGIN', style: kLoginActionButtonStyle),
      ),
    );
  }

  Widget _smsVerifyButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Builder(builder: (BuildContext context) {
        return RaisedButton(
          elevation: 5.0,
          onPressed: () async {
            if (_codeSent) {
              var user = await authService.verifySmsCode(_verificationId, _smsCode);
              if (user == null) {
                final snackBar = SnackBar(content: Text('Invalid Code'));
                Scaffold.of(context).showSnackBar(snackBar);
              } else {
                await authService.updateNewUser(_result, _phoneNumber);
                Navigator.pushReplacementNamed(context, HomeScreen.id);
              }
            } else {
              final PhoneVerificationCompleted verified = (AuthCredential authResult) {
                FirebaseAuth.instance.signInWithCredential(authResult);
              };

              final PhoneVerificationFailed verificationfailed = (AuthException authException) {
                print('${authException.message}');
              };

              final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
                this._verificationId = verId;
                setState(() {
                  this._codeSent = true;
                });
              };

              final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
                this._verificationId = verId;
              };

              await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: _phoneNumber,
                  timeout: const Duration(seconds: 60),
                  verificationCompleted: verified,
                  verificationFailed: verificationfailed,
                  codeSent: smsSent,
                  codeAutoRetrievalTimeout: autoTimeout);
            }
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white,
          child: Text(_codeSent ? 'Verify' : 'Send Code', style: kLoginActionButtonStyle),
        );
      }),
    );
  }

  Widget _registerButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          var user = await authService.signUp(_email, _password);
          if (user != null) {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text('REGISTER', style: kLoginActionButtonStyle),
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
              _result = await authService.facebookSignIn();
              if (_result != null && _result.authType == AuthType.PHONE_VERIFICATION) {
                setState(() {
                  _isLoading = false;
                  _formType = FormType.phone_verification;
                });
              } else if (_result != null) {
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
                      if (_formType == FormType.login) ...[
                        Text('Sign In', style: kLoginStyle),
                        SizedBox(height: 30.0),
                        EmailField(callback: (String val) => setState(() => _email = val)),
                        SizedBox(height: 30.0),
                        PasswordField(callback: (String val) => setState(() => _password = val)),
                        ForgottenPasswordButton(),
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
                      ],
                      if (_formType == FormType.phone_verification) ...[
                        Text('Phone Verification', style: kLoginStyle),
                        SizedBox(height: 30.0),
                        PhoneNumberField(callback: (String val) => setState(() => _phoneNumber = val)),
                        SizedBox(height: 30.0),
                        _codeSent
                            ? SmsCodeField(callback: (String val) => setState(() => _smsCode = val))
                            : Container(),
                        _smsVerifyButton(),
                      ],
                      if (_formType == FormType.finalize_registration) ...[
                        Text('Complete Registration', style: kLoginStyle),
                        SizedBox(height: 30.0),
                      ],
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
