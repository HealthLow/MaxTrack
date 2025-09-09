import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// --- THIS IS THE DATA MODEL ---
// It represents a single food item object in our Dart code.
class FoodItem {
  final int id;
  final String name;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final int isIngredient; // 0 for food, 1 for ingredient

  FoodItem({
    required this.id,
    required this.name,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.isIngredient,
  });

  // Helper constructor to create a FoodItem from a database map.
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      caloriesPer100g: map['calories_per_100g'],
      proteinPer100g: map['protein_per_100g'],
      carbsPer100g: map['carbs_per_100g'],
      fatPer100g: map['fat_per_100g'],
      isIngredient: map['is_ingredient'],
    );
  }
}


// --- THIS IS THE DATABASE HELPER CLASS ---
class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'mtrack.db');
    return await openDatabase(
      path,
      version: 2, // Keep your version at 2
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // This SQL statement now includes ALL the columns from the start.
    await db.execute('''
      CREATE TABLE food_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        calories_per_100g REAL NOT NULL,
        protein_per_100g REAL NOT NULL,
        carbs_per_100g REAL NOT NULL,
        fat_per_100g REAL NOT NULL,
        image_path TEXT,
        is_ingredient INTEGER NOT NULL DEFAULT 0
      )
    ''');
    // ... (Your log_entries table is here too) ...
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE food_items ADD COLUMN is_ingredient INTEGER NOT NULL DEFAULT 0
      ''');
    }
  }

  // --- THIS IS THE CORRECTLY PLACED SEARCH FUNCTION ---
  Future<List<FoodItem>> searchFoodItems(String query) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'food_items',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      limit: 20,
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return FoodItem.fromMap(maps[i]);
    });
  }
}