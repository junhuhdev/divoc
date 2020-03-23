import 'package:flutter/material.dart';

const kMainColor = Color(0xff465466);

const kBackgroundColor = Color.fromRGBO(58, 66, 86, 1.0);

const kCardColor = Color.fromRGBO(64, 75, 96, .9);

final kTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
);

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF8542e3),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kLinearGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF8542e3),
      Color(0xFF722ed1),
      Color(0xFF6211d4),
      Color(0xFF6415d4),
    ],
    stops: [0.1, 0.4, 0.7, 0.9],
  ),
);

final kLoginStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
);

final kLoginActionButtonStyle = TextStyle(
  color: Color(0xFF527DAA),
  letterSpacing: 1.5,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kEmailInputDecoration = InputDecoration(
  border: InputBorder.none,
  contentPadding: EdgeInsets.only(top: 14.0),
  prefixIcon: Icon(
    Icons.email,
    color: Colors.white,
  ),
  hintText: 'Enter your Email',
  hintStyle: kHintTextStyle,
);

final kPhoneInputDecoration = InputDecoration(
  border: InputBorder.none,
  contentPadding: EdgeInsets.only(top: 14.0),
  prefixIcon: Icon(
    Icons.phone,
    color: Colors.white,
  ),
  hintText: 'Enter your Phone number',
  hintStyle: kHintTextStyle,
);

final kSmsCodeInputDecoration = InputDecoration(
  border: InputBorder.none,
  contentPadding: EdgeInsets.only(top: 14.0),
  prefixIcon: Icon(
    Icons.sms,
    color: Colors.white,
  ),
  hintText: 'Enter your Code',
  hintStyle: kHintTextStyle,
);

final kPasswordInputDecoration = InputDecoration(
  border: InputBorder.none,
  contentPadding: EdgeInsets.only(top: 14.0),
  prefixIcon: Icon(
    Icons.lock,
    color: Colors.white,
  ),
  hintText: 'Enter your Password',
  hintStyle: kHintTextStyle,
);

double getProgressStatus(String status) {
  if (status == 'created') {
    return 0.20;
  }
  if (status == 'pending') {
    return 0.50;
  }
  return 1;
}

Color getColorStatus(String status) {
  if (status == 'created') {
    return Colors.red;
  }
  if (status == 'pending') {
    return Colors.amber;
  }
  return Colors.green;
}
