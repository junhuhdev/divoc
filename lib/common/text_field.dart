import 'package:flutter/material.dart';

import 'constants.dart';

class SocialLoginText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '- ELLER -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Logga in med',
          style: kLabelStyle,
        ),
      ],
    );
  }
}
