import 'dart:io';

import 'package:skripsiii/model/userModel.dart';
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
        password TEXT(100),
        userID TEXT(100)
      )''');
  }

  Future<bool> checkLogin() async {
    final Database db = await instance.database;
    var res = await db.rawQuery('''
    SELECT * FROM user
    ''');
    print(res.isNotEmpty);
    return res.isNotEmpty;
  }

  getUser() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM user");
    print(res);
    // return res.map((e) => UserModel.fromJson(e)).toList();
  }

  loginUser(Map<String, dynamic> user) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT INTO user (email,userid,password)"
        "VALUES (?,?,?)",
        [
          user['email'],
          user['password'],
          user['userID'],
        ]);
    return res;
  }

  logoutUser() async {
    final db = await database;
    db.delete("user");
  }
}
