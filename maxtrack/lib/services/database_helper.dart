import 'package:path/path.dart'; // Used to join paths
import 'package:sqflite/sqflite.dart'; // The sqflite package
import 'package:path_provider/path_provider.dart'; // To find the db location

class DatabaseHelper {
  // This makes the class a singleton. It means we will only ever have one instance
  // of this class in our entire app, which is good practice for database helpers.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // This is the actual database connection. It will be initialized later.
  static Database? _database;

  // This is a "getter" that will initialize the database if it's not already.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // This function contains the logic to actually open the database.
  Future<Database> _initDatabase() async {
    // Get the directory path for both Android and iOS to store the database.
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'mtrack.db');

    // Open the database. The 'version' is important for migrations later.
    // The 'onCreate' callback is called only the very first time the db is created.
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // This is the callback function that creates our tables.
  Future<void> _onCreate(Database db, int version) async {
    // We use 'await' to execute the SQL commands one by one.
    await db.execute('''
      CREATE TABLE food_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        calories_per_100g REAL NOT NULL,
        protein_per_100g REAL NOT NULL,
        carbs_per_100g REAL NOT NULL,
        fat_per_100g REAL NOT NULL,
        image_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE log_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        food_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        weight_consumed_g REAL NOT NULL,
        FOREIGN KEY (food_id) REFERENCES food_items (id)
      )
    ''');
  }
}