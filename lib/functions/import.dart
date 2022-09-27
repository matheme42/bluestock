import 'dart:convert';
import 'dart:io';

import 'package:bluestock/context/context.dart';
import 'package:bluestock/functions/checker.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/shared_preferences/shared_preference_controller.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Import {
  static void sitesCsv(BuildContext context) async {
    BluestockContext appContext = BluestockContext.of(context);
    FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result == null) return;
    final input = File(result.files.first.path!).openRead();
    final fields = await input
        .transform(latin1.decoder)
        .transform(const CsvToListConverter(
            fieldDelimiter: BluestockContext.csvDelimitor,
            shouldParseNumbers: false))
        .toList();

    if (fields.isEmpty || fields.length == 1) {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
          context,
          const CustomSnackBar.error(
            maxLines: 10,
            textScaleFactor: 0.9,
            message: "fichier vide",
          ),
          displayDuration: const Duration(seconds: 5));
    }

    fields.removeAt(0);
    for (var lst in fields) {
      if (lst.length > 4) {
        lst.removeRange(4, lst.length);
      }
    }
    // ignore: use_build_context_synchronously
    var error = Checker.checkSites(fields, context);
    if (error != 0) {
      return;
    }
    appContext.sites.clear();
    appContext.siteNames.clear();
    List<String> dataStrings = [];
    for (var data in fields) {
      dataStrings.add(data.toString().substring(1, data.toString().length - 1));
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
  }

  static ValueNotifier<bool> articleCsvInLoading = ValueNotifier(false);

  static void articlesCsv(BuildContext context, Inventory? inventory) async {
    if (inventory == null || articleCsvInLoading.value == true) return;
    FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result == null) return;
    articleCsvInLoading.value = true;
    final input = File(result.files.first.path!).openRead();
    CsvToListConverter c = const CsvToListConverter(
        fieldDelimiter: BluestockContext.csvDelimitor,
        shouldParseNumbers: false);
    final fields = await input.transform(latin1.decoder).transform(c).toList();

    if (fields.isEmpty || fields.length == 1) {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
          context,
          const CustomSnackBar.error(
            maxLines: 10,
            textScaleFactor: 0.9,
            message: "fichier vide",
          ),
          displayDuration: const Duration(seconds: 5));
    }

    fields.removeAt(0);
    for (var lst in fields) {
      if (lst.length > 11) {
        lst.removeRange(11, lst.length);
      }
      for (int i = 0; i < lst.length; i++) {
        lst[i] = lst[i].trim();
      }
    }

    // ignore: use_build_context_synchronously
    var error = Checker.checkArticle(fields, context);

    if (error != 0) {
      articleCsvInLoading.value = false;
      return;
    }
    // ignore: use_build_context_synchronously
    BluestockContext appContext = BluestockContext.of(context);
    appContext.articleStrings.clear();
    for (var elm in fields) {
      appContext.articleStrings.add(elm.join(BluestockContext.csvDelimitor));
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

    if (result == null) {
      return;
    }
    final input = File(result.files.first.path!).openRead();
    final fields1 = input.transform(latin1.decoder);
    final fields = await fields1
        .transform(const CsvToListConverter(
            fieldDelimiter: BluestockContext.csvDelimitor,
            shouldParseNumbers: false))
        .toList();

    if (fields.isEmpty || fields.length == 1) {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
          context,
          const CustomSnackBar.error(
            maxLines: 10,
            textScaleFactor: 0.9,
            message: "fichier vide",
          ),
          displayDuration: const Duration(seconds: 5));
    }

    fields.removeAt(0);
    for (var lst in fields) {
      if (lst.length > 1) {
        lst.removeRange(1, lst.length);
      }
    }
    // ignore: use_build_context_synchronously
    var error = Checker.checkProcess(fields, context);
    if (error != 0) {
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
  }
}
