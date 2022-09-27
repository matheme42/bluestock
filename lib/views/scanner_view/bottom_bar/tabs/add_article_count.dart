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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: article != null
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: codeBar ?? const SizedBox.shrink()),
                    ),
                    article!.countingUnit != '' || article!.referenceUnit != ''
                        ? Banner(
                            location: BannerLocation.topEnd,
                            color: Colors.deepPurple,
                            message:
                                'x${article!.countingUnit} ${article!.referenceUnit}',
                            child: ArticleNumberPicker(currentValue: number))
                        : ArticleNumberPicker(currentValue: number),
                    Padding(
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
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ValueListenableBuilder(
                          valueListenable: peremption,
                          builder: (context, value, child) {
                            return DateTimeFormField(
                              onDateSelected: (date) => peremption.value = date,
                              dateTextStyle:
                                  const TextStyle(color: Colors.black),
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
                        )),
                    const Divider(color: Colors.transparent),
                    codeBar != null
                        ? MaterialButton(
                            onPressed: onPressed,
                            child: Text('add'.tr),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: codeBar ?? const SizedBox.shrink()),
                  ),
                  const Divider(color: Colors.transparent),
                  codeBar != null
                      ? MaterialButton(
                          onPressed: onPressed,
                          child: Text('back'.tr),
                        )
                      : const SizedBox.shrink()
                ],
              ),
      ),
    );
  }
}
