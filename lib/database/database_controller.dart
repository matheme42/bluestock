import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Créer class Singleton
class DatabaseController {
  static final DatabaseController _databaseController =
      DatabaseController._internal();
  Database? _database;

  factory DatabaseController() {
    return _databaseController;
  }

  DatabaseController._internal();

  Future<Database> get database async => (_database ?? await _create());

  String inventoryTable = "inventory";
  String siteTable = "site";
  String zoneTable = "zone";
  String articleStringTable = "article_string";
  String articleCountTable = "article_count";

// Créer base de donnée
  Future<Database> _create() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'db.db');

    //open the database
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Creer Base de donnée
      await db.execute(
          'CREATE TABLE $inventoryTable (id INTEGER PRIMARY KEY, articleloaded INTEGER, date TEXT, process TEXT, done INTEGER)');
      await db.execute(
          'CREATE TABLE $siteTable (id INTEGER PRIMARY KEY, inventory_id INTEGER, name TEXT, region TEXT)');
      await db.execute(
          'CREATE TABLE $zoneTable (id INTEGER PRIMARY KEY, site_id INTEGER, name TEXT, numero TEXT, lock INTEGER)');
      await db.execute(
          'CREATE TABLE $articleStringTable (id INTEGER PRIMARY KEY, site_id INTEGER, string TEXT)');
      await db.execute(
          'CREATE TABLE $articleCountTable (id INTEGER PRIMARY KEY, zone_id INTEGER, article_id INTEGER, number INTEGER, commentaire TEXT, codebartype TEXT)');
    });
    return (_database!);
  }
}
