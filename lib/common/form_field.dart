import 'package:divoc/common/images.dart';
import 'package:divoc/common/screens.dart';
import 'package:divoc/components/maps/google_map_location.dart';
import 'package:divoc/models/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:divoc/services/utils.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'constants.dart';

class GenericTextContainer extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final EdgeInsetsGeometry contentPadding;

  const GenericTextContainer({this.title, this.content, this.icon, this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...[
            Text(
              title,
              style: kLabelStyle,
            ),
          ],
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              enabled: false,
              maxLines: null,
              textAlign: TextAlign.start,
              initialValue: content,
              style: kTextStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: contentPadding ?? EdgeInsets.only(top: 14.0),
                prefixIcon: icon == null
                    ? null
                    : Icon(
                        icon,
                        color: Colors.white,
                      ),
                hintStyle: kHintTextStyle,
              ),
              onChanged: (val) {},
            ),
          ),
        ],
      ),
    );
  }
}

class GenericTextField extends StatelessWidget {
  final Function(String) onChanged;
  final String title;
  final String hint;
  final IconData icon;
  final TextInputType textInputType;
  final String initialValue;
  final int maxLines;
  final double height;
  final FormFieldValidator<String> validator;

  const GenericTextField({
    this.onChanged,
    this.title,
    this.hint,
    this.icon,
    this.textInputType,
    this.initialValue,
    this.maxLines,
    this.height,
    this.validator,
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
            validator: validator,
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

class GenericVerifyMobileField extends StatefulWidget {
  final String title;
  final String hint;
  final String initialValue;
  final Function(String) onSelected;

  const GenericVerifyMobileField({
    this.title,
    this.hint,
    this.initialValue,
    this.onSelected,
  });

  @override
  _GenericVerifyMobileFieldState createState() => _GenericVerifyMobileFieldState();
}

class _GenericVerifyMobileFieldState extends State<GenericVerifyMobileField> {
  String _mobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              widget.title,
              style: kLabelStyle,
            ),
            if (widget.initialValue.isNullOrEmpty) ...[
              SizedBox(width: 5.0),
              Icon(Icons.error, color: Colors.red, size: 20.0),
            ],
            if (!widget.initialValue.isNullOrEmpty) ...[
              SizedBox(width: 5.0),
              Icon(Icons.verified_user, color: Colors.green, size: 20.0),
            ],
          ],
        ),
        SizedBox(height: 10.0),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MobileVerifyScreen(onSelected: (String mobile) {
                  setState(() {
                    _mobile = mobile;
                  });
                  widget.onSelected(mobile);
                }),
              ),
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            height: 60.0,
            child: Row(
              children: <Widget>[
                Icon(Icons.phone, color: Colors.white),
                SizedBox(width: 12.0),
                if (widget.initialValue.isNullOrEmpty && _mobile.isNullOrEmpty) ...[
                  Text(widget.hint, style: kHintTextStyle),
                ],
                if (!widget.initialValue.isNullOrEmpty && _mobile.isNullOrEmpty) ...[
                  Expanded(child: Text(widget.initialValue, style: kTextStyle)),
                ],
                if (_mobile != null) ...[
                  Expanded(child: Text(_mobile, style: kTextStyle)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GenericGoogleMapField extends StatefulWidget {
  final String title;
  final String hint;
  final String initialValue;
  final Function(Address) onSelected;

  const GenericGoogleMapField({
    this.title,
    this.hint,
    this.initialValue,
    this.onSelected,
  });

  @override
  _GenericGoogleMapFieldState createState() => _GenericGoogleMapFieldState();
}

class _GenericGoogleMapFieldState extends State<GenericGoogleMapField> {
  Address _address;

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoogleMapLocation(onSelected: (Address address) {
                  setState(() {
                    _address = address;
                  });
                  widget.onSelected(address);
                }),
              ),
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            height: 60.0,
            child: Row(
              children: <Widget>[
                Icon(Icons.map, color: Colors.white),
                SizedBox(width: 12.0),
                if (widget.initialValue.isNullOrEmpty && _address.isNull) ...[
                  Text(widget.hint, style: kHintTextStyle),
                ],
                if (!widget.initialValue.isNullOrEmpty && _address.isNull) ...[
                  Expanded(child: Text(widget.initialValue, style: kTextStyle)),
                ],
                if (_address != null) ...[
                  Expanded(child: Text(_address.formatted, style: kTextStyle)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GenericImageField extends StatelessWidget {
  final String title;
  final String image;

  const GenericImageField({this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadedImageFullScreen(title: title, image: image),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Kvitto', style: kLabelStyle),
            SizedBox(height: 10.0),
            UploadedImage(image: title),
          ],
        ),
      ),
    );
  }
}

class GenericDateField extends StatefulWidget {
  final String title;
  final String hint;
  final DateTime initialValue;
  final Function(DateTime) onChanged;

  const GenericDateField({this.title, this.hint, this.onChanged, this.initialValue});

  @override
  _GenericDateFieldState createState() => _GenericDateFieldState();
}

class _GenericDateFieldState extends State<GenericDateField> {
  DateTime _date;

  DateTime getInitialVal() {
    if (_date != null) {
      return _date;
    } else if (widget.initialValue != null) {
      return widget.initialValue;
    } else {
      return DateTime(DateTime.now().year - 29, DateTime.now().month, DateTime.now().day);
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
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return CupertinoDatePicker(
                  minimumYear: 1900,
                  maximumYear: DateTime.now().year + 1,
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: getInitialVal(),
                  onDateTimeChanged: (DateTime datetime) {
                    setState(() {
                      _date = datetime;
                    });
                    widget.onChanged(_date);
                  },
                );
              },
            );
          },
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
                if (widget.initialValue.isNullOrEmpty && _date == null) ...[
                  Text(widget.hint, style: kHintTextStyle),
                ],
                if (!widget.initialValue.isNullOrEmpty && _date == null) ...[
                  Text(widget.initialValue.toLocal().toString().split(' ')[0], style: kTextStyle),
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
  final String initialValue;
  final List<String> options;
  final String title;
  final String hint;
  final IconData icon;

  const GenericDropdownField({
    this.onChanged,
    this.initialValue,
    this.options,
    this.title,
    this.hint,
    this.icon,
  });

  @override
  _GenericDropdownFieldState createState() => _GenericDropdownFieldState();
}

class _GenericDropdownFieldState extends State<GenericDropdownField> {
  String _val;

  @override
  void initState() {
    super.initState();
    _val = widget.initialValue ?? widget.options.first;
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
          child: DropdownButtonFormField(
            style: TextStyle(color: Colors.black),
            selectedItemBuilder: (BuildContext context) {
              return widget.options.map((String value) {
                return Text(
                  _val,
                  style: TextStyle(color: Colors.white),
                );
              }).toList();
            },
            value: _val,
            items: widget.options
                .map((val) => DropdownMenuItem<String>(
                    value: val, child: Text(val, style: TextStyle(color: Colors.black, fontFamily: 'OpenSans'))))
                .toList(),
            decoration: InputDecoration(
              border: InputBorder.none,
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
          'Mobil nummer (inkl +46)',
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
        SizedBox(height: 30.0),
        Text(
          'Kod',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
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
