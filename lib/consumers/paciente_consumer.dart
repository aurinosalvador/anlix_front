import 'dart:convert';

import 'package:anlix_front/models/paciente_model.dart';
import 'package:http/http.dart' as http;

class PacienteConsumer {
  static const String apiUrl = 'http://192.168.0.107:8081/api/v1';

  Future<List<PacienteModel>> list() async {
    Uri url = Uri.parse(apiUrl + '/paciente/');
    http.Response response = await http.get(url);

    List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));

    return list
        .map<PacienteModel>((dynamic item) => PacienteModel.fromJson(item))
        .toList();
  }

}
