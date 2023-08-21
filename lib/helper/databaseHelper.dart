 import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "skripsiii.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        email TEXT(100),
        userID TEXT(100),
        role TEXT(10)
      )''');
  }

  Future<bool> checkLogin() async {
    final Database db = await instance.database;
    var res = await db.rawQuery('''
    SELECT * FROM user
    ''');
    return res.isNotEmpty;
  }

  getUser() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM user");
    // return res.map((e) => UserModel.fromJson(e)).toList();
  }

  getUserEmailRoleAndUid() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM user");
    var a = res.toList()[0];
    return {
      'userID': a['userID'],
      'email': a['email'],
      'role': a['role'],
    };
  }

  updateRole(String role, String userid) async {
    final db = await database;
    var res = await db.rawInsert(
        "UPDATE user SET role = ?"
        "WHERE userID = ?",
        [
          role,
          userid,
        ]);
    return res;
  }

  loginUser(Map<String, dynamic> user) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT INTO user (email,userID,role)"
        "VALUES (?,?,?)",
        [
          user['email'],
          user['userID'],
          user['role'],
        ]);
    return res;
  }

  logoutUser() async {
    final db = await database;
    db.delete("user");
  }
}
