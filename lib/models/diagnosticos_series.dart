import 'package:charts_flutter/flutter.dart' as charts;

class DiagnosticosSeries {
  final String date;
  final String type;
  final double value;
  final charts.Color barColor;

  DiagnosticosSeries({
    required this.date,
    required this.type,
    required this.value,
    required this.barColor,
  });
}

