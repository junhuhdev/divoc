import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/common/text_field.dart';
import 'package:divoc/screens/home_screen.dart';
import 'package:divoc/services/auth_service.dart';
import 'package:divoc/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum FormType { login, register, phone_verification, collect_information }

/// Login or Register
/// Register
/// (1) name
/// (2) birthdate
/// (3) gender
class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = true;
  String _email;
  String _password;
  String _phoneNumber;
  String _verificationId;
  String _smsCode;
  String _name;
  DateTime _birthDate;
  String _gender;

  bool _codeSent = false;
  LoginResult _result;
  FormType _formType = FormType.login;
  AuthService authService = AuthService();
  UserService userService = UserService();

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
      child: ActionButton(
        title: 'Login',
        onPressed: () async {
          var user = await authService.signIn(_email, _password);
          if (user != null) {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
        },
      ),
    );
  }

  Widget _smsVerifyButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Builder(
        builder: (BuildContext context) {
          return ActionButton(
            title: _codeSent ? 'Verify' : 'Send Code',
            onPressed: () async {
              if (!_codeSent) {
                /// (1) Send sms verification code
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
              if (_codeSent) {
                /// (2) Verify sms code
                var user = await authService.verifySmsCode(_verificationId, _smsCode);
                if (user == null) {
                  final snackBar = SnackBar(content: Text('Invalid Code'));
                  Scaffold.of(context).showSnackBar(snackBar);
                } else {
                  await authService.updateNewUser(_result, _phoneNumber);
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              }
            },
          );
        },
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ActionButton(
        title: 'Register',
        onPressed: () async {
          var user = await authService.signUp(_email, _password);
          if (user != null) {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
        },
      ),
    );
  }

  Widget _socialButtonRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SocialButton(
            onTap: () async {
              setState(() {
                _isLoading = true;
              });
              _result = await authService.facebookSignIn();
              if (_result != null && _result.authType == AuthType.COLLECT_INFORMATION) {
                setState(() {
                  _isLoading = false;
                  _formType = FormType.collect_information;
                });
              } else if (_result != null) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pushReplacementNamed(context, HomeScreen.id);
              }
            },
            logo: AssetImage(
              'assets/img/facebook.jpg',
            ),
          ),
        ],
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
                      if (_formType == FormType.collect_information) ...[
                        Text('Complete Registration', style: kLoginStyle),
                        SizedBox(height: 30.0),
                        GenericTextField(
                          title: 'Name',
                          hint: 'Enter Your Full Name',
                          icon: Icons.person,
                          textInputType: TextInputType.text,
                          onChanged: (String val) => setState(() => _name = val),
                        ),
                        SizedBox(height: 30.0),

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
