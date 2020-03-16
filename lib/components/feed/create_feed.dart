import 'package:flutter/material.dart';

class CreateFeed extends StatefulWidget {
  @override
  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  String _gender = 'Male';
  String _age = "18";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Create new feed'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(35.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              initialValue: _age,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Age',
                hintText: '18',
              ),
              onChanged: (val) {
                _age = val;
              },
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.sentiment_satisfied),
                labelText: 'Gender',
                hintText: 'Select your gender',
              ),
              value: _gender,
              isExpanded: true,
              isDense: true,
              items: ['Male', 'Female'].map((val) {
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
          ],
        ),
      ),
    );
  }
}
