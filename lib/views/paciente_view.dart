import 'package:anlix_front/consumers/paciente_consumer.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:flutter/material.dart';

class PacienteView extends StatelessWidget {
  const PacienteView({Key? key}) : super(key: key);

  Future<List<PacienteModel>> _loadingData() async {
    PacienteConsumer consumer = PacienteConsumer();
    return consumer.list();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PacienteModel>>(
      future: _loadingData(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<PacienteModel>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<PacienteModel> pacientes = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Clientes'),
            ),
            body: Column(
              children: <Widget>[
                
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Digite para pesquisar',
                    ),

                  ),
                ),
                
                Expanded(
                  child: ListView.separated(
                    itemCount: pacientes.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
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
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Clientes'),
            ),
            body: const Center(
              child: Text('Sem Usuários'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Clientes'),
          ),
          body: const CircularProgressIndicator(),
        );
      },
    );
  }
}
