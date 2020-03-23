import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

class FormContainer extends StatelessWidget {
  final List<Widget> children;
  final double horizontal;
  final double vertical;
  final VoidCallback onTap;

  const FormContainer({
    this.children,
    this.horizontal: 40.0,
    this.vertical: 50.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () {
          if (onTap == null) {
            FocusScope.of(context).unfocus();
          } else {
            FocusScope.of(context).unfocus();
            onTap();
          }
        },
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
                padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
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
