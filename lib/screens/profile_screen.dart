import 'package:cached_network_image/cached_network_image.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(user.photo),
                          radius: 120.0,
                        ),
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        initialValue: user.name,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.person, color: Colors.white),
                          labelText: 'Name',
                          hintText: 'Name...',
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
                          hintText: 'Name...',
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
                          labelText: 'Phonenumber',
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
                          labelText: 'Birthday',
                          hintText: 'Name...',
                        ),
                        onTap: () {
                          selectDate(context);
                        },
                      ),
                      DropdownButtonFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.sentiment_satisfied, color: Colors.white),
                          labelText: 'Gender',
                          hintText: 'Select your gender',
                        ),
                        value: _gender ?? user.gender,
                        isExpanded: true,
                        isDense: true,
                        items: ['MALE', 'FEMALE'].map((val) {
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
                          'Save Changes',
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
                          'Delete Account',
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
