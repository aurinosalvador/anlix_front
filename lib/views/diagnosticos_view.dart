import 'package:anlix_front/consumers/diagnostico_consumer.dart';
import 'package:flutter/material.dart';

class DiagnosticosView extends StatelessWidget {
  final DiagnosticoConsumer _consumer = DiagnosticoConsumer();

  DiagnosticosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnósticos'),
      ),
      body: const Center(
        child: Text('Diagnósticos'),
      ),
    );
  }
}
