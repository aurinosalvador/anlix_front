import 'package:flutter/material.dart';

class DiagnosticoView extends StatelessWidget {
  const DiagnosticoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Anlix Front'),
    ),
    body: const Center(child: Text('Diagsnóstico'),),
    );
  }
}
