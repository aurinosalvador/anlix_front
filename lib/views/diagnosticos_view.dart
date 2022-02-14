import 'dart:async';
import 'dart:typed_data';

import 'package:anlix_front/consumers/diagnostico_consumer.dart';
import 'package:anlix_front/consumers/paciente_consumer.dart';
import 'package:anlix_front/models/diagnostico_model.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:anlix_front/utils/csv_util.dart';
import 'package:anlix_front/views/charts_view.dart';
import 'package:anlix_front/widgets/custom_ciarcular_progress_indicator.dart';
import 'package:anlix_front/widgets/custom_delegate.dart';
import 'package:anlix_front/widgets/date_field.dart';
import 'package:anlix_front/widgets/field_group.dart';
import 'package:anlix_front/widgets/my_dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

enum FilterType {
  ind_pulm,
  ind_card,
}

class DiagnosticosView extends StatefulWidget {
  const DiagnosticosView({Key? key}) : super(key: key);

  @override
  State<DiagnosticosView> createState() => _DiagnosticosViewState();
}

class _DiagnosticosViewState extends State<DiagnosticosView> {
  final DiagnosticoConsumer _consumer = DiagnosticoConsumer();
  final PacienteConsumer _pacienteConsumer = PacienteConsumer();

  final StreamController<bool> _controller = StreamController<bool>();
  final DateEditingController _initDateController = DateEditingController();
  final DateEditingController _endDateController = DateEditingController();

  final List<PacienteModel> _selectedPacientes = <PacienteModel>[];

  FilterType _filterType = FilterType.ind_pulm;

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
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                PlatformFile file = result.files.first;

                await Future<void>.delayed(const Duration(seconds: 5));

                // await _consumer.importFiles(file);
              }
            },
            icon: const Icon(Icons.upload_sharp, color: Colors.white),
            label: const Text(
              'Importar Dados',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: StreamBuilder<bool>(
                stream: _controller.stream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active &&
                      snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Pacientes
                        FieldGroup(
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

                                      if (delete) {
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
                              },
                              child: Text('Adicionar Paciente'.toUpperCase()),
                            ),
                          ],
                        ),

                        // Gerar CSV
                        Visibility(
                          visible: _selectedPacientes.isNotEmpty,
                          child: FieldGroup(
                            decoration: const InputDecoration(
                              labelText: 'Exportar',
                              border: OutlineInputBorder(),
                              counterText: '',
                            ),
                            children: <Widget>[
                              ElevatedButton.icon(
                                onPressed: () async {
                                  Map<int, List<DiagnosticoModel>> result =
                                      await _consumer.getByListPacienteId(
                                          _selectedPacientes);

                                  bool success = await CsvUtil.getCsv(
                                    list: result,
                                  );
                                  if (!success) {
                                    await MyDialogs.dialogMessage(
                                      context: context,
                                      message: 'Sem dados para exportar.',
                                    );
                                  }
                                },
                                icon: const Icon(Icons.download_rounded),
                                label: const Text('Exportar CSV'),
                              )
                            ],
                          ),
                        ),

                        // Gerar Gráficos
                        Visibility(
                          visible: _selectedPacientes.isNotEmpty,
                          child: FieldGroup(
                            decoration: const InputDecoration(
                              labelText: 'Gerar Gráficos',
                              border: OutlineInputBorder(),
                              counterText: '',
                            ),
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  const Text('Filtrar por: '),
                                  Flexible(
                                    child: ListTile(
                                      title: const Text('Índice Pulmonar'),
                                      leading: Radio<FilterType>(
                                        value: FilterType.ind_pulm,
                                        groupValue: _filterType,
                                        onChanged: (FilterType? value) {
                                          _filterType = value!;
                                          _controller.add(true);
                                        },
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListTile(
                                      title: const Text('Índice Cardíaco'),
                                      leading: Radio<FilterType>(
                                        value: FilterType.ind_card,
                                        groupValue: _filterType,
                                        onChanged: (FilterType? value) {
                                          _filterType = value!;
                                          _controller.add(true);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (_selectedPacientes.length > 1) {
                                    await MyDialogs.dialogMessage(
                                      context: context,
                                      message: 'Selecione apenas um paciente.',
                                    );

                                    return;
                                  }

                                  List<DiagnosticoModel> result =
                                      await _consumer.getByPacienteIdAndType(
                                    _selectedPacientes.first.id,
                                    _filterType.name,
                                  );

                                  await Navigator.of(context).push(
                                    MaterialPageRoute<Widget>(
                                        builder: (_) => ChartsView(
                                              diagnosticos: result,
                                              pacienteName:
                                                  _selectedPacientes.first.nome,
                                              type: _filterType.name,
                                            )),
                                  );
                                },
                                icon: const Icon(Icons.bar_chart),
                                label: const Text('Mostrar Gráfico'),
                              ),
                            ],
                          ),
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
      ),
    );
  }

  List<int> convertFileToCast(Uint8List data) {
    List<int> list = data.cast();
    return list;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
