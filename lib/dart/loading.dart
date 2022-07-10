import 'dart:async';

import 'package:bluestock/context/context.dart';
import 'package:bluestock/database/inventory_controller.dart';
import 'package:bluestock/database/models/site.dart';
import 'package:bluestock/database/models/zone.dart';
import 'package:bluestock/database/shared_preference_controller.dart';
import 'package:flutter/material.dart';

class Loading {
  /// Cette fonction permet de charger tous les inventaire en memoire
  /// A appeler au démarrage de l'application afin d'obtenir la liste des
  /// inventaire
  static Future<void> _getInventory(BuildContext context) async {
    BluestockContext appContext = BluestockContext.of(context);
    appContext.inventories.addAll(await InventoryController().getInventories());
  }

  /// Cette fonction permet de recuperer la liste des sites stocker dans
  /// les SharedPreferences.
  /// Les converties automatique en Site() et Zone()
  /// Les ajoutes également au context de l'application
  static Future<void> _getSite(BuildContext context) async {
    BluestockContext appContext = BluestockContext.of(context);
    List<Site> sites = appContext.sites;

    List<String> siteString = await SharedPreferenceController.getSite();
    for (var sitData in siteString) {
      var data = sitData.toLowerCase().split((','));

      late Site s;
      try {
        s = sites.firstWhere((s) => s.name == data[1] && s.region == data[0]);
        appContext.siteNames.add(data[1]);
      } catch (_) {
        s = Site();
        s.region = data[0];
        s.name = data[1];
        appContext.sites.add(s);
      }
      Zone z = Zone();
      z.name = data[3];
      z.num = data[2];
      s.zones.add(z);
    }
  }

  /// Cette fonction permet de récupérer les SharedPreferences
  /// et de configurer le context de l'application en concequence
  static Future<void> _getSharedPreference(BuildContext context) async {
    BluestockContext appContext = BluestockContext.of(context);
    appContext.process.addAll(await SharedPreferenceController.getProcess());
    appContext.cguAccepted.value = await SharedPreferenceController.getCgu();
  }

  /// Permet de charger les configuration de base de l'application
  /// SharedPreference & Sqlite
  static Future<void> loading(BuildContext context) async {
    await _getSharedPreference(context);
    // ignore: use_build_context_synchronously
    await _getSite(context);
    // ignore: use_build_context_synchronously
    await _getInventory(context);
  }
}