import 'package:bluestock/widgets/accordeon/accordion.dart';
import 'package:bluestock/widgets/accordeon/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpInventaire extends StatelessWidget {
  const HelpInventaire({Key? key}) : super(key: key);

  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.8),
      child: Accordion(
          maxOpenSections: 1,
          headerBackgroundColorOpened: Colors.black54,
          scaleWhenAnimating: false,
          openAndCloseAnimation: true,
          headerPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
          sectionClosingHapticFeedback: SectionHapticFeedback.light,
          children: [
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.import_contacts, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header: Text('this_page'.tr,
                  style: const TextStyle(color: Colors.white70)),
              content: Text(
                'help_inventory_page'.tr,
                style: _contentStyle,
              ),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.article_outlined, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header: Text("inventory_resume".tr,
                  style: const TextStyle(color: Colors.white70)),
              content: Text(
                'help_inventory_resume'.tr,
                style: _contentStyle,
              ),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
          ]),
    );
  }
}
