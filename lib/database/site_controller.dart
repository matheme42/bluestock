import 'package:bluestock/database/database_controller.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/database/models/site.dart';
import 'package:sqflite/sqflite.dart';

class SiteController {
  static final SiteController _siteController = SiteController._internal();
  static final DatabaseController _controller = DatabaseController();

  factory SiteController() {
    return _siteController;
  }

  SiteController._internal();

  Future<Site> insert(Site site, Inventory inventory) async {
    Database db = await _controller.database;
    site.id = await db.insert(_controller.siteTable,
        site.asMap()..addAll({'inventory_id': inventory.id}));
    return site;
  }

  Future<int> update(Site site) async {
    Database db = await _controller.database;
    return await db.update(_controller.siteTable, site.asMap(),
        where: 'id = ?', whereArgs: [site.id]);
  }

  Future<Site> getInventorySite({required int inventoryId}) async {
    Database db = await _controller.database;
    List<Map<String, dynamic>> siteListQuery = [];
    List<Site> sites = [];

    siteListQuery = await db.query(_controller.siteTable,
        where: 'inventory_id = ?', whereArgs: [inventoryId]);
    for (var inventory in siteListQuery) {
      sites.add(Site()..fromMap(inventory));
    }
    return (sites.first);
  }
}
