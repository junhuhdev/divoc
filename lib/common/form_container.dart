import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

class FormContainer extends StatelessWidget {
  final List<Widget> children;

  const FormContainer({this.children});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
