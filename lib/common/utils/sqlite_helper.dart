import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  static final SQLiteHelper _instance = SQLiteHelper._internal();
  static Database? _database;

  factory SQLiteHelper() => _instance;

  SQLiteHelper._internal();

  /// 获取数据库实例
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 初始化数据库
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'latter.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 第一次创建数据库时执行
  Future _onCreate(Database db, int version) async {
    // 会话
    await db.execute('''
      CREATE TABLE IF NOT EXISTS conversation (
        id INTEGER PRIMARY KEY,
        user1Id INTEGER NOT NULL,
        user2Id INTEGER NOT NULL,
        lastMessage TEXT,
        lastTimestamp INTEGER,
        unreadCountUser1 INTEGER DEFAULT 0,
        unreadCountUser2 INTEGER DEFAULT 0
      );
    ''');
    // 消息
    await db.execute('''
      CREATE TABLE IF NOT EXISTS message (
        id INTEGER PRIMARY KEY,
        conversationId INTEGER,
        senderUid INTEGER,
        receiverUid INTEGER,
        content TEXT,
        attachmentUrl TEXT,
        messageType TEXT,
        isRead INTEGER DEFAULT 0,
        isRevoked INTEGER DEFAULT 0,
        deleted INTEGER DEFAULT 0,
        createdAt TEXT,
        createdTimestamp INTEGER
      );
    ''');
    // 相关用户
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user (
        uid INTEGER PRIMARY KEY,
        username TEXT,
        screenName TEXT,
        profileImageUrl TEXT
      );
    ''');

    // 通知
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notification (
        id INTEGER PRIMARY KEY,
        type TEXT,
        actorUid INTEGER,
        actorNickname TEXT,
        actorAvatar TEXT,
        actorContent TEXT,
        sourceId INTEGER,
        sourceUid INTEGER,
        sourceType TEXT,
        sourcePreview TEXT,
        isRead INTEGER,
        createdAt TEXT,
        createdTimestamp INTEGER
      )
    ''');

  }

  /// 数据库升级时执行
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // TODO: 版本升级时处理
  }

  /// 通用插入/替换
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 通用更新
  Future<int> update(
      String table,
      Map<String, dynamic> data,
      String where,
      List<dynamic> whereArgs,
      ) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  /// 通用删除
  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  /// 通用查询
  Future<List<Map<String, dynamic>>> query(
      String table, {
        String? where,
        List<dynamic>? whereArgs,
        String? orderBy,
        int? limit,
      }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<Object?>? arguments]) async {
    final db = await database;
    return db.rawQuery(sql, arguments);
  }

  /// 清空整个表
  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  /// 删除整个数据库（谨慎）
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    await deleteDatabase(path);
  }
}