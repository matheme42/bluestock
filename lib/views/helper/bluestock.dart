import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:bluestock/custom_widget/code_image/code_bar_demonstator.dart';
import 'package:flutter/material.dart';

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
          scaleWhenAnimating: true,
          openAndCloseAnimation: true,
          headerPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
          sectionClosingHapticFeedback: SectionHapticFeedback.light,
          children: [
            AccordionSection(
              isOpen: false,
              leftIcon:
                  const Icon(Icons.import_contacts, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header: const Text('Cette page',
                  style: TextStyle(color: Colors.white70)),
              content: Text(
                'Contient la liste de tous les inventaire réalisé\n'
                'Contient également les inventaires en cours de réalisation',
                style: _contentStyle,
              ),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.date_range, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header: const Text('Code-barres supportés',
                  style: TextStyle(color: Colors.white70)),
              content: const CodeBarDemonstrator(),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
          ]),
    );
  }
}
