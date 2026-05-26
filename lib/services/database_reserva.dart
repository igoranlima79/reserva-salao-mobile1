import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseReserva {
  static final DatabaseReserva instancia =
      DatabaseReserva._interno();

  static Database? _banco;

  DatabaseReserva._interno();

  factory DatabaseReserva() => instancia;

  Future<Database> get banco async {
    _banco ??= await _inicializar();
    return _banco!;
  }

  Future<Database> _inicializar() async {
    final caminho = join(
      await getDatabasesPath(),
      'reserva_salao.db',
    );

    return await openDatabase(
      caminho,

      version: 1,

      onConfigure: (db) async {
        await db.execute(
          'PRAGMA foreign_keys = ON',
        );
      },

      onCreate: _criarTabelas,

      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _criarTabelas(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        telefone TEXT NOT NULL,
        apartamento TEXT NOT NULL,
        perfil TEXT NOT NULL,
        bloqueado INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE reservas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT NOT NULL,
        usuario_id INTEGER NOT NULL,

        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id)
        ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // futuras migrações
  }
}