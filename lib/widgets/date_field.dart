import 'package:anlix_front/utils/date_validator.dart';
import 'package:flutter/material.dart';

class DateField extends StatefulWidget {
  final String label;
  final DateEditingController? controller;

  //addDateValidator
  final DateTime? initialValue;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final dynamic locale;
  final String format;
  final String mask;
  final InputDecoration? decoration;

  const DateField({
    this.label = '',
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.locale = 'pt_br',
    this.format = 'dd/MM/yyyy',
    this.mask = '##/##/####',
    this.decoration,
    Key? key,
  })  : assert(initialValue == null || controller == null,
            'initialValue or controller must be null.'),
        super(key: key);

  @override
  DateFieldState createState() => DateFieldState();
}

class DateFieldState extends State<DateField> {
  DateValidator? _validator;
  DateEditingController? _controller;

  DateEditingController get _effectiveController =>
      widget.controller ?? _controller!;

  @override
  void initState() {
    super.initState();

    _validator = DateValidator(
      locale: widget.locale,
      format: widget.format,
    );

    if (widget.controller == null) {
      _controller = DateEditingController(dateTime: widget.initialValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _effectiveController,
      keyboardType: TextInputType.datetime,
      minLines: 1,
      maxLength: widget.mask.length,
      enabled: widget.enabled,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: false,
        labelText: widget.label,
        counterText: '',
      ).copyWith(
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today_outlined),
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: _effectiveController.date ?? DateTime.now(),
              firstDate: widget.firstDate ?? DateTime(1900),
              lastDate: widget.lastDate ?? DateTime(2100),
            );

            _effectiveController.date = selectedDate;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }
}

class DateEditingController extends TextEditingController {
  DateEditingController({DateTime? dateTime})
      : super(text: dateTime == null ? '' : DateValidator().format(dateTime));

  DateEditingController.fromValue(TextEditingValue value)
      : super.fromValue(value);

  DateTime? get date => DateValidator().parse(text);

  set date(DateTime? date) =>
      text = date == null ? '' : DateValidator().format(date);
}
