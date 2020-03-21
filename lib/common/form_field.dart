import 'package:flutter/material.dart';

import 'constants.dart';

class GenericTextField extends StatelessWidget {
  final Function(String) onChanged;
  final String title;
  final String hint;
  final IconData icon;
  final TextInputType textInputType;
  final String initialValue;
  final int maxLines;
  final double height;

  const GenericTextField({
    this.onChanged,
    this.title,
    this.hint,
    this.icon,
    this.textInputType,
    this.initialValue,
    this.maxLines,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: height ?? 60.0,
          child: TextFormField(
            minLines: 1,
            maxLines: maxLines ?? 1,
            initialValue: initialValue,
            keyboardType: textInputType,
            style: kTextStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icon,
                color: Colors.white,
              ),
              hintText: hint,
              hintStyle: kHintTextStyle,
            ),
            onChanged: (val) {
              if (onChanged != null) {
                onChanged(val);
              }
            },
          ),
        ),
      ],
    );
  }
}

class GenericDateField extends StatefulWidget {
  final String title;
  final String hint;
  final Function(DateTime) onChanged;

  const GenericDateField({this.title, this.hint, this.onChanged});

  @override
  _GenericDateFieldState createState() => _GenericDateFieldState();
}

class _GenericDateFieldState extends State<GenericDateField> {
  DateTime _date;

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date == null ? DateTime(DateTime.now().year - 29, DateTime.now().month, DateTime.now().day) : _date,
      firstDate: DateTime(1940),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
      widget.onChanged(_date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        GestureDetector(
          onTap: () => selectDate(context),
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 12.0),
                  child: Icon(Icons.calendar_today, color: Colors.white),
                ),
                SizedBox(width: 12.0),
                if (_date == null) ...[
                  Text(widget.hint, style: kHintTextStyle),
                ],
                if (_date != null) ...[
                  Text(_date.toLocal().toString().split(' ')[0], style: kTextStyle),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GenericDropdownField extends StatefulWidget {
  final Function(String) onChanged;
  final List<String> options;
  final String title;
  final String hint;
  final IconData icon;

  const GenericDropdownField({this.onChanged, this.options, this.title, this.hint, this.icon});

  @override
  _GenericDropdownFieldState createState() => _GenericDropdownFieldState();
}

class _GenericDropdownFieldState extends State<GenericDropdownField> {
  String _val;

  @override
  void initState() {
    super.initState();
    _val = widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 62.0,
          child: DropdownButtonFormField(
            value: _val,
            items: widget.options
                .map((val) => DropdownMenuItem<String>(
                    value: val, child: Text(val, style: TextStyle(color: Colors.grey, fontFamily: 'OpenSans'))))
                .toList(),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 5.0),
              prefixIcon: Icon(
                widget.icon,
                color: Colors.white,
              ),
              hintText: widget.hint,
              hintStyle: kHintTextStyle,
            ),
            onChanged: (val) {
              _val = val;
              widget.onChanged(val);
            },
          ),
        ),
      ],
    );
  }
}

class EmailField extends StatelessWidget {
  final Function(String) callback;

  const EmailField({this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: kEmailInputDecoration,
            onChanged: (val) {
              callback(val);
            },
          ),
        ),
      ],
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  final Function(String) callback;

  const PhoneNumberField({this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone number',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: kPhoneInputDecoration,
            onChanged: (val) {
              callback(val);
            },
          ),
        ),
      ],
    );
  }
}

class SmsCodeField extends StatelessWidget {
  final Function(String) callback;

  const SmsCodeField({this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Code',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: kSmsCodeInputDecoration,
            onChanged: (val) {
              callback(val);
            },
          ),
        ),
      ],
    );
  }
}

class PasswordField extends StatelessWidget {
  final Function(String) callback;

  const PasswordField({this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: kPasswordInputDecoration,
            onChanged: (val) {
              callback(val);
            },
          ),
        ),
      ],
    );
  }
}
