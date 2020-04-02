import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/services/security_service.dart';
import 'package:flutter/material.dart';
import 'package:divoc/services/utils.dart';

class ForgottenPasswordScreen extends StatefulWidget {
  @override
  _ForgottenPasswordScreenState createState() => _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  String _email;
  SecurityService securityService = SecurityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(''),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return FormContainer(
            children: <Widget>[
              Text('Återställ lösenordet', style: kLoginStyle),
              SizedBox(height: 30.0),
              EmailField(callback: (String val) => setState(() => _email = val)),
              ActionButton(
                title: 'Skicka',
                onPressed: () async {
                  if (_email.isNullOrEmpty) {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Fyll i e-postadress')));
                    return;
                  }
                  securityService.sendPasswordResetEmail(_email);
                  Navigator.pop(context, 'Skickat återställnings mail');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
