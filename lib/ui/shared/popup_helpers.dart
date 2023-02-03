import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupHelper {
  static Future<void> show(
      BuildContext context, String errorMessage, String informationMessage) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(errorMessage != null ? 'Erreur' : 'Information'),
          content:
              Text(errorMessage != null ? errorMessage : informationMessage),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
