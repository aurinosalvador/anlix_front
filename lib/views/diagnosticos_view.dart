import 'dart:async';

import 'package:anlix_front/models/paciente_model.dart';
import 'package:anlix_front/widgets/field_group.dart';
import 'package:flutter/material.dart';

class DiagnosticosView extends StatefulWidget {
  const DiagnosticosView({Key? key}) : super(key: key);

  @override
  State<DiagnosticosView> createState() => _DiagnosticosViewState();
}

class _DiagnosticosViewState extends State<DiagnosticosView> {
  // final DiagnosticoConsumer _consumer = DiagnosticoConsumer();

  final StreamController<bool> _controller = StreamController<bool>();
  final List<PacienteModel> _selectedPacientes = <PacienteModel>[];

  @override
  void initState() {
    super.initState();
    _controller.add(true);
  }

  // Future<void> _addPaciente(PacienteModel paciente) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnósticos'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: StreamBuilder<bool>(
              stream: _controller.stream,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  return FieldGroup(
                    decoration: const InputDecoration(
                      labelText: 'Clientes',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    children: <Widget>[
                      if (_selectedPacientes.isEmpty)
                        const SizedBox(
                          height: 75,
                          child: Center(
                            child: Text('Sem pacientes selecionados'),
                          ),
                        ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     await Navigator.of(context).push(
                      //       MaterialPageRoute<dynamic>(
                      //         builder: (BuildContext context) =>
                      //
                      //       ),
                      //     );
                      //   },
                      //   child: Text('Adicionar Paciente'.toUpperCase()),
                      // ),
                    ],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
