import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/images.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/globals.dart';
import 'package:divoc/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:divoc/services/utils.dart';

class ProfileScreen extends StatefulWidget {
  static const title = "Profil";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  String _name;
  String _email;
  String _phoneNumber;
  String _gender;
  DateTime _birthdate = DateTime(DateTime.now().year - 29, DateTime.now().month, DateTime.now().day);
  ImageService imageService = new ImageService();
  var _genderOptions = ['Man', 'Kvinna', 'Okänd'];

  Future selectDate(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _birthdate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthdate) {
      setState(() {
        _birthdate = picked;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    }

    return Consumer<User>(
      builder: (context, user, child) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Card(
              child: Container(
                decoration: BoxDecoration(color: kCardColor),
                padding: EdgeInsets.all(35.0),
                child: ListView(
                  children: <Widget>[
                    if (user != null) ...[
                      Stack(
                        children: <Widget>[
                          Center(child: UserProfileImage(image: user.photo)),
                          Positioned(
                            right: 0.0,
                            bottom: 0.0,
                            child: SizedBox(
                              height: 30.0,
                              width: 30.0,
                              child: FloatingActionButton(
                                heroTag: null,
                                mini: true,
                                elevation: 2.0,
                                child: user.photo.isNullEmptyOrWhitespace
                                    ? const Icon(Icons.add, size: 20.0)
                                    : const Icon(Icons.close, size: 20.0, color: Colors.red),
                                backgroundColor: user.photo.isNullEmptyOrWhitespace ? Colors.red : Colors.white,
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (user.photo.isNullEmptyOrWhitespace) {
                                    await imageService.uploadImage(user.id);
                                  } else {
                                    await imageService.deleteImage(user.id);
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        initialValue: user.name,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.person, color: Colors.white),
                          labelText: 'Namn',
                          hintText: 'Förnamn och efternamn',
                        ),
                        onChanged: (val) {
                          _name = val;
                        },
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        initialValue: user.email,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.email, color: Colors.white),
                          labelText: 'Email address',
                          hintText: 'example@gmail.com',
                        ),
                        onChanged: (val) {
                          _email = val;
                        },
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        enabled: false,
                        initialValue: user.mobile,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.phone, color: Colors.white),
                          labelText: 'Mobil nummer',
                          hintText: '+46...',
                        ),
                        onChanged: (val) {},
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        initialValue: '${user.birthdate.toLocal()}'.split(' ')[0],
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.calendar_today, color: Colors.white),
                          labelText: 'Födelsedatum',
                          hintText: '1991-01-05',
                        ),
                        onTap: () {
                          selectDate(context);
                        },
                      ),
                      DropdownButtonFormField(
                        style: TextStyle(color: Colors.black),
                        selectedItemBuilder: (BuildContext context) {
                          return _genderOptions.map((String value) {
                            return Text(
                              _gender == null ? user.gender : _gender,
                              style: TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.sentiment_satisfied, color: Colors.white),
                          labelText: 'Kön',
                          hintText: 'Välj ditt kön',
                        ),
                        value: _gender ?? user.gender,
                        isExpanded: true,
                        isDense: true,
                        items: _genderOptions.map((val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _gender = val;
                          });
                        },
                      ),
                      SizedBox(height: 40.0),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          'Spara Ändringar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await Global.userDoc.upsert(
                            ({
                              'name': _name ?? user.name,
                              'email': _email ?? user.email,
                            }),
                          );
                        },
                      ),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Radera Konto',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                    ],
                    if (user == null) ...[
                      Container(),
                    ]
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
