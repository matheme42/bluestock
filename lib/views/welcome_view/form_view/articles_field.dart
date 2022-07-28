import 'package:bluestock/context/context.dart';
import 'package:bluestock/dart/import.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ArticlesField extends StatelessWidget {
  const ArticlesField({Key? key, required this.inventory}) : super(key: key);

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    var appContext = BluestockContext.of(context);
    return MaterialButton(
      padding: EdgeInsets.zero,
      elevation: 0,
      splashColor: Colors.transparent,
      onPressed: () => Import.articlesCsv(context, inventory),
      child: ValueListenableBuilder(
          valueListenable: Import.articleCsvInLoading,
          builder: (context, value, _) {
            TextEditingController a = TextEditingController();
            if (appContext.articleLoadedDate != null) {
              a.text =
                  "${'articlebasedate'.tr} ${DateFormat.yMd().format(appContext.articleLoadedDate!)}";
            }
            return TextFormField(
              enabled: false,
              controller: a,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.white),
                counterStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white),
                helperStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'Articles',
                prefixIcon: const Icon(
                  Icons.article,
                  color: Colors.white,
                ),
                counter: ValueListenableBuilder(
                  valueListenable: Import.articleCsvInLoading,
                  builder: (context, value, _) {
                    return Text(
                      appContext.articleStrings.isEmpty
                          ? 'importer_article'.tr
                          : 'update'.tr,
                      style: const TextStyle(color: Colors.white38),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
