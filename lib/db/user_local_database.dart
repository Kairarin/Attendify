// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import '../Models/user_model.dart';
// import 'dart:io';

// class UserLocalDatabase {
//   static Database? _database;

//   static Future<Database> _initDatabase() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final path = join(dir.path, 'attendify.db');

//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute('''
//           CREATE TABLE user(
//             id TEXT PRIMARY KEY,
//             nama TEXT,
//             email TEXT,
//             position TEXT,
//             avatarUrl TEXT
//           )
//         ''');
//       },
//     );
//   }

//   static Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   // 🧠 Simpan user login ke lokal
//   static Future<void> saveUser(UserModel user) async {
//     final db = await database;
//     await db.insert(
//       'user',
//       user.toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   // 📥 Ambil user dari lokal
//   static Future<UserModel?> getUser() async {
//     final db = await database;
//     final result = await db.query('user', limit: 1);

//     if (result.isNotEmpty) {
//       return UserModel.fromJson(result.first);
//     }
//     return null;
//   }

//   // ❌ Logout → hapus user lokal
//   static Future<void> clearUser() async {
//     final db = await database;
//     await db.delete('user');
//   }
// }
