import 'package:bluestock/context/context.dart';
import 'package:bluestock/custom_widget/select_form_field/select_form_field_type.dart';
import 'package:bluestock/dart/import.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/views/welcome_view/form_view/form_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StorageZoneField extends StatelessWidget {
  StorageZoneField({Key? key, required this.inventory}) : super(key: key);

  final Inventory inventory;
  final fieldKey = GlobalKey<SelectFormFieldState>();

  @override
  Widget build(BuildContext context) {
    var appContext = BluestockContext.of(context);
    return ValueListenableBuilder(
        valueListenable: appContext.siteLoaded,
        builder: (context, val, _) {
          final List<Map<String, dynamic>> s = [];
          for (var site in appContext.sites) {
            s.add({
              'value': site.name,
              'label': site.name,
            });
          }
          if (s.isEmpty) {
            s.add({
              'value': '',
              'label': '',
            });
          }
          return SelectFormField(
            key: fieldKey,
            type: SelectFormFieldType.dropdown,
            items: s,
            style: const TextStyle(color: Colors.white),
            autovalidate: true,
            validator: CustomValidator.required,
            controller: TextEditingController()..text = '',
            onChanged: (s) {
              inventory.site = appContext.sites.firstWhere((e) => e.name == s);
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
              labelText: 'storage_place'.tr,
              prefixIcon: const Icon(
                Icons.home_work_outlined,
                color: Colors.white,
              ),
              counter: MaterialButton(
                onPressed: () => Import.sitesCsv(context),
                child: Text(
                  s.length == 1
                      ? 'importer_storage'.tr
                      : 'update'.tr,
                  style: const TextStyle(color: Colors.white38),
                ),
              ),
            ),
          );
        });
  }
}
