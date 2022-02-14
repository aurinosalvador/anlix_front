import 'dart:convert';

import 'package:anlix_front/models/paciente_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class PacienteConsumer {
  static const String apiUrl = 'http://172.17.0.1:8080/api/v1';

  Future<List<PacienteModel>> list() async {
    Uri url = Uri.parse(apiUrl + '/paciente/');
    http.Response response = await http.get(url);

    List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));

    return list
        .map<PacienteModel>((dynamic item) => PacienteModel.fromJson(item))
        .toList();
  }

  Future<Map<String, dynamic>> importFile(PlatformFile file) async {
    Uri url = Uri.parse(apiUrl + '/paciente/import');

    final http.MultipartRequest request = http.MultipartRequest(
      'POST',
      url,
    );

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      file.bytes!,
      filename: file.name,
    ));

    http.StreamedResponse resp = await request.send();

    String result = await resp.stream.bytesToString();

    return <String, dynamic>{
      'status': resp.statusCode,
      'message': result,
    };
  }
}
