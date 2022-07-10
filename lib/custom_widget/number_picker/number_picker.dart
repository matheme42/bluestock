import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:numberpicker/numberpicker.dart';

class ArticleNumberPicker extends StatelessWidget {
  final ValueNotifier<int> currentValue;

  const ArticleNumberPicker({Key? key, required this.currentValue})
      : super(key: key);

  void _buildPopupDialog(BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TextField(
          autofocus: true,
          showCursor: false,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
          onSubmitted: (String value) {
            if (value.isNotEmpty) {
              currentValue.value = int.parse(value);
            }
            Navigator.pop(context);
          },
        );
      },
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentValue,
        builder: (context, value, child) {
          return Center(
            child: InkWell(
              onTap: () {
                _buildPopupDialog(context);
              },
              child: NumberPicker(
                  axis: Axis.horizontal,
                  value: currentValue.value,
                  minValue: 0,
                  itemCount: 3,
                  itemWidth: 100,
                  haptics: true,
                  maxValue: 1000000000,
                  onChanged: (value) => currentValue.value = value,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26),
                  )),
            ),
          );
        });
  }
}
