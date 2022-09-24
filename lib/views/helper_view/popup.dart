import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

void helpPopup(BuildContext context, Widget child) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return child;
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
  );
}
