import 'package:intl/intl.dart';

class DateValidator {
  final DateFormat dateFormat;

  DateValidator({
    String format = 'dd/MM/yyyy',
    String locale = 'pt_br',
    // String mask = '##/##/####',
  }) : dateFormat = DateFormat(format, locale);

  String format(DateTime value) => dateFormat.format(value);

  DateTime? parse(String? text) {
    if (text == null || text.isEmpty) {
      return null;
    } else {
      try {
        return dateFormat.parse(text);
      } catch (e) {
        return null;
      }
    }
  }
}
