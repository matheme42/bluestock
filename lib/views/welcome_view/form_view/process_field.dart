import 'package:bluestock/context/context.dart';
import 'package:bluestock/custom_widget/select_form_field/select_form_field_type.dart';
import 'package:bluestock/dart/import.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/views/welcome_view/form_view/form_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
          return Column(
            children: [
              DropdownSearch<String>(
                  items: appContext.process,
                  dropdownBuilder: (context, process) {
                    if (process == null) return const Text('');
                    return Text(process,
                        style: const TextStyle(color: Colors.white));
                  },
                  onChanged: (process) {
                    inventory.process = process!;
                    fieldKey.currentState?.validate();
                  },
                  popupProps:
                      PopupProps.bottomSheet(emptyBuilder: (context, s) {
                    return Center(
                      child: Text('list_empty'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textScaleFactor: 2),
                    );
                  }, itemBuilder: (context, item, _) {
                    return ListTile(
                        title: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ));
                  }, containerBuilder: (context, child) {
                    return Container(
                      color: const Color(0xFF112473),
                      child: child,
                    );
                  }),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
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
                    ),
                  ),
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: CustomValidator.required),
              Align(
                alignment: const Alignment(1, 0),
                child: MaterialButton(
                  onPressed: () => Import.processCsv(context),
                  child: Text(
                    appContext.process.length == 1
                        ? 'importer_process'.tr
                        : 'update'.tr,
                    style: const TextStyle(color: Colors.white38),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
