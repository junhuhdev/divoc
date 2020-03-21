import 'package:divoc/common/buttons.dart';
import 'package:divoc/common/form_container.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/feed.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateFeed extends StatefulWidget {
  @override
  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  String _gender = 'Male';
  String _age = "18";
  String _name;
  String _description;
  String _shoppingInfo;
  String _mobile;
  String _category = "Food";
  bool _isLoading = false;

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
            title: Text('Create New Event'),
            centerTitle: true,
          ),
          body: FormContainer(
            children: <Widget>[
              if (user != null) ...[
                GenericTextField(
                  title: 'Name',
                  hint: 'Enter name of person involved',
                  icon: Icons.person,
                  initialValue: user.name,
                  textInputType: TextInputType.text,
                  onChanged: (String val) => setState(() => _name = val),
                ),
                SizedBox(height: 30.0),
                GenericTextField(
                  title: 'Mobile Number',
                  hint: 'Enter number of contact person',
                  icon: Icons.phone,
                  initialValue: user.mobile,
                  textInputType: TextInputType.phone,
                  onChanged: (String val) => setState(() => _mobile = val),
                ),
                SizedBox(height: 30.0),
                GenericDropdownField(
                  title: 'Category',
                  hint: 'Select category',
                  icon: Icons.category,
                  options: ['Food', 'Medicine', 'Other'],
                  onChanged: (String val) => setState(() => _category = val),
                ),
                SizedBox(height: 30.0),
                GenericTextField(
                  title: 'Description',
                  hint: 'Enter a detailed description',
                  height: 100.0,
                  maxLines: 5,
                  icon: Icons.comment,
                  textInputType: TextInputType.multiline,
                  onChanged: (String val) => setState(() => _description = val),
                ),
                SizedBox(height: 30.0),
                GenericTextField(
                  title: 'Shopping List',
                  hint: 'Enter a detailed shopping list with name and quantity',
                  height: 100.0,
                  maxLines: 5,
                  icon: Icons.add_shopping_cart,
                  textInputType: TextInputType.multiline,
                  onChanged: (String val) => setState(() => _shoppingInfo = val),
                ),
                ActionButton(
                  title: 'Create',
                  onPressed: () async {
                    await Global.feedCollection.insert(
                      ({
                        'ownerId': user.id,
                        'name': _name ?? user.name,
                        'mobile': _mobile ?? user.mobile,
                        'gender': user.gender,
                        'age': user.age,
                        'photo': user.photo,
                        'category': _category,
                        'description': _description,
                        'status': "created",
                        'created': DateTime.now(),
                      }),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
              if (user == null) ...[
                Container(),
              ],
            ],
          ),
        );
      },
    );
  }
}
