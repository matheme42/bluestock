import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
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
        return Column(
          children: [
            const Spacer(
              flex: 10,
            ),
            Flexible(
              flex: 30,
              child: SimpleCalculator(
                onChanged: (String? a, double? b, String? c) {
                  if (a == '='){
                    currentValue.value = b?.ceil() ?? 0;
                    Navigator.of(context).pop();
                  }
                },
                theme: CalculatorThemeData(
                  displayColor: Colors.black,
                  commandColor: Colors.deepPurple,
                  expressionColor: Colors.blueAccent,
                  expressionStyle: TextStyle(color: Colors.white),
                  commandStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                  numColor: Colors.white.withAlpha(200),
                  operatorColor: Color(0xFF112473),
                  operatorStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                  numStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                  displayStyle: TextStyle(fontSize: 80, color: Colors.yellow),
                ),
              ),
            ),
          ],
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
