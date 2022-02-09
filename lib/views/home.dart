import 'package:anlix_front/consumers/paciente_consumer.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Future<List<PacienteModel>> _loadingApp() async {
    PacienteConsumer consumer = PacienteConsumer();
    return consumer.list();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PacienteModel>>(
      future: _loadingApp(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<PacienteModel>> snapshot,
      ) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Anlix Front'),
            ),
            body: const Center(
              child: Text('Sem Usuários'),
            ),
          );
        }

        return Scaffold(
            appBar: AppBar(
              title: const Text('Anlix Front'),
            ),
            body: ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data![index].nome),
                );
              },
            ));
      },
    );
  }
}
