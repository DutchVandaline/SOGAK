import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//SQFlite에서는 Bool타입이 존재하지 X. 따라서 INT 타입 0과 1로 선언함.

class DBHelper {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(
      join(await getDatabasesPath(), 'tokens.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tokens(id TEXT PRIMARY KEY, tokenName TEXT)",
        );
      },
      version: 1,
    );
    return _db;
  }

  Future<void> insertToken(UserToken userToken) async {
    final Database db = await database;
    await db.insert(
      'tokens',
      userToken.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("insert userToken $userToken");
  }

  Future<void> deleteToken(String id) async {
    final db = await database;

    await db.delete(
      'tokens',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> countToken() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM tokens')) as Future<int>;
  }

  Future<List<UserToken>> findToken(String id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
    await db.query('tokens', where: 'id = ?', whereArgs: [id]);

    return List.generate(maps.length, (i) {
      return UserToken(
          id: maps[i]['id'],
          tokenName: maps[i]['tokenName'],);
    });
  }
}

class UserToken {
  final String id;
  final String tokenName;

  UserToken(
      {required this.id,
        required this.tokenName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tokenName': tokenName,};
  }

  // 각 memo 정보를 보기 쉽도록 print 문을 사용하여 toString
  @override
  String toString() {
    return 'Token{id: $id, tokenName: $tokenName}';
  }
}
