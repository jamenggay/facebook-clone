import '../constants.dart';
import 'package:flutter/material.dart';

void customDialog(BuildContext context, {required title, required content}) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: <Widget>[
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: FB_DARK_PRIMARY, foregroundColor: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Okay'),
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}