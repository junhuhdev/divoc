import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/address.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateFeed extends StatefulWidget {
  @override
  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  String _name;
  String _mobile;
  String _description;
  String _deliveryInfo;
  Address _address;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }
    return Consumer<User>(
      builder: (context, user, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Skapa ny förfrågan'),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: FormContainer(
              children: <Widget>[
                if (user != null) ...[
                  GenericTextField(
                    title: 'Namn',
                    hint: 'Skriv in ditt namn',
                    icon: Icons.person,
                    initialValue: user.name,
                    textInputType: TextInputType.text,
                    onChanged: (String val) => setState(() => _name = val),
                    validator: (val) => val.isEmpty ? "Please enter a valid name" : null,
                  ),
                  SizedBox(height: 30.0),
                  GenericTextField(
                    title: 'Mobil Nummer',
                    hint: 'Skriv in ditt mobil nummer',
                    icon: Icons.phone,
                    initialValue: user.mobile,
                    textInputType: TextInputType.phone,
                    onChanged: (String val) => setState(() => _mobile = val),
                  ),
                  SizedBox(height: 30.0),
                  GenericTextField(
                    title: 'Beskrivning och inköpslista',
                    hint: 'Skriv in detaljerad beskrivning och inköpslista',
                    height: 100.0,
                    maxLines: 5,
                    icon: Icons.comment,
                    textInputType: TextInputType.multiline,
                    onChanged: (String val) => setState(() => _description = val),
                  ),
                  SizedBox(height: 30.0),
                  GenericTextField(
                    title: 'Leverans information',
                    hint: 'Skriv in detaljerad leverans information som portkod och våning',
                    height: 100.0,
                    maxLines: 5,
                    icon: Icons.local_shipping,
                    textInputType: TextInputType.multiline,
                    onChanged: (String val) => setState(() => _deliveryInfo = val),
                  ),
                  SizedBox(height: 30.0),
                  GenericGoogleMapField(
                    title: 'Plats',
                    hint: 'Välj plats',
                    onSelected: (Address address) {
                      _address = address;
                    },
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      return ActionButton(
                        title: 'SKAPA',
                        onPressed: () async {
                          if (_address == null) {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Välj en giltig address')));
                          } else if (_formKey.currentState.validate()) {
                            await Global.feedCollection.insert(
                              ({
                                'ownerId': user.id,
                                'name': _name ?? user.name,
                                'mobile': _mobile ?? user.mobile,
                                'gender': user.gender,
                                'age': user.age,
                                'image': user.photo,
                                'description': _description,
                                'deliveryInfo': _deliveryInfo,
                                'finalized': false,
                                'city': _address.city,
                                'state': _address.state,
                                'street': _address.street,
                                'postalCode': _address.postalCode,
                                'geolocation': GeoPoint(_address.geolocation.latitude, _address.geolocation.longitude),
                                'status': "created",
                                'created': DateTime.now(),
                              }),
                            );
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  ),
                ],
                if (user == null) ...[
                  Container(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
