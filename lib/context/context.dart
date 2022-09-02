import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/database/models/site.dart';
import 'package:bluestock/database/models/zone.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class BluestockContext with ChangeNotifier {

  static const csvDelimitor = ';';

  ValueNotifier<bool> updater = ValueNotifier(false);

  ValueNotifier<bool> appLoaded = ValueNotifier(false);
  ValueNotifier<bool> cguAccepted = ValueNotifier(false);
  bool cguAlreadyAccepted = false;
  ValueNotifier<int> siteLoaded = ValueNotifier(0);
  ValueNotifier<int> processLoaded = ValueNotifier(0);

  Locale language = const Locale('FR', 'fr');

  List<String> process = [];
  List<String> siteNames = [];
  List<Site> sites = [];
  List<Inventory> inventories = [];
  List<String> articleStrings = [];
  DateTime? articleLoadedDate;

  var scannerController = MobileScannerController(torchEnabled: false);
  ValueNotifier<Inventory?> currentInventory = ValueNotifier(null);
  ValueNotifier<Zone?> currentZone = ValueNotifier(null);
  Zone? previousZone;

  static BluestockContext of(BuildContext context, {listen = false}) {
    return Provider.of<BluestockContext>(context, listen: listen);
  }
}
