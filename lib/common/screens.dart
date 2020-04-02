import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/components/phoneinput/international_phone_input.dart';
import 'package:divoc/services/globals.dart';
import 'package:divoc/services/security_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:divoc/services/utils.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MobileVerifyScreen extends StatefulWidget {
  final Function(String) onSelected;

  const MobileVerifyScreen({this.onSelected});

  @override
  _MobileVerifyScreenState createState() => _MobileVerifyScreenState();
}

class _MobileVerifyScreenState extends State<MobileVerifyScreen> {
  String _mobile;
  bool _codeSent = false;
  bool _isVerified = false;
  String _verificationId;
  String _smsCode;
  String _buttonTitle = 'Skicka Sms Kod';
  AuthCredential _authCredential;
  SecurityService securityService = SecurityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Mobil Verifiering'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return FormContainer(
            children: <Widget>[
              Text('Mobil Verifiering', style: kLoginStyle),
              SizedBox(height: 30.0),
              InternationalPhoneInput(
                onPhoneNumberChange: (String number, String internationalizedPhoneNumber, String isoCode) {
                  setState(() {
                    _mobile = internationalizedPhoneNumber;
                  });
                },
                initialPhoneNumber: _mobile,
                initialSelection: '+46',
                enabledCountries: ['+46', '+47', '+45', '+358'],
              ),
              if (_codeSent) ...[
                SmsCodeField(callback: (String val) => setState(() => _smsCode = val)),
              ],
              if (!_codeSent) ...[
                Container(),
              ],
              _smsVerifyButton(),
            ],
          );
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
            title: _buttonTitle,
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (!_codeSent) {
                /// (1) Send sms verification code
                final PhoneVerificationCompleted verified = (AuthCredential authCredential) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Verifiering godkänd')));
                  this._authCredential = authCredential;
                  _auth.currentUser().then((user) {
                    try {
                      user.linkWithCredential(_authCredential);
                      widget.onSelected(_mobile);
                      Navigator.pop(context);
                    } catch (error) {
                      print("Verification failed $error");
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Verifieringen gick fel')));
                    }
                  });
                };

                final PhoneVerificationFailed verificationfailed = (AuthException authException) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Felaktig verifierings kod')));
                  print('${authException.message}');
                };

                final PhoneCodeSent codeSent = (String verId, [int forceResend]) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Skickat sms-kod var god dröj...')));
                  this._verificationId = verId;
                  setState(() {
                    this._buttonTitle = 'Verifiera';
                    this._codeSent = true;
                  });
                };

                final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verificationId) {
                  this._verificationId = verificationId;
                };

                await _auth.verifyPhoneNumber(
                    phoneNumber: _mobile,
                    timeout: const Duration(seconds: 5),
                    verificationCompleted: verified,
                    verificationFailed: verificationfailed,
                    codeSent: codeSent,
                    codeAutoRetrievalTimeout: autoTimeout);
              }
              if (_codeSent && !_verificationId.isNullOrEmpty && !_smsCode.isNullOrEmpty) {
                try {
                  await linkUserWithMobile(context);
                } on PlatformException catch (e) {
                  FirebaseUser user = await _auth.currentUser();
                  if (user != null) {
                    await user.unlinkFromProvider(PhoneAuthProvider.providerId);
                    await linkUserWithMobile(context);
                    return;
                  }
                } catch (error) {
                  print("Verification failed $error");
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Verifieringen gick fel')));
                }
              }
            },
          );
        },
      ),
    );
  }

  Future<void> linkUserWithMobile(BuildContext context) async {
    try {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        AuthCredential authCreds = PhoneAuthProvider.getCredential(verificationId: _verificationId, smsCode: _smsCode);
        AuthResult authResult = await user.linkWithCredential(authCreds);
        if (authResult != null) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Verifiering lyckades')));
          await Global.userDoc.upsert(
            ({
              'mobile': _mobile,
            }),
          );
          widget.onSelected(_mobile);
          Navigator.pop(context);
        }
      }
    } on PlatformException catch (e) {
      print("error $e");
      if (e.code == "ERROR_INVALID_VERIFICATION_CODE") {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Felaktig verifierings kod')));
        return;
      }
      throw e;
    }
  }
}
