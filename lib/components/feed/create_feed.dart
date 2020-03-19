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
  String _mobile;
  String _category = "Food";
  bool _isLoading = false;
  List<ShoppingItem> _shoppingItems = List();
  String _itemName;
  String _itemQuantity;

  Widget _buildShoppingList() {
    if (_shoppingItems.isEmpty) {
      return Container();
    }
    List<Widget> list = new List();
    for (var item in _shoppingItems) {
      list.add(
        Row(
          children: <Widget>[
            TextFormField(
              initialValue: item.name,
            ),
            TextFormField(
              initialValue: item.quantity,
            ),
          ],
        ),
      );
    }
    return Column(children: list);
  }

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
          body: Container(
            padding: EdgeInsets.all(35.0),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: user.name,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Name',
                    hintText: 'Name...',
                  ),
                  onChanged: (val) {
                    _name = val;
                  },
                ),
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
                    icon: Icon(Icons.category),
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
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    icon: Icon(Icons.comment),
                    labelText: 'Description',
                    hintText: 'Enter a detailed description',
                  ),
                  onChanged: (val) {
                    _description = val;
                  },
                ),
                for (var item in _shoppingItems)
                  Column(
                    children: <Widget>[
                      TextFormField(initialValue: item.name),
                      TextFormField(initialValue: item.quantity),
                    ],
                  ),
                SizedBox(height: 40.0),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await Global.feedCollection.insert(
                      ({
                        'ownerId': user.id,
                        'name': _name ?? user.name,
                        'mobile': _mobile ?? user.mobile,
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
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text('Add Shopping List'),
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.all(35.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.add_shopping_cart),
                            labelText: 'Item name',
                            hintText: 'Toilet paper',
                          ),
                          onChanged: (val) {
                            _itemName = val;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            icon: Icon(Icons.add_shopping_cart),
                            labelText: 'Quantity',
                            hintText: '2',
                          ),
                          onChanged: (val) {
                            _itemQuantity = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text('Add', style: TextStyle(color: Colors.white)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: () {
                            setState(() {
                              _shoppingItems.add(ShoppingItem(_itemName, _itemQuantity));
                              _itemName = '';
                              _itemQuantity = '';
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class ShoppingItem {
  final String name;
  final String quantity;

  ShoppingItem(this.name, this.quantity);
}
