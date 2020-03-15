import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget {
  final String title;

  const MainAppBar({this.title});

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
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
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: new IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {},
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
