import 'package:bluestock/context/context.dart';
import 'package:bluestock/functions/import.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/welcome_view/form_view/form_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ArticlesField extends StatelessWidget {
  const ArticlesField({Key? key, required this.inventory}) : super(key: key);

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    var appContext = BluestockContext.of(context);
    return ValueListenableBuilder(
        valueListenable: Import.articleCsvInLoading,
        builder: (context, value, _) {
          TextEditingController a = TextEditingController();
          if (appContext.articleLoadedDate != null) {
            a.text =
                "${'articlebasedate'.tr} ${DateFormat('dd-MM-yyyy').format(appContext.articleLoadedDate!)}";
          }
          return Column(
            children: [
              AbsorbPointer(
                absorbing: true,
                child: TextFormField(
                  enabled: true,
                  controller: a,
                  validator: CustomValidator.required,
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
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Articles',
                    prefixIcon: const Icon(
                      Icons.article,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.9, 0),
                child: ValueListenableBuilder(
                  valueListenable: Import.articleCsvInLoading,
                  builder: (context, value, _) {
                    return MaterialButton(
                        onPressed: () => Import.articlesCsv(context, inventory),
                        child: Text(
                          'update'.tr,
                          style: const TextStyle(color: Colors.white38),
                        ));
                  },
                ),
              ),
            ],
          );
        });
  }
}
