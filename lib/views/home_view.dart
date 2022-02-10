import 'package:anlix_front/consumers/paciente_consumer.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anlix Front'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async{
              await Navigator.of(context).pushNamed('/paciente');
            },
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(
                    Icons.person,
                    size: 48,
                  ),
                  Text("Paciente"),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(
                    Icons.medical_services,
                    size: 48,
                  ),
                  Text("Diagnósticos"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
