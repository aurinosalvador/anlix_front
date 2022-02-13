import 'package:flutter/material.dart';

class DateField extends StatefulWidget {
  final String label;

  // final DateEditingController? controller;
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
    this.initialValue,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.locale = 'pt_br',
    this.format = 'dd/MM/yyyy',
    this.mask = '##/##/####',
    this.decoration,
  });

  @override
  DateFieldState createState() => DateFieldState();
}

class DateFieldState extends State<DateField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
              initialDate: DateTime.now(),
              firstDate: widget.firstDate ?? DateTime(1900),
              lastDate: widget.lastDate ?? DateTime(2100),
            );

            print(selectedDate.toString());

            // _controller.text = selectedDate.
          },
        ),
      ),
    );
  }
}
