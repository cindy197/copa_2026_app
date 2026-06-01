import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/jogo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('copa2026.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jogos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timeA TEXT NOT NULL,
        timeB TEXT NOT NULL,
        golsA INTEGER DEFAULT 0,
        golsB INTEGER DEFAULT 0,
        data TEXT,
        estadio TEXT,
        grupo TEXT,
        status TEXT DEFAULT 'agendado'
      )
    ''');
  }

  Future<int> insertJogo(Jogo jogo) async {
    final db = await database;
    return await db.insert('jogos', jogo.toMap());
  }

  Future<List<Jogo>> getAllJogos() async {
    final db = await database;
    final maps = await db.query('jogos', orderBy: 'data ASC');
    return maps.map((map) => Jogo.fromMap(map)).toList();
  }

  Future<Jogo?> getJogoById(int id) async {
    final db = await database;
    final maps = await db.query('jogos', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Jogo.fromMap(maps.first);
    return null;
  }

  Future<int> updateJogo(Jogo jogo) async {
    final db = await database;
    return await db.update('jogos', jogo.toMap(),
        where: 'id = ?', whereArgs: [jogo.id]);
  }

  Future<int> deleteJogo(int id) async {
    final db = await database;
    return await db.delete('jogos', where: 'id = ?', whereArgs: [id]);
  }
}
