import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pohps_checklist.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns to checklist_logs
      await db.execute(
        'ALTER TABLE checklist_logs ADD COLUMN mouth_condition TEXT',
      );
      await db.execute('ALTER TABLE checklist_logs ADD COLUMN notes TEXT');

      // Remove danger_signs from checklist_items if it exists
      await db.delete(
        'checklist_items',
        where: 'id = ?',
        whereArgs: ['danger_signs'],
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE checklist_items (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        time TEXT NOT NULL,
        icon_code_point INTEGER NOT NULL,
        color_value INTEGER NOT NULL,
        is_default INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE checklist_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        checklist_item_id TEXT NOT NULL,
        date TEXT NOT NULL,
        is_completed INTEGER NOT NULL,
        completed_at TEXT,
        mouth_condition TEXT,
        notes TEXT,
        FOREIGN KEY (checklist_item_id) REFERENCES checklist_items (id)
      )
    ''');

    // Insert default items
    await _insertDefaultItems(db);
  }

  Future<void> _insertDefaultItems(Database db) async {
    final defaultItems = [
      {
        'id': 'morning_care',
        'title': 'Perawatan Pagi',
        'description': 'Sikat gigi, bersihkan lidah & cek sariawan.',
        'time': '07:00-08:00',
        'icon_code_point': 0xe69b, // Icons.wb_sunny_outlined
        'color_value': 0xFFFFA500, // Colors.orange
        'is_default': 1,
      },
      {
        'id': 'afternoon_care',
        'title': 'Perawatan Siang',
        'description': 'Bersihkan sisa makanan setelah makan siang.',
        'time': '12:00-13:00',
        'icon_code_point': 0xf053, // Icons.cleaning_services_outlined
        'color_value': 0xFF64B5F6, // AppColors.blueSoft (approx)
        'is_default': 1,
      },
      {
        'id': 'night_care',
        'title': 'Perawatan Malam',
        'description': 'Lepas gigi palsu (jika ada) & sikat gigi.',
        'time': '19:00-20:00',
        'icon_code_point': 0xe42d, // Icons.nights_stay_outlined
        'color_value': 0xFF9C27B0, // Colors.purple
        'is_default': 1,
      },
    ];

    for (var item in defaultItems) {
      await db.insert('checklist_items', item);
    }
  }
}
