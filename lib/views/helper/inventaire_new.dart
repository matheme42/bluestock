import 'dart:convert';
import 'dart:io';

import 'package:bluestock/custom_widget/accordeon/accordion.dart';
import 'package:bluestock/custom_widget/accordeon/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  Future<void> exportArticleExempleFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/article_exemple.csv');
    if (await file.exists()) {
      file.delete();
    }
    String line =
        "process,code produit,Dénomination commerciale,DCI,Dénomination interne,Famille,Sous-famille,Unité de comptage,Référence marque / laboratoire,Code Barre/Qrcode\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
    line = "*,doit etre unique,*,*,*,*,*,*,*,*\n";
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
              content: Text('help_start_inventory'.tr,
                  style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
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
                  Text("help_start_inventory_process".tr,
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
                  Text("help_start_inventory_site".tr, style: _contentStyle),
                  MaterialButton(
                    color: Colors.deepPurple,
                    child: const Text(
                      "sites_exemple.csv",
                      style: TextStyle(color: Colors.white70),
                    ),
                    onPressed: () => exportSiteExempleFile()
                  )
                ],
              ),
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.date_range, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header:
                  const Text('Date', style: TextStyle(color: Colors.white70)),
              content: Text('help_start_inventory_date'.tr, style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.upload_file, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header: const Text('articles',
                  style: TextStyle(color: Colors.white70)),
              content: Column(
                children: [
                  Text("help_start_inventory_article".tr, style: _contentStyle),
                  MaterialButton(
                      color: Colors.deepPurple,
                      child: const Text(
                        "article_exemple.csv",
                        style: TextStyle(color: Colors.white70),
                      ),
                      onPressed: () => exportArticleExempleFile())
                ],
              ),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
          ]),
    );
  }
}
