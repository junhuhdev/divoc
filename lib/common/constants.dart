import 'package:flutter/material.dart';

const kMainColor = Color(0xff465466);

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