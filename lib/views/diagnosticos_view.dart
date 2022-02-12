import 'dart:async';

import 'package:anlix_front/consumers/diagnostico_consumer.dart';
import 'package:anlix_front/consumers/paciente_consumer.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:anlix_front/widgets/custom_delegate.dart';
import 'package:anlix_front/widgets/field_group.dart';
import 'package:anlix_front/widgets/my_dialogs.dart';
import 'package:flutter/material.dart';

class DiagnosticosView extends StatefulWidget {
  const DiagnosticosView({Key? key}) : super(key: key);

  @override
  State<DiagnosticosView> createState() => _DiagnosticosViewState();
}

class _DiagnosticosViewState extends State<DiagnosticosView> {
  final DiagnosticoConsumer _consumer = DiagnosticoConsumer();
  final PacienteConsumer _pacienteConsumer = PacienteConsumer();

  final StreamController<bool> _controller = StreamController<bool>();
  final List<PacienteModel> _selectedPacientes = <PacienteModel>[];

  @override
  void initState() {
    super.initState();
    _controller.add(true);
  }

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
                      labelText: 'Pacientes',
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
                        )
                      else
                        ..._selectedPacientes.map(
                          (PacienteModel paciente) => ListTile(
                            title: Text(paciente.nome),
                            trailing: TextButton(
                              onPressed: () async {
                                bool delete = await MyDialogs.yesNoDialog(
                                  context: context,
                                  message: 'Deseja realmente excluir?',
                                );

                                if(delete){
                                  _selectedPacientes.remove(paciente);
                                  _controller.add(true);
                                }
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: () async {
                          List<PacienteModel>? pacientes =
                              await _pacienteConsumer.list();
                          await showSearch(
                            context: context,
                            delegate: CustomDelegate(
                              data: pacientes,
                              multipleSelection: true,
                              selected: _selectedPacientes,
                            ),
                          );
                          _controller.add(true);

                          print(_selectedPacientes.length);
                        },
                        child: Text('Adicionar Paciente'.toUpperCase()),
                      ),
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
