import 'package:bluestock/context/context.dart';
import 'package:bluestock/custom_widget/select_form_field/select_form_field_type.dart';
import 'package:bluestock/dart/import.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/views/welcome_view/form_view/form_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProcessField extends StatelessWidget {
  ProcessField({Key? key, required this.inventory}) : super(key: key);

  final Inventory inventory;
  final fieldKey = GlobalKey<SelectFormFieldState>();

  @override
  Widget build(BuildContext context) {
    var appContext = BluestockContext.of(context);
    return ValueListenableBuilder(
        valueListenable: appContext.processLoaded,
        builder: (context, val, _) {
          final List<Map<String, dynamic>> p = [];
          for (var process in appContext.process) {
            p.add({
              'value': process,
              'label': process,
            });
          }
          if (p.isEmpty) {
            p.add({
              'value': '',
              'label': '',
            });
          }
          return SelectFormField(
            key: fieldKey,
            type: SelectFormFieldType.dropdown,
            items: p,
            autovalidate: true,
            style: const TextStyle(color: Colors.white),
            controller: TextEditingController()..text = '',
            validator: CustomValidator.required,
            onChanged: (process) {
              inventory.process = process;
              fieldKey.currentState?.validate();
            },
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.white),
              counterStyle: const TextStyle(color: Colors.white),
              hintStyle: const TextStyle(color: Colors.white),
              helperStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderSide: const BorderSide(),
                borderRadius: BorderRadius.circular(20),
              ),
              labelText: 'Process',
              prefixIcon: const Icon(
                Icons.home_work_outlined,
                color: Colors.white,
              ),
              counter: MaterialButton(
                onPressed: () => Import.processCsv(context),
                child: Text(
                  p.length == 1
                      ? 'importer_process'.tr
                      : 'update'.tr,
                  style: const TextStyle(color: Colors.white38),
                ),
              ),
            ),
          );
        });
  }
}
