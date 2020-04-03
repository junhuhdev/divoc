import 'package:divoc/services/auth_service.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget {
  final String title;

  const MainAppBar({this.title});

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  AuthService securityService = AuthService();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 1.0,
      title: Text(widget.title,
          style: TextStyle(fontFamily: 'OpenSans', fontSize: 17.0, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
      actions: <Widget>[
        if (widget.title == 'Feed')
          IconButton(
            icon: Icon(Icons.tune),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return FilterModal();
                },
              );
            },
          ),
        new IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: new IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Är du säker på att du vill logga ut?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Avbryt'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Bekräfta'),
                        onPressed: () async {
                          await securityService.logout();
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}

class FilterChipEntry {
  final String name;

  const FilterChipEntry(this.name);
}

class FilterModal extends StatefulWidget {
  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final List<FilterChipEntry> _cast = <FilterChipEntry>[
    const FilterChipEntry('Grocery'),
    const FilterChipEntry('Medicine'),
    const FilterChipEntry('Others'),
  ];

  List<String> _filters = <String>[];

  Iterable<Widget> get typeWidgets sync* {
    for (FilterChipEntry entry in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          label: Text(entry.name),
          selected: _filters.contains(entry.name),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(entry.name);
              } else {
                _filters.removeWhere((String name) {
                  return name == entry.name;
                });
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Choose Type'),
          Wrap(
            children: typeWidgets.toList(),
          )
        ],
      ),
    );
  }
}
