import 'package:bluestock/controllers/controllers.dart';
import 'package:bluestock/models/models.dart';
import 'package:sqflite/sqflite.dart';

class ZoneController {
  static final ZoneController _siteController = ZoneController._internal();
  static final DatabaseController _controller = DatabaseController();

  factory ZoneController() {
    return _siteController;
  }

  ZoneController._internal();

  Future<Zone> insert(Zone zone, Site site) async {
    Database db = await _controller.database;
    zone.id = await db.insert(
        _controller.zoneTable, zone.asMap()..addAll({'site_id': site.id}));
    return zone;
  }

  Future<int> update(Zone zone) async {
    Database db = await _controller.database;
    return await db.update(_controller.zoneTable, zone.asMap(),
        where: 'id = ?', whereArgs: [zone.id]);
  }

  Future<List<Zone>> getSiteZone({required int siteId}) async {
    Database db = await _controller.database;
    List<Map<String, dynamic>> siteListQuery = [];
    List<Zone> zones = [];

    siteListQuery = await db.query(_controller.zoneTable,
        where: 'site_id = ?', whereArgs: [siteId]);
    for (var zone in siteListQuery) {
      zones.add(Zone()..fromMap(zone));
    }
    return (zones);
  }
}
