import 'dart:convert';
import 'dart:html';

import 'package:anlix_front/models/diagnostico_model.dart';
import 'package:anlix_front/models/paciente_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DiagnosticoConsumer {
  static const String apiUrl = 'http://localhost:8080/api/v1';

  Future<List<DiagnosticoModel>> getLastByPacienteId(int id) async {
    Uri url = Uri.parse(apiUrl + '/diagnostico/paciente/$id/last');
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
      DateTime endDate,) async {
    Map<int, List<DiagnosticoModel>> ret = <int, List<DiagnosticoModel>>{};

    String firstDate = DateFormat('dd-MM-yyyy').format(initDate);
    String lastDate = DateFormat('dd-MM-yyyy').format(endDate);

    for (PacienteModel paciente in pacientes) {
      Uri url = Uri.parse(apiUrl +
          '/diagnostico/paciente/${paciente.id}/filter/$firstDate/$lastDate');
      http.Response response = await http.get(url);

      List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));

      ret[paciente.id] = list
          .map<DiagnosticoModel>(
              (dynamic item) => DiagnosticoModel.fromJson(item))
          .toList();
    }

    return ret;
  }

  Future<Map<int, List<DiagnosticoModel>>> getByListPacienteId(
      List<PacienteModel> pacientes) async {
    Map<int, List<DiagnosticoModel>> ret = <int, List<DiagnosticoModel>>{};

    for (PacienteModel paciente in pacientes) {
      Uri url = Uri.parse(apiUrl + '/diagnostico/paciente/${paciente.id}');
      http.Response response = await http.get(url);

      List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));

      ret[paciente.id] = list
          .map<DiagnosticoModel>(
              (dynamic item) => DiagnosticoModel.fromJson(item))
          .toList();
    }
    return ret;
  }

  Future<List<DiagnosticoModel>> getByPacienteIdAndType(int id,
      String type,) async {
    Uri url = Uri.parse(apiUrl + '/diagnostico/paciente/$id/tipo/$type');
    http.Response response = await http.get(url);

    List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));

    return list
        .map<DiagnosticoModel>(
            (dynamic item) => DiagnosticoModel.fromJson(item))
        .toList();
  }

  Future<void> importFiles(PlatformFile file) async {
    Uri url = Uri.parse(apiUrl + '/diagnostico/import');

    final http.MultipartRequest request = http.MultipartRequest(
      'POST',
      url,
    );

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      file.bytes!,
      filename: file.name,
    ));

    print('Send request');
    http.StreamedResponse resp = await request.send();

    print('Receive result');
    String result = await resp.stream.bytesToString();

    print(resp.statusCode);

    print(result);
  }
}
