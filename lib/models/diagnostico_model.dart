import 'package:anlix_front/models/paciente_model.dart';

class DiagnosticoModel {
  int id = -1;
  PacienteModel? paciente;
  String epoc = '';
  String tipo = '';
  double valor = double.nan;
  DateTime data = DateTime(1900);

  DiagnosticoModel();

  DiagnosticoModel.fromJson(Map<String, dynamic> map)
    : id = map['id'] ?? -1,
      epoc = map['epoc'] ?? '',
      tipo = map['tipo'] ?? '',
      valor = map['valor'] ?? double.nan,
      data = DateTime.parse(map['data']),
      paciente = map['paciente'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};

    map['id'] = id;
    map['epoc'] = epoc;
    map['tipo'] = tipo;
    map['valor'] = valor;
    map['data'] = data;
    map['paciente'] = paciente;

    return map;
  }




}
