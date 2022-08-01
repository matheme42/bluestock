import 'package:bluestock/context/context.dart';
import 'package:bluestock/custom_widget/select_form_field/select_form_field_type.dart';
import 'package:bluestock/dart/import.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/database/models/site.dart';
import 'package:bluestock/views/welcome_view/form_view/form_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
          return Column(
            children: [
              DropdownSearch<Site>(
                  items: appContext.sites,
                  dropdownBuilder: (context, site) {
                    if (site == null) return const Text('');
                    return Text(site.name,
                        style: const TextStyle(color: Colors.white));
                  },
                  onChanged: (site) {
                    inventory.site = site!;
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
                      item.name,
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
                      labelText: 'storage_place'.tr,
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
                  onPressed: () => Import.sitesCsv(context),
                  child: Text(
                    s.length == 1 ? 'importer_storage'.tr : 'update'.tr,
                    style: const TextStyle(color: Colors.white38),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
