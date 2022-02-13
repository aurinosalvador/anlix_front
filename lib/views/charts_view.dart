import 'dart:math';

import 'package:anlix_front/models/diagnostico_model.dart';
import 'package:anlix_front/models/diagnosticos_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartsView extends StatelessWidget {
  final List<DiagnosticoModel> diagnosticos;
  final String pacienteName;
  final String type;

  ChartsView({
    required this.diagnosticos,
    required this.pacienteName,
    required this.type,
    Key? key,
  }) : super(key: key);

  List<DiagnosticosSeries> data = <DiagnosticosSeries>[];

  Future<List<DiagnosticosSeries>> loadData() async {
    for (DiagnosticoModel diagnostico in diagnosticos) {
      data.add(DiagnosticosSeries(
        date: DateFormat('dd-MM-yyyy').format(diagnostico.data),
        type: diagnostico.tipo,
        value: diagnostico.valor,
        barColor: charts.ColorUtil.fromDartColor(Colors.red),
      ));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico de Diagnósticos'),
      ),
      body: FutureBuilder<List<DiagnosticosSeries>>(
          future: loadData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<DiagnosticosSeries>> snapshot,) {
            if (snapshot.hasData) {
              List<charts.Series<DiagnosticosSeries, String>> series =
              <charts.Series<DiagnosticosSeries, String>>[
                charts.Series<DiagnosticosSeries, String>(
                  id: pacienteName,
                  data: snapshot.data!,
                  domainFn: (DiagnosticosSeries series, _) => series.date,
                  measureFn: (DiagnosticosSeries series, _) => series.value,
                  colorFn: (DiagnosticosSeries series, _) => series.barColor,
                )
              ];

              return SingleChildScrollView(
                child: Container(
                  height: 400,
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${type == 'ind_pulm'
                                ? 'Índice Pulmonar'
                                : 'Índice Cardíaco' } - $pacienteName',
                          ),
                          Expanded(
                            child: charts.BarChart(
                              series,
                              animate: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
