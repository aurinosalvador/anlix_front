import 'package:flutter/material.dart';

class MyDialogs {

  static Future<bool> yesNoDialog({
    required BuildContext context,
    required String message,
    String title = 'Atenção',
    String affirmative = 'Sim',
    String negative = 'Não',
    bool marked = false,
    bool scrollable = false,
  }) async {
    Widget aff;
    Widget neg;

    if (marked) {
      aff = ElevatedButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(affirmative),
      );

      neg = TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(negative),
      );
    } else {
      aff = TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(affirmative),
      );

      neg = ElevatedButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(negative),
      );
    }

    bool? value = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        scrollable: scrollable,
        actions: <Widget>[neg, aff],
      ),
    );

    return value ?? false;
  }

}