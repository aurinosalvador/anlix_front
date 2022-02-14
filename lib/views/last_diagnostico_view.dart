import 'dart:async';

import 'package:anlix_front/consumers/diagnostico_consumer.dart';
import 'package:anlix_front/models/diagnostico_model.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Status {
  loading,
  done,
  empty,
}

class LastDiagnosticoView extends StatefulWidget {
  final PacienteModel paciente;

  const LastDiagnosticoView({
    required this.paciente,
    Key? key,
  }) : super(key: key);

  @override
  State<LastDiagnosticoView> createState() => _LastDiagnosticoViewState();
}

class _LastDiagnosticoViewState extends State<LastDiagnosticoView> {
  final DiagnosticoConsumer diagnosticoConsumer = DiagnosticoConsumer();

  final StreamController<Status> _controller = StreamController<Status>();

  List<DiagnosticoModel> diagnosticos = <DiagnosticoModel>[];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    _controller.add(Status.loading);

    diagnosticos =
        await diagnosticoConsumer.getLastByPacienteId(widget.paciente.id);

    diagnosticos.isEmpty
        ? _controller.add(Status.empty)
        : _controller.add(Status.done);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnósticos'),
      ),
      body: Center(
        child: StreamBuilder<Status>(
            stream: _controller.stream,
            builder: (
              BuildContext context,
              AsyncSnapshot<Status> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData &&
                  snapshot.data == Status.done) {
                return Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Últimos índices'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        widget.paciente.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 1.3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _getRowData(diagnosticos),
                      ),
                    ),
                  ],
                );
              }

              if (!snapshot.hasData || snapshot.data == Status.empty) {
                return const Center(
                  child: Text('Sem diagnósticos'),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  List<Widget> _getRowData(List<DiagnosticoModel> diagnosticos) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    List<Widget> widgets = <Widget>[];

    for (DiagnosticoModel diagnostico in diagnosticos) {
      widgets.add(
        Container(
          padding: const EdgeInsets.all(16),
          width: 350,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Índice: ${diagnostico.tipo == 'ind_pulm' ? 'Pulmonar' : 'Cardíaco'}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Valor: ${diagnostico.valor}'),
              Text('EPOC: ${diagnostico.epoc}'),
              Text('Data: ${dateFormat.format(diagnostico.data)}'),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
