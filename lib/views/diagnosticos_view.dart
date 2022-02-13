import 'dart:async';

import 'package:anlix_front/consumers/diagnostico_consumer.dart';
import 'package:anlix_front/consumers/paciente_consumer.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:anlix_front/widgets/custom_delegate.dart';
import 'package:anlix_front/widgets/date_field.dart';
import 'package:anlix_front/widgets/field_group.dart';
import 'package:anlix_front/widgets/my_dialogs.dart';
import 'package:flutter/material.dart';

enum FilterType {
  date,
  value,
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

  FilterType _filterType = FilterType.date;

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

                      Visibility(
                        visible: _selectedPacientes.isNotEmpty,
                        child: FieldGroup(
                          decoration: const InputDecoration(
                            labelText: 'Filtros',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Text('Filtrar por: '),
                                Flexible(
                                  child: ListTile(
                                    title: const Text('Data'),
                                    leading: Radio<FilterType>(
                                      value: FilterType.date,
                                      groupValue: _filterType,
                                      onChanged: (FilterType? value) {
                                        _filterType = value!;
                                        _controller.add(true);
                                      },
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 6,
                                  child: ListTile(
                                    title: const Text('Valores'),
                                    leading: Radio<FilterType>(
                                      value: FilterType.value,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Visibility(
                                visible: _filterType == FilterType.date,
                                child: Row(
                                  children: <Widget>[
                                    const Text(
                                      'Selecione o intervalo de datas:',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: SizedBox(
                                        width: 200,
                                        child: DateField(
                                          controller: _initDateController,
                                          label: 'Data inicial',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: DateField(
                                        controller: _endDateController,
                                        label: 'Data final',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.download_rounded),
                                      label: const Text('Exportar CSV'),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.bar_chart),
                                      label: const Text('Mostrar Gráfico'),
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }

  bool enableButtons() {
    if(_filterType == FilterType.date){
      return _initDateController.date != null && _endDateController.date != null;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
