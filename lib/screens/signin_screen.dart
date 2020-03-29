import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/common/text_field.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/screens/home_screen.dart';
import 'package:divoc/services/security_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

enum FormType { login, register, phone_verification, collect_information }

enum ProvierType { email, facebook, apple, google }

class _SigninScreenState extends State<SigninScreen> {
  bool _isLoading = true;
  String _email;
  String _password;
  String _mobile;
  String _verificationId;
  String _smsCode;
  String _name;
  DateTime _birthDate;
  String _gender;
  ProvierType _provierType;
  bool _codeSent = false;
  SocialResult _socialResult;
  FormType _formType = FormType.login;
  SecurityService securityService = SecurityService();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    securityService.getCurrentUser.then((user) {
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
                    phoneNumber: _mobile,
                    timeout: const Duration(seconds: 60),
                    verificationCompleted: verified,
                    verificationFailed: verificationfailed,
                    codeSent: smsSent,
                    codeAutoRetrievalTimeout: autoTimeout);
              }
              if (_codeSent) {
                /// (2) Verify sms code
                FirebaseUser user = await securityService.verifySmsCode(_verificationId, _smsCode, _socialResult);
                if (user == null) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Felaktig kod')));
                } else {
                  if (_provierType == ProvierType.email) {
                    User newUser = User(
                      name: _name,
                      birthdate: _birthDate,
                      mobile: _mobile,
                      gender: _gender,
                    );
                    FirebaseUser createdUser = await securityService.register(_email, _password, newUser);
                    if (createdUser == null) {
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Kunde inte skapa användaren')));
                    }
                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                  }
                  User newUser = User(
                    name: _name,
                    birthdate: _birthDate,
                    mobile: _mobile,
                    gender: _gender,
                  );
                  FirebaseUser createdUser = await securityService.registerSocial(_socialResult, newUser);
                  if (createdUser == null) {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Kunde inte skapa användaren')));
                  }
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              }
            },
          );
        },
      ),
    );
  }

  Widget _socialOptions(BuildContext context) {
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
                FirebaseUser user = await securityService.loginApple();
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
              _socialResult = await securityService.loginFacebook();
              if (_socialResult == null) {
                setState(() {
                  _isLoading = false;
                });
              } else if (_socialResult.authType == AuthType.COLLECT_INFORMATION) {
                setState(() {
                  _isLoading = false;
                  _name = _socialResult.user.displayName;
                  _provierType = ProvierType.facebook;
                  _formType = FormType.collect_information;
                });
              } else {
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
                        Text('Logga in', style: kLoginStyle),
                        SizedBox(height: 30.0),
                        EmailField(callback: (String val) => setState(() => _email = val)),
                        SizedBox(height: 30.0),
                        PasswordField(callback: (String val) => setState(() => _password = val)),
                        ForgottenPasswordButton(),
                        Builder(
                          builder: (BuildContext context) {
                            return ActionButton(
                              title: 'Logga in',
                              onPressed: () async {
                                if (_email == null || _password == null) {
                                  Scaffold.of(context)
                                      .showSnackBar(SnackBar(content: Text('Skriv in dina inloggningsuppgifter')));
                                } else {
                                  var user = await securityService.login(_email, _password);
                                  if (user != null) {
                                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Felaktigt Lösenord')));
                                  }
                                }
                              },
                            );
                          },
                        ),
                        SocialLoginText(),
                        _socialOptions(context),
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
                              _provierType = ProvierType.email;
                              _formType = FormType.collect_information;
                            });
                          },
                        ),
                        SocialLoginText(),
                        _socialOptions(context),
                        RedirectLoginButton(onTap: () => setState(() => _formType = FormType.login)),
                      ],
                      if (_formType == FormType.collect_information) ...[
                        Text('Slutför Registrering', style: kLoginStyle),
                        SizedBox(height: 30.0),
                        GenericTextField(
                          title: 'Namn',
                          hint: 'Förnamn och efternamn',
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
                          icon: CommunityMaterialIcons.gender_male_female,
                          options: ['Man', 'Kvinna', 'Annat'],
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
                        PhoneNumberField(callback: (String val) => setState(() => _mobile = val)),
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
