import 'dart:convert';

import 'package:anlix_front/models/diagnostico_model.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DiagnosticoConsumer {
  static const String apiUrl = 'http://192.168.0.107:8081/api/v1';

  Future<List<DiagnosticoModel>> getLastByPacienteId(int id) async {
    Uri url = Uri.parse(apiUrl + '/diagnostico/paciente/$id');
    http.Response response = await http.get(url);

    List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));

    return list
        .map<DiagnosticoModel>(
            (dynamic item) => DiagnosticoModel.fromJson(item))
        .toList();
  }

  Future<Map<int, List<DiagnosticoModel>>> getByDateInterval(
    List<PacienteModel> pacientes,
    DateTime initDate,
    DateTime endDate,
  ) async {
    Map<int, List<DiagnosticoModel>> ret = <int, List<DiagnosticoModel>> {};

    String firstDate = DateFormat('dd-MM-yyyy').format(initDate);
    String lastDate = DateFormat('dd-MM-yyyy').format(endDate);

    for (PacienteModel paciente in pacientes) {
      Uri url = Uri.parse(apiUrl + '/diagnostico/paciente/${paciente.id}/filter/$firstDate/$lastDate');
      http.Response response = await http.get(url);

      List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));

      ret[paciente.id] = list
          .map<DiagnosticoModel>(
              (dynamic item) => DiagnosticoModel.fromJson(item))
          .toList();
    }

    return ret;
  }
}
