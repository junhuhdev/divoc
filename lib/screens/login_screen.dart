import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/common/text_field.dart';
import 'package:divoc/models/user.dart';
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
  String _gender = "Man";

  bool _codeSent = false;
  LoginResult _loginResult;
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

  Widget _smsVerifyButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Builder(
        builder: (BuildContext context) {
          return ActionButton(
            title: _codeSent ? 'Verifiera' : 'Skicka Sms Kod',
            onPressed: () async {
              FocusScope.of(context).unfocus();
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
                var user = await authService.verifySmsCode(_verificationId, _smsCode, _loginResult);
                if (user == null) {
                  final snackBar = SnackBar(content: Text('Invalid Code'));
                  Scaffold.of(context).showSnackBar(snackBar);
                } else {
                  await authService.updateNewUser(
                    _loginResult,
                    User(
                      name: _name,
                      mobile: _phoneNumber,
                      birthdate: _birthDate,
                      gender: _gender,
                    ),
                  );
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              }
            },
          );
        },
      ),
    );
  }

  Widget _socialButtonRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (Theme.of(context).platform == TargetPlatform.iOS) ...[
            AppleSignInButton(
              style: ButtonStyle.white,
              type: ButtonType.continueButton,
              onPressed: () async {
                FirebaseUser user = await authService.appleSignIn();
                if (user != null) {
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              },
            ),
            SizedBox(height: 30.0),
          ],
          SocialButton(
            onTap: () async {
              setState(() {
                _isLoading = true;
              });
              _loginResult = await authService.facebookSignIn();
              if (_loginResult != null && _loginResult.authType == AuthType.COLLECT_INFORMATION) {
                setState(() {
                  _isLoading = false;
                  _formType = FormType.collect_information;
                });
              } else if (_loginResult != null) {
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
                        Builder(
                          builder: (BuildContext context) {
                            return ActionButton(
                              title: 'Login',
                              onPressed: () async {
                                if (_email == null || _password == null) {
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter Credentials')));
                                } else {
                                  var user = await authService.signIn(_email, _password);
                                  if (user != null) {
                                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Invalid Password')));
                                  }
                                }
                              },
                            );
                          },
                        ),
                        SocialLoginText(),
                        _socialButtonRow(context),
                        RedirectRegisterButton(onTap: () => setState(() => _formType = FormType.register)),
                      ],
                      if (_formType == FormType.register) ...[
                        Text('Registrera', style: kLoginStyle),
                        SizedBox(height: 30.0),
                        EmailField(callback: (String val) => setState(() => _email = val)),
                        SizedBox(height: 30.0),
                        PasswordField(callback: (String val) => setState(() => _password = val)),
                        ActionButton(
                          title: 'Registrera',
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            _loginResult = await authService.signUp(_email, _password);
                            if (_loginResult != null && _loginResult.authType == AuthType.COLLECT_INFORMATION) {
                              setState(() {
                                _isLoading = false;
                                _formType = FormType.collect_information;
                              });
                            } else if (_loginResult != null) {
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.pushReplacementNamed(context, HomeScreen.id);
                            }
                          },
                        ),
                        SocialLoginText(),
                        _socialButtonRow(context),
                        RedirectLoginButton(onTap: () => setState(() => _formType = FormType.login)),
                      ],
                      if (_formType == FormType.collect_information) ...[
                        Text('Slutför Registrering', style: kLoginStyle),
                        SizedBox(height: 30.0),
                        GenericTextField(
                          title: 'Namn',
                          hint: 'Skriv in ditt förnamn och efternamn',
                          icon: Icons.person,
                          textInputType: TextInputType.text,
                          onChanged: (String val) => setState(() => _name = val),
                        ),
                        SizedBox(height: 30.0),
                        GenericDateField(
                          title: 'Födelsedatum',
                          hint: 'Välj ditt födelsedatum',
                          onChanged: (DateTime val) {
                            setState(() {
                              _birthDate = val;
                            });
                          },
                        ),
                        SizedBox(height: 30.0),
                        GenericDropdownField(
                          title: 'Kön',
                          hint: 'Välj ditt kön',
                          icon: Icons.sentiment_satisfied,
                          options: ['Man', 'Kvinna', 'Okänd'],
                          onChanged: (String val) => setState(() => _gender = val),
                        ),
                        ActionButton(
                          title: 'Slutför',
                          onPressed: () {
                            setState(() {
                              _formType = FormType.phone_verification;
                            });
                          },
                        ),
                      ],
                      if (_formType == FormType.phone_verification) ...[
                        Text('Mobil Verifiering', style: kLoginStyle),
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
