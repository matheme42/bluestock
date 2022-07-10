import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HelpFileFormat extends StatelessWidget {
  const HelpFileFormat({Key? key}) : super(key: key);

  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  Directory findRoot(FileSystemEntity entity) {
    final Directory parent = entity.parent;
    if (parent.path == entity.path) return parent;
    return findRoot(parent);
  }

  Future<void> exportProcessExempleFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/process_exemple.csv');
    if (await file.exists()) {
      file.delete();
    }

    String line = "process\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "doit etre unique\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "PUI\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "PHARMACIE\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "OUTILLAGE\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "EXTERN\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    await Share.shareFiles([file.path], text: "Fichier d'exemple process.csv");
  }

  Future<void> exportSiteExempleFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/sites_exemple.csv');
    if (await file.exists()) {
      file.delete();
    }
    String line = "secteur,site,numero,lieu\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "*,*,doit etre unique,*\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "RHONE, LYON,172,Armoire\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "RHONE, LYON,184,Armoire 2\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "RHONE, LYON,195,Frigo 1\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "RHONE, LYON,196,Frigo 2\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "ILE DE FRANCE, PARIS,172,Armoire\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    await Share.shareFiles([file.path], text: "Fichier d'exemple site.csv");
  }

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
              leftIcon: const Icon(Icons.import_contacts, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header: const Text('Cette page',
                  style: TextStyle(color: Colors.white70)),
              content: Text('Permet de démarrer un nouvel inventaire',
                  style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.date_range, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header:
                  const Text('Date', style: TextStyle(color: Colors.white70)),
              content: Text(
                  '''Ce champs correspond a la date ou sera réalisé l'inventaire''',
                  style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: false,
              leftIcon:
                  const Icon(Icons.home_work_outlined, color: Colors.white),
              header: const Text(
                'Site',
                style: TextStyle(color: Colors.white70),
              ),
              contentBorderColor: const Color(0xffffffff),
              headerBackgroundColorOpened: Colors.deepPurple,
              content: Column(
                children: [
                  Text(
                      "Ce champs correspond a la liste des différents site détaillé par zone triée par site"
                      " Si ce champs est vide cliquer sur 'ajouter une liste de site'.\n"
                      "puis cliquer sur le fichier CSV séparateur ',' correspondant a la liste de vos zones\n\n"
                      "Retouver un fichier d'exemple ci-dessous\n",
                      style: _contentStyle),
                  MaterialButton(
                    color: Colors.deepPurple,
                    child: const Text(
                      "sites_exemple.csv",
                      style: TextStyle(color: Colors.white70),
                    ),
                    onPressed: () {
                      exportSiteExempleFile();
                    },
                  )
                ],
              ),
            ),
            AccordionSection(
              isOpen: false,
              headerBackgroundColorOpened: Colors.deepPurple,
              leftIcon:
                  const Icon(Icons.list_alt_outlined, color: Colors.white),
              header: const Text('Process',
                  style: TextStyle(color: Colors.white70)),
              content: Column(
                children: [
                  Text(
                      "Ce champs correspond a la liste des process disponible pour l'inventaire."
                      " Si ce champs est vide cliquer sur 'ajouter une liste de process'.\n"
                      "puis cliquer sur le fichier CSV séparateur ',' correspondant a la liste de vos process\n\n"
                      "Retouver un fichier d'exemple ci-dessous\n",
                      style: _contentStyle),
                  MaterialButton(
                    color: Colors.deepPurple,
                    child: const Text(
                      "process_exemple.csv",
                      style: TextStyle(color: Colors.white70),
                    ),
                    onPressed: () {
                      exportProcessExempleFile();
                    },
                  )
                ],
              ),
            ),
          ]),
    );
  }
}
