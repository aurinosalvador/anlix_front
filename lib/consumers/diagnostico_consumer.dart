import 'dart:convert';

import 'package:anlix_front/models/diagnostico_model.dart';
import 'package:http/http.dart' as http;

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
}
