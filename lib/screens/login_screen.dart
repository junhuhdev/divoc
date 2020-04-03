import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/common/text_field.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/screens/home_screen.dart';
import 'package:divoc/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum FormType { login, register, phone_verification, collect_information }

enum ProvierType { email, facebook, apple, google }

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _email;
  String _password;
  String _mobile;
  String _name;
  DateTime _birthDate;
  String _gender;
  String _role = "Medhjälpare";
  ProvierType _provierType;
  SocialResult _socialResult;
  FormType _formType = FormType.login;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getCurrentUser.then((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    });
  }

  void redirectIfAuthenticated() {
    authService.getCurrentUser.then((user) {
      if (user != null) {
        _isLoading = false;
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    });
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
                FirebaseUser user = await authService.loginApple();
                if (user != null) {
                  redirectIfAuthenticated();
                }
              },
            ),
            SizedBox(height: 30.0),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SocialButton(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  _socialResult = await authService.loginFacebook();
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
                    redirectIfAuthenticated();
                  }
                },
                logo: AssetImage(
                  'assets/img/facebook.jpg',
                ),
              ),
//              SocialButton(
//                onTap: () async {
//                  setState(() {
//                    _isLoading = true;
//                  });
//                  _socialResult = await securityService.loginGoogle();
//                  if (_socialResult == null) {
//                    setState(() {
//                      _isLoading = false;
//                    });
//                  } else if (_socialResult.authType == AuthType.COLLECT_INFORMATION) {
//                    setState(() {
//                      _isLoading = false;
//                      _name = _socialResult.user.displayName;
//                      _provierType = ProvierType.google;
//                      _formType = FormType.collect_information;
//                    });
//                  } else {
//                    setState(() {
//                      _isLoading = false;
//                    });
//                    redirectIfAuthenticated();
//                  }
//                },
//                logo: AssetImage(
//                  'assets/img/google.jpg',
//                ),
//              ),
            ],
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
                                  var user = await authService.login(_email, _password);
                                  if (user != null) {
                                    redirectIfAuthenticated();
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
                          initialValue: _name,
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
                          title: 'Roll',
                          hint: 'Välj roll',
                          initialValue: _role,
                          icon: CommunityMaterialIcons.hospital,
                          options: User.USER_ROLES,
                          onChanged: (String val) => setState(() => _role = val),
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
                          onPressed: () async {
                            User newUser = User(
                              name: _name,
                              birthdate: _birthDate,
                              mobile: _mobile,
                              gender: _gender,
                              role: User.toRole(_role),
                            );
                            try {
                              if (_provierType == ProvierType.email) {
                                FirebaseUser createdUser = await authService.register(_email, _password, newUser);
                                if (createdUser == null) {
                                  Scaffold.of(context)
                                      .showSnackBar(SnackBar(content: Text('Kunde inte skapa användaren')));
                                } else {
                                  redirectIfAuthenticated();
                                }
                              } else {
                                FirebaseUser createdUser = await authService.registerSocial(_socialResult, newUser);
                                if (createdUser == null) {
                                  Scaffold.of(context)
                                      .showSnackBar(SnackBar(content: Text('Kunde inte skapa användaren')));
                                } else {
                                  redirectIfAuthenticated();
                                }
                              }
                            } on PlatformException catch (e) {
                              if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(content: Text('Email addressen är redan upptaget')));
                              }
                              if (e.code == "ERROR_INVALID_EMAIL") {
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(content: Text('Email addressen är inte giltig')));
                              }
                              if (e.code == "ERROR_WEAK_PASSWORD") {
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Lösenordet är för svagt')));
                              }
                            }
                          },
                        ),
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
