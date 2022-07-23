import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/database/models/site.dart';
import 'package:bluestock/database/models/zone.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class BluestockContext with ChangeNotifier {
  ValueNotifier<bool> updater = ValueNotifier(false);

  ValueNotifier<bool> appLoaded = ValueNotifier(false);
  ValueNotifier<bool> cguAccepted = ValueNotifier(false);
  ValueNotifier<int> siteLoaded = ValueNotifier(0);
  ValueNotifier<int> processLoaded = ValueNotifier(0);

  var scannerController = MobileScannerController(torchEnabled: false);


  List<String> process = [];
  List<String> siteNames = [];
  List<Site> sites = [];
  List<Inventory> inventories = [];
  List<String> articleStrings = [];
  DateTime? articleLoadedDate;

  ValueNotifier<Inventory?> currentInventory = ValueNotifier(null);
  ValueNotifier<Zone?> currentZone = ValueNotifier(null);
  Zone? previousZone;

  static BluestockContext of(BuildContext context, {listen = false}) {
    return Provider.of<BluestockContext>(context, listen: listen);
  }
}
