import 'package:bluestock/custom_widget/date_format_picker/src/field.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/views/form_view/form_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../custom_widget/date_format_picker/src/form_field.dart';

class DateField extends StatelessWidget {
  final Inventory inventory;

  const DateField({Key? key, required this.inventory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTimeFormField(
        onDateSelected: (date) => inventory.date = date,
        dateTextStyle: const TextStyle(color: Colors.white),
        initialEntryMode: DatePickerEntryMode.calendar,
        dateFormat: DateFormat.yMd(),
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.white),
          counterStyle: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.white),
          helperStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: 'Date',
          prefixIcon: const Icon(
            Icons.date_range,
            color: Colors.white,
          ),
        ),
        mode: DateTimeFieldPickerMode.date,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: CustomValidator.required);
  }
}
