import 'package:bluestock/controllers/controllers.dart';
import 'package:bluestock/models/models.dart';
import 'package:sqflite/sqflite.dart';

class InventoryController {
  static final InventoryController _inventoryController =
      InventoryController._internal();
  static final DatabaseController _controller = DatabaseController();

  factory InventoryController() {
    return _inventoryController;
  }

  InventoryController._internal();

  Future<Inventory> insert(Inventory inventory) async {
    Database db = await _controller.database;
    inventory.id =
        await db.insert(_controller.inventoryTable, inventory.asMap());
    return inventory;
  }

  Future<int> destroy(Inventory inventory) async {
    Database db = await _controller.database;

    for (var zone in inventory.site.zones) {
      await db.delete(_controller.articleCountTable,
          where: 'zone_id = ?', whereArgs: [zone.id]);
    }
    await db.delete(_controller.zoneTable,
        where: 'site_id = ?', whereArgs: [inventory.site.id]);

    await db.delete(_controller.articleStringTable,
        where: 'site_id = ?', whereArgs: [inventory.site.id]);
    await db.delete(_controller.siteTable,
        where: 'id = ?', whereArgs: [inventory.site.id]);
    return await db.delete(_controller.inventoryTable,
        where: 'id = ?', whereArgs: [inventory.id]);
  }

  Future<int> update(Inventory inventory) async {
    Database db = await _controller.database;
    return await db.update(_controller.inventoryTable, inventory.asMap(),
        where: 'id = ?', whereArgs: [inventory.id]);
  }

  Future<List<Inventory>> getInventories() async {
    Database db = await _controller.database;
    List<Map<String, dynamic>> inventoryListQuery = [];
    List<Inventory> inventories = [];
    inventoryListQuery = await db.query(_controller.inventoryTable);
    for (var inventoryData in inventoryListQuery) {
      Inventory inventory = Inventory()..fromMap(inventoryData);
      inventory.site =
          await SiteController().getInventorySite(inventoryId: inventory.id!);
      List<Zone> zones =
          await ZoneController().getSiteZone(siteId: inventory.site.id!);
      List<Article> articles =
          await ArticleController().getArticleSite(siteId: inventory.site.id!);
      for (var zone in zones) {
        zone.articlesCount = await ArticleCountController()
            .getArticleCountZone(zone: zone, articles: articles);
      }

      inventory.articles = articles;
      inventory.site.zones.addAll(zones);
      inventories.add(inventory);
    }
    return (inventories);
  }
}
