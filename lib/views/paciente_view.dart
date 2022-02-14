import 'dart:async';
import 'dart:html';

import 'package:anlix_front/consumers/paciente_consumer.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:anlix_front/views/last_diagnostico_view.dart';
import 'package:anlix_front/widgets/custom_ciarcular_progress_indicator.dart';
import 'package:anlix_front/widgets/custom_delegate.dart';
import 'package:anlix_front/widgets/my_dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

enum Status {
  loading,
  done,
  empty,
}

class PacienteView extends StatefulWidget {
  const PacienteView({Key? key}) : super(key: key);

  @override
  State<PacienteView> createState() => _PacienteViewState();
}

class _PacienteViewState extends State<PacienteView> {
  final StreamController<Status> _controller = StreamController<Status>();

  final PacienteConsumer _consumer = PacienteConsumer();
  List<PacienteModel> _pacientes = <PacienteModel>[];
  List<PacienteModel> _filteredPacientes = <PacienteModel>[];

  Future<void> _loadingData() async {
    _controller.add(Status.loading);
    _pacientes = await _consumer.list();
    _filteredPacientes = _pacientes;
    _filteredPacientes.isEmpty
        ? _controller.add(Status.empty)
        : _controller.add(Status.done);
  }

  @override
  void initState() {
    super.initState();

    _loadingData();
  }

  @override
  Widget build(BuildContext context) {
    final CustomCircularProgressIndicator myCircular =
        CustomCircularProgressIndicator(
      context: context,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: <String>['json'],
              );

              if (result != null) {
                myCircular.show();
                PlatformFile file = result.files.single;

                Map<String, dynamic> response =
                    await _consumer.importFile(file);

                myCircular.close();

                if (response['status'] == HttpStatus.ok) {
                  await MyDialogs.dialogMessage(
                    context: context,
                    message: 'Arquivo Importado com sucesso!',
                  );
                  _controller.add(Status.done);
                } else {
                  await MyDialogs.dialogMessage(
                    context: context,
                    title: 'Erro ao Importar arquivo',
                    message: response['message'],
                  );
                }
              }
            },
            icon: const Icon(Icons.upload_sharp, color: Colors.white),
            label: const Text(
              'Importar Dados',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Visibility(
            visible: _pacientes.isNotEmpty,
            child: TextButton(
              onPressed: () async {
                await showSearch(
                  context: context,
                  delegate: CustomDelegate(data: _pacientes),
                );
              },
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<Status>(
        stream: _controller.stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<Status> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData &&
              snapshot.data == Status.done) {
            return getListView(_pacientes);
          }

          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData &&
              snapshot.data == Status.empty) {
            return const Center(
              child: Text('Sem Pacientes'),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget getListView(List<PacienteModel> pacientes) {
    return ListView.separated(
      itemCount: pacientes.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<Widget>(
                  builder: (_) => LastDiagnosticoView(
                        paciente: _pacientes[index],
                      )),
            );
          },
          child: ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                const Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 36,
                ),
                Text(
                  pacientes[index].tipoSanguineo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            title: Text(pacientes[index].nome),
            subtitle: Text(
              'Data Nascimento: ${pacientes[index].dataNasc}',
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  void onSearchTextChanged(String text) {
    _filteredPacientes.clear();
    if (text.isEmpty) {
      _controller.add(Status.loading);

      _filteredPacientes = _pacientes;
      _controller.add(Status.done);
      return;
    }

    for (PacienteModel element in _pacientes) {
      if (element.nome.contains(text)) {
        _filteredPacientes.add(element);
      }
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
