import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileFormRow extends StatelessWidget {
  final String initialValue;
  final TextEditingController controller;
  final String hint;
  final String label;
  final bool readOnly;

  ProfileFormRow(
      {this.initialValue,
      @required this.controller,
      this.label,
      this.hint,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            child: new Text(
              label,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
            margin: new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
          ),
          new Container(
            child: new TextFormField(
              controller: controller,
              readOnly: readOnly,
              decoration: new InputDecoration(
                  hintText: hint,
                  border: new UnderlineInputBorder(),
                  contentPadding: EdgeInsets.only(bottom: -20.0)),
            ),
            margin: new EdgeInsets.only(left: 30.0, right: 30.0),
          ),
        ]);
  }
}
