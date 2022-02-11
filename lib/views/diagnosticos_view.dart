import 'package:flutter/material.dart';

class DiagnosticosView extends StatelessWidget {
  const DiagnosticosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnósticos'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Icon(
              Icons.upload_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Diagnósticos'),
      ),
    );
  }
}
