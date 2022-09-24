import 'package:bluestock/models/models.dart';
import 'package:bluestock/widgets/date_format_picker/date_field.dart';
import 'package:bluestock/widgets/number_picker/number_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';

class AddArticleCount extends StatelessWidget {
  final Article? article;
  final FocusNode node;
  final ValueNotifier<int> number;
  final TextEditingController textController;
  final ValueNotifier<DateTime?> peremption;
  final Function() onPressed;
  final Widget? codeBar;

  const AddArticleCount({
    Key? key,
    required this.article,
    required this.node,
    required this.number,
    required this.textController,
    required this.onPressed,
    required this.codeBar,
    required this.peremption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => node.unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.center,
                    child: codeBar ?? const SizedBox.shrink()),
              ),
              article != null
                  ? ArticleNumberPicker(currentValue: number)
                  : const SizedBox.shrink(),
              article != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        focusNode: node,
                        controller: textController,
                        decoration: InputDecoration(
                          labelText: 'comment'.tr,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              article != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ValueListenableBuilder(
                        valueListenable: peremption,
                        builder: (context, value, child) {
                          return DateTimeFormField(
                            onDateSelected: (date) => peremption.value = date,
                            dateTextStyle: const TextStyle(color: Colors.black),
                            initialEntryMode: DatePickerEntryMode.calendar,
                            initialDate: peremption.value,
                            dateFormat: DateFormat('dd-MM-yyyy'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'peremption'.tr,
                              prefixIcon: const Icon(
                                Icons.date_range,
                                color: Colors.black,
                              ),
                            ),
                            mode: DateTimeFieldPickerMode.date,
                          );
                        },
                      ))
                  : const SizedBox.shrink(),
              codeBar != null
                  ? MaterialButton(
                      onPressed: onPressed,
                      child: Text(article != null ? 'add'.tr : 'back'.tr),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
