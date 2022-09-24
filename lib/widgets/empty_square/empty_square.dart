import 'package:flutter/material.dart';

class EmptySquare extends StatelessWidget {
  const EmptySquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var opacity = 0.3;
    return Column(
      children: [
        Expanded(
          child: Column(children: [
            Flexible(
              child: Container(color: Colors.black.withOpacity(opacity)),
            ),
            Flexible(
                child: Row(
              children: [
                Flexible(
                    flex: 2,
                    child: Container(color: Colors.black.withOpacity(opacity))),
                Flexible(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1)),
                    )),
                Flexible(
                    flex: 2,
                    child: Container(color: Colors.black.withOpacity(opacity))),
              ],
            )),
            Flexible(
              child: Container(color: Colors.black.withOpacity(opacity)),
            ),
          ]),
        ),
      ],
    );
  }
}
