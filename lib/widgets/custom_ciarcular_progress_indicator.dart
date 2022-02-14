import 'package:flutter/material.dart';

class CustomCircularProgressIndicator {
  final BuildContext context;
  String message;
  bool _show = false;

  CustomCircularProgressIndicator({
    required this.context,
    this.message = 'Aguarde',
  });

  void show() {
    _show = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(message),
              ),
            ],
          ),
        );
      },
    );
  }

  void close() {
    if(_show){
      _show = false;
      Navigator.of(context).pop();
    }
  }
}
