import 'dart:async';

import 'package:anlix_front/models/paciente_model.dart';
import 'package:anlix_front/views/last_diagnostico_view.dart';
import 'package:flutter/material.dart';

class CustomDelegate extends SearchDelegate<List<PacienteModel>> {
  final StreamController<bool> _controller = StreamController<bool>();
  late List<PacienteModel> data;
  bool multipleSelection;

  CustomDelegate({required this.data, this.multipleSelection = false});

  List<PacienteModel> result = <PacienteModel>[];

  @override
  List<Widget> buildActions(BuildContext context) => <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () => close(context, result),
      );

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    _controller.add(true);
    List<PacienteModel> listToShow;
    if (query.isNotEmpty) {
      listToShow = data
          .where((PacienteModel e) =>
              e.nome.toLowerCase().contains(query.toLowerCase()) &&
              e.nome.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    } else {
      listToShow = data;
    }

    return StreamBuilder<bool>(
      stream: _controller.stream,
      initialData: true,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return ListView.separated(
          itemCount: listToShow.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                multipleSelection
                    ? _addElementToList(listToShow[index])
                    : Navigator.of(context).pushReplacement(
                        MaterialPageRoute<Widget>(
                          builder: (_) => LastDiagnosticoView(
                            paciente: listToShow[index],
                          ),
                        ),
                      );
              },
              child: ListTile(
                leading: Icon(
                  result.contains(listToShow[index])
                      ? Icons.check_circle
                      : Icons.circle,
                  color: result.contains(listToShow[index])
                      ? Colors.green
                      : Colors.grey,
                  size: 36,
                ),
                title: Text(listToShow[index].nome),
                subtitle: Text(
                  'Data Nascimento: ${listToShow[index].dataNasc}',
                ),
                trailing: multipleSelection
                    ? null
                    : const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  void _addElementToList(PacienteModel paciente) {
    result.contains(paciente) ? result.remove(paciente) : result.add(paciente);
    _controller.add(true);
  }
}
