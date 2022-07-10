import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/views/form_view/form_view.dart';
import 'package:bluestock/views/form_view/process_field.dart';
import 'package:bluestock/views/form_view/storage_zone_field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class FormBody extends StatelessWidget {
  const FormBody({Key? key, required this.inventory}) : super(key: key);

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DateTimeFormField(
                onDateSelected: (date) => inventory.date = date,
                  dateTextStyle: const TextStyle(color: Colors.white),
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
                  validator: CustomValidator.required),
              StorageZoneField(inventory: inventory),
              ProcessField(inventory: inventory)
            ],
          ),
        ),
    );
  }
}
