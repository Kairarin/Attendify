import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DeviceActivity {
  final int? id;
  final String user;
  final DateTime timestamp;
  final String activity;

  DeviceActivity({
    this.id,
    required this.user,
    required this.timestamp,
    required this.activity,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'user': user,
    'timestamp': timestamp.toIso8601String(),
    'activity': activity,
  };

  static DeviceActivity fromMap(Map<String, Object?> m) => DeviceActivity(
    id: m['id'] as int?,
    user: m['user'] as String,
    timestamp: DateTime.parse(m['timestamp'] as String),
    activity: m['activity'] as String,
  );
}

class DeviceActivityDb {
  static final DeviceActivityDb instance = DeviceActivityDb._init();
  static Database? _db;
  DeviceActivityDb._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'device_activity.db');
    _db = await openDatabase(path, version: 1, onCreate: _createDB);
    return _db!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        activity TEXT NOT NULL
      )
    ''');
  }

  Future<void> insert(DeviceActivity entry) async {
    final db = await database;
    await db.insert('activities', entry.toMap());
  }

  Future<List<DeviceActivity>> getAll() async {
    final db = await database;
    final rows = await db.query('activities', orderBy: 'timestamp DESC');
    return rows.map((r) => DeviceActivity.fromMap(r)).toList();
  }
}
