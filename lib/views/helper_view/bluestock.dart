import 'package:bluestock/context/context.dart';
import 'package:bluestock/widgets/accordeon/accordion.dart';
import 'package:bluestock/widgets/accordeon/controllers.dart';
import 'package:bluestock/widgets/code_image/code_bar_demonstator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpBluestock extends StatelessWidget {
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  const HelpBluestock({Key? key}) : super(key: key);

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
                'help_welcome_page'.tr,
                style: _contentStyle,
              ),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: false,
              leftIcon:
                  const Icon(Icons.qr_code_2_rounded, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header: Text('supported_barcode'.tr,
                  style: const TextStyle(color: Colors.white70)),
              content: const CodeBarDemonstrator(),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.perm_device_information,
                  color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header:
                  const Text('Imei', style: TextStyle(color: Colors.white70)),
              content: Text(BluestockContext.of(context).imeiNo,
                  style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
          ]),
    );
  }
}
