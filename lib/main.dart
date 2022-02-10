import 'package:anlix_front/views/home_view.dart';
import 'package:anlix_front/views/paciente_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<String, Widget Function(BuildContext)> _routes =
      <String, Widget Function(BuildContext)>{
    '/home': (_) => const HomeView(),
    '/paciente': (_) => const PacienteView(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anlix Front',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/home',
      routes: _routes,
    );
  }
}
