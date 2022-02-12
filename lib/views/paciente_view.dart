import 'dart:async';

import 'package:anlix_front/consumers/paciente_consumer.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:anlix_front/views/last_diagnostico_view.dart';
import 'package:anlix_front/widgets/custom_delegate.dart';
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

  final PacienteConsumer consumer = PacienteConsumer();
  List<PacienteModel> _pacientes = <PacienteModel>[];
  List<PacienteModel> _filteredPacientes = <PacienteModel>[];

  Future<void> _loadingData() async {
    _controller.add(Status.loading);
    _pacientes = await consumer.list();
    _filteredPacientes = _pacientes;
    _controller.add(Status.done);
  }

  @override
  void initState() {
    super.initState();

    _loadingData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Status>(
      stream: _controller.stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<Status> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData &&
            snapshot.data == Status.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Pacientes'),
              actions: <Widget>[
                TextButton(
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
              ],
            ),
            body: getListView(_pacientes),
          );
        }

        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Pacientes'),
            ),
            body: const Center(
              child: Text('Sem Usuários'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Pacientes'),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
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
