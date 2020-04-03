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
import 'package:divoc/services/utils.dart';

class CreateFeed extends StatefulWidget {
  @override
  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  String _name;
  String _mobile;
  String _description;
  String _shoppingInfo;
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
                  GenericCleanTextContainer(
                    title: 'Namn',
                    icon: Icons.person,
                    content: user.name,
                  ),
                  SizedBox(height: 30.0),
                  GenericTextField(
                    title: 'Mobil nummer (syns endast för leverantör)',
                    hint: 'Skriv in ditt mobil nummer',
                    icon: Icons.phone,
                    initialValue: user.mobile,
                    textInputType: TextInputType.phone,
                    onChanged: (String val) => setState(() => _mobile = val),
                  ),
                  SizedBox(height: 30.0),
                  GenericTextField(
                    title: 'Beskrivning',
                    hint: 'Skriv in detaljerad beskrivning',
                    height: 100.0,
                    maxLines: 5,
                    icon: Icons.comment,
                    textInputType: TextInputType.multiline,
                    onChanged: (String val) => setState(() => _description = val),
                  ),
                  SizedBox(height: 30.0),
                  GenericTextField(
                    title: 'Inköpslista (syns endast för leverantör)',
                    hint: 'Skriv in detaljerad inköpslista',
                    height: 100.0,
                    maxLines: 5,
                    icon: Icons.shopping_cart,
                    textInputType: TextInputType.multiline,
                    onChanged: (String val) => setState(() => _shoppingInfo = val),
                  ),
                  SizedBox(height: 30.0),
                  GenericTextField(
                    title: 'Leverans uppgifter (syns endast för leverantör)',
                    hint: 'Skriv in detaljerad leverans information som portkod och våning',
                    height: 100.0,
                    maxLines: 5,
                    icon: Icons.local_shipping,
                    textInputType: TextInputType.multiline,
                    onChanged: (String val) => setState(() => _deliveryInfo = val),
                  ),
                  SizedBox(height: 30.0),
                  GenericGoogleMapField(
                    title: 'Leverans adress (syns endast för leverantör)',
                    hint: 'Fyll i exakt adress för leverans adressen',
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
                          } else if (_shoppingInfo.isNullOrEmpty) {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Fyll i inköpslista')));
                          } else if (_description.isNullOrEmpty) {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Fyll i beskrivning')));
                          } else if (_mobile.isNullOrEmpty && user.mobile.isNullOrEmpty) {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Fyll i mobil nummer')));
                          } else if (_formKey.currentState.validate()) {
                            await Global.feedCollection.insert(
                              ({
                                'ownerId': user.id,
                                'name': user.name,
                                'mobile': _mobile ?? user.mobile,
                                'gender': user.gender,
                                'age': user.age,
                                'image': user.photo,
                                'description': _description,
                                'shoppingInfo': _shoppingInfo,
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
