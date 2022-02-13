import 'dart:convert';
import 'dart:html' as html;

import 'package:anlix_front/consumers/paciente_consumer.dart';
import 'package:anlix_front/models/diagnostico_model.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

class CsvUtil {
  static Future<bool> getCsv({
    required Map<int, List<DiagnosticoModel>> list,
  }) async {
    List<PacienteModel> pacientes = await PacienteConsumer().list();

    List<List<dynamic>> rows = <List<dynamic>>[];

    List<String> header = <String>[];
    header.add('Paciente');
    header.add('EPOC');
    header.add('Tipo');
    header.add('Valor');
    header.add('Data');
    rows.add(header);

    list.forEach((int key, List<DiagnosticoModel> value) {
      for (DiagnosticoModel diagnostico in value) {
        List<dynamic> row = <dynamic>[];
        row.add(
          pacientes
              .singleWhere((PacienteModel element) => element.id == key)
              .nome,
        );

        row.add(diagnostico.epoc);
        row.add(diagnostico.tipo);
        row.add(diagnostico.valor);
        row.add(DateFormat('dd/MM/yyyy').format(diagnostico.data));

        rows.add(row);
      }
    });

    if(rows.length <= 1) {
      return false;
    }

    String csv = const ListToCsvConverter().convert(rows);

    final List<int> bytes = utf8.encode(csv);

    final html.Blob blob = html.Blob(<List<int>>[bytes]);

    final String url = html.Url.createObjectUrlFromBlob(blob);

    final html.AnchorElement anchor =
        html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'diagnosticos-${DateTime.now()}.csv';

    html.document.body!.children.add(anchor);

    anchor.click();
    html.Url.revokeObjectUrl(url);

    return true;
  }
}
