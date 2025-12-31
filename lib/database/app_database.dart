import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;
  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expense_tracker.db');

    return await openDatabase(
      path,
      version: 2, // 🔥 IMPORTANT: version bumped
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // =========================
  // 🔹 CREATE TABLES (FRESH)
  // =========================
  Future<void> _onCreate(Database db, int version) async {
    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');

    // Expenses table (FINAL STRUCTURE)
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        amount REAL,
        date TEXT
      )
    ''');

    // Settings table (for future use: budget, theme, etc.)
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  // =========================
  // 🔹 MIGRATION (OLD → NEW)
  // =========================
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Rename old table
      await db.execute('ALTER TABLE expenses RENAME TO expenses_old');

      // Create new table
      await db.execute('''
        CREATE TABLE expenses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category TEXT,
          amount REAL,
          date TEXT
        )
      ''');

      // Migrate data (title → category)
      await db.execute('''
        INSERT INTO expenses (id, category, amount, date)
        SELECT id, title, amount, date FROM expenses_old
      ''');

      // Drop old table
      await db.execute('DROP TABLE expenses_old');
    }
  }
}
