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
              flex: 13,
            ),
            Flexible(
              flex: 30,
              child: Container(
                color: Colors.white,
                child: SimpleCalculator(
                  hideSurroundingBorder: true,
                  onChanged: (String? a, double? b, String? c) {
                    if (a == '=' && b != null) {
                      if (b.ceil() < 0) {
                        b = 0;
                      }
                      currentValue.value = b.ceil();
                      Navigator.of(context).pop();
                    }
                  },
                  theme: const CalculatorThemeData(
                      displayColor: Colors.white,
                      commandColor: Colors.deepPurpleAccent,
                      expressionColor: Colors.black12,
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                      expressionStyle: TextStyle(color: Colors.black54),
                      commandStyle: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      numColor: Colors.white,
                      operatorColor: Color(0xFF5568B7),
                      operatorStyle: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      numStyle: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      displayStyle: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 50)),
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
                  maxValue: 999999,
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
