import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HelpInventaire extends StatelessWidget {
  const HelpInventaire({Key? key}) : super(key: key);

  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  Future<void> exportSiteExempleFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/article_exemple.csv');
    if (await file.exists()) {
      file.delete();
    }
    String line = "process,code produit,Dénomination commerciale,DCI,Dénomination interne,Famille,Sous-famille,Unité de comptage,Référence marque / laboratoire,Code Barre/Qrcode\n";
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
          scaleWhenAnimating: true,
          openAndCloseAnimation: true,
          headerPadding: const EdgeInsets.symmetric(
              vertical: 7, horizontal: 15),
          sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
          sectionClosingHapticFeedback: SectionHapticFeedback.light,
          children: [
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.import_contacts, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header: const Text(
                  'Cette page', style: TextStyle(color: Colors.white70)),
              content: Text(
                'Permet de diriger son inventaire', style: _contentStyle,),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.article_outlined, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header: const Text("resumé de l'inventaire",
                  style: TextStyle(color: Colors.white70)),
              content: Text(
                'Donne la liste complete des articles déjà ajoutés à chaque zone',
                style: _contentStyle,),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.upload_file, color: Colors.white),
              headerBackgroundColor: Colors.blue,
              headerBackgroundColorOpened: Colors.deepPurple,
              header: const Text('importer des articles',
                  style: TextStyle(color: Colors.white70)),
              content: Column(
                children: [
                  Text(
                      "cliquer sur 'importer des articles'.\n"
                          "puis cliquer sur le fichier CSV séparateur ',' correspondant a la liste de vos articles\n\n"
                          "Retouver un fichier d'exemple ci-dessous\n",
                      style: _contentStyle),
                  MaterialButton(
                      color: Colors.deepPurple,
                      child: const Text("article_exemple.csv", style: TextStyle(
                          color: Colors.white70
                      ),),
                      onPressed: () => exportSiteExempleFile()
                  )
                ],
              ),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
          ]),
    );
  }

}