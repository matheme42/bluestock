import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/dart/checker.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/database/models/site.dart';
import 'package:bluestock/database/models/zone.dart';
import 'package:bluestock/database/shared_preference_controller.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

const csvDelimitor = ',';

class Import {
  static void sitesCsv(BuildContext context) async {
    BluestockContext appContext = BluestockContext.of(context);
    FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      final input = File(result.files.first.path!).openRead();
      final fields = await input
          .transform(latin1.decoder)
          .transform(const CsvToListConverter(
              fieldDelimiter: csvDelimitor, shouldParseNumbers: false))
          .toList();
      fields.removeAt(0);
      var error = Checker.checkSites(fields);
      if (error != 0) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Contenu du fichier incorrect (ligne: $error)',
              textAlign: TextAlign.center),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ));
        return;
      }
      appContext.sites.clear();
      appContext.siteNames.clear();
      List<String> dataStrings = [];
      for (var data in fields) {
        dataStrings
            .add(data.toString().substring(1, data.toString().length - 1));
        List<Site> siteList = appContext.sites
            .where((site) =>
                site.name == data[1].toString().toLowerCase() &&
                site.region == data[0].toString().toLowerCase())
            .toList();
        late Site site;
        if (siteList.isEmpty) {
          site = Site()
            ..region = data[0].toString().toLowerCase()
            ..name = data[1].toString().toLowerCase();
          appContext.sites.add(site);
          appContext.siteNames.add(data[1].toString().toLowerCase());
        } else {
          site = siteList.first;
        }
        site.zones.add(Zone()
          ..name = data[3].toString().toLowerCase()
          ..num = data[2].toString().toLowerCase());
      }
      await SharedPreferenceController.setSite(dataStrings);
      appContext.siteLoaded.value += 1;
    } else {
      // User canceled the picker
    }
  }

  static ValueNotifier<bool> articleCsvInLoading = ValueNotifier(false);

  static void articlesCsv(BuildContext context, Inventory? inventory) async {
    if (inventory == null) return;
    FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result == null) return;
    articleCsvInLoading.value = true;
    final input = File(result.files.first.path!).openRead();
    CsvToListConverter c = const CsvToListConverter(
        fieldDelimiter: csvDelimitor, shouldParseNumbers: false);
    final fields = await input.transform(latin1.decoder).transform(c).toList();
    fields.removeAt(0);

    var error = Checker.checkArticle(fields);
    if (error != 0) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: AutoSizeText('Contenu du fichier incorrect (ligne: $error)',
            textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.orange,
      ));
      articleCsvInLoading.value = false;
      return;
    }
    // ignore: use_build_context_synchronously
    BluestockContext appContext = BluestockContext.of(context);
    appContext.articleStrings.clear();
    for (var elm in fields) {
      appContext.articleStrings.add(elm.toString().toLowerCase());
    }
    appContext.articleLoadedDate = DateTime.now();
    await SharedPreferenceController.setArticlesDate(
        appContext.articleLoadedDate!);
    await SharedPreferenceController.setArticles(appContext.articleStrings);
    articleCsvInLoading.value = false;
  }

  static void processCsv(BuildContext context) async {
    FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      final input = File(result.files.first.path!).openRead();
      final fields1 = input.transform(latin1.decoder);
      final fields = await fields1
          .transform(const CsvToListConverter(
              fieldDelimiter: csvDelimitor, shouldParseNumbers: false))
          .toList();
      fields.removeAt(0);

      var error = Checker.checkProcess(fields);
      if (error != 0) {
// ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: AutoSizeText('Contenu du fichier incorrect (ligne: $error)',
              textAlign: TextAlign.center),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ));
        articleCsvInLoading.value = false;
        return;
      }
// ignore: use_build_context_synchronously
      BluestockContext appContext = BluestockContext.of(context);

      appContext.process.clear();
      for (var elm in fields) {
        appContext.process.add(elm[0].toString().trim().toLowerCase());
      }

// ignore: use_build_context_synchronously
      await SharedPreferenceController.setProcess(appContext.process);
      appContext.processLoaded.value += 1;
    } else {
// User canceled the picker
    }
  }
}
