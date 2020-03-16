import 'package:flutter/material.dart';

import 'constants.dart';

class EmailField extends StatelessWidget {
  final Function(String) callback;

  const EmailField({this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: kEmailInputDecoration,
            onChanged: (val) {
              callback(val);
            },
          ),
        ),
      ],
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  final Function(String) callback;

  const PhoneNumberField({this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone number',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: kPhoneInputDecoration,
            onChanged: (val) {
              callback(val);
            },
          ),
        ),
      ],
    );
  }
}

class SmsCodeField extends StatelessWidget {
  final Function(String) callback;

  const SmsCodeField({this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Code',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: kSmsCodeInputDecoration,
            onChanged: (val) {
              callback(val);
            },
          ),
        ),
      ],
    );
  }
}

class PasswordField extends StatelessWidget {
  final Function(String) callback;

  const PasswordField({this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: kPasswordInputDecoration,
            onChanged: (val) {
              callback(val);
            },
          ),
        ),
      ],
    );
  }
}
