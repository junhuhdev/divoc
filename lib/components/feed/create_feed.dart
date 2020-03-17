import 'package:divoc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateFeed extends StatefulWidget {
  @override
  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  String _gender = 'Male';
  String _age = "18";
  String _description;
  String _mobile;
  String _category = "Food";

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Create New Event'),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(35.0),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: user.mobile,
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    labelText: 'Phonenumber',
                    hintText: '+46...',
                  ),
                  onChanged: (val) {
                    _mobile = val;
                  },
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.local_hospital),
                    labelText: 'Category',
                    hintText: 'Select category',
                  ),
                  value: _category,
                  isExpanded: true,
                  isDense: true,
                  items: ['Food', 'Medicine', 'Other'].map((val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _category = val;
                    });
                  },
                ),
                TextFormField(
                  initialValue: _description,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Description',
                    hintText: 'Enter a detailed description',
                  ),
                  onChanged: (val) {
                    _description = val;
                  },
                ),
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
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
