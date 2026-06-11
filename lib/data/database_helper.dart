import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/jogo.dart';
import '../models/classificacao_time.dart';

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

  static List<ClassificacaoTime> calcularClassificacao(
    List<Jogo> todosJogos,
    String grupo,
  ) {
    final filtrados = todosJogos.where((j) =>
        j.status == 'finalizado' && j.grupo == grupo);

    final Map<String, _Acumulador> acc = {};

    for (final j in filtrados) {
      final ta = j.timeA ?? '';
      final tb = j.timeB ?? '';
      final ga = j.golsA ?? 0;
      final gb = j.golsB ?? 0;

      acc.putIfAbsent(ta, () => _Acumulador());
      acc[ta]!.jogos++;
      acc[ta]!.golsPro += ga;
      acc[ta]!.golsContra += gb;
      if (ga > gb) { acc[ta]!.vitorias++; }
      else if (ga == gb) { acc[ta]!.empates++; }
      else { acc[ta]!.derrotas++; }

      acc.putIfAbsent(tb, () => _Acumulador());
      acc[tb]!.jogos++;
      acc[tb]!.golsPro += gb;
      acc[tb]!.golsContra += ga;
      if (gb > ga) { acc[tb]!.vitorias++; }
      else if (ga == gb) { acc[tb]!.empates++; }
      else { acc[tb]!.derrotas++; }
    }

    return acc.entries
        .map((e) {
          final a = e.value;
          return ClassificacaoTime(
            time: e.key,
            jogos: a.jogos,
            vitorias: a.vitorias,
            empates: a.empates,
            derrotas: a.derrotas,
            golsPro: a.golsPro,
            golsContra: a.golsContra,
            saldoGols: a.golsPro - a.golsContra,
            pontos: a.vitorias * 3 + a.empates * 1,
          );
        })
        .toList()
      ..sort((a, b) {
        var c = b.pontos.compareTo(a.pontos);
        if (c != 0) return c;
        c = b.saldoGols.compareTo(a.saldoGols);
        if (c != 0) return c;
        return b.golsPro.compareTo(a.golsPro);
      });
  }
}

class _Acumulador {
  int jogos = 0;
  int vitorias = 0;
  int empates = 0;
  int derrotas = 0;
  int golsPro = 0;
  int golsContra = 0;
}
