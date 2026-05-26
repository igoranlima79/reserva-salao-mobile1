import 'package:sqflite/sqflite.dart';
import '../models/reserva.dart';
import 'database_reserva.dart';

// ─── Contrato ─────────────────────────────────────────────────────────────────

abstract class ReservaService {
  Future<List<Reserva>> listar();
  Future<List<Reserva>> listarPorUsuario(int usuarioId);
  Future<bool> dataDisponivel(DateTime data);
  Future<void> cadastrar(Reserva reserva);
  Future<void> excluir(int id);
}

// ─── Implementação em memória (testes) ────────────────────────────────────────

class ReservaServiceMemoria implements ReservaService {
  int _nextId = 1;
  final List<Reserva> _reservas = [];

  @override
  Future<List<Reserva>> listar() async => List.from(_reservas);

  @override
  Future<List<Reserva>> listarPorUsuario(int usuarioId) async =>
      _reservas.where((r) => r.usuarioId == usuarioId).toList();

  @override
  Future<bool> dataDisponivel(DateTime data) async {
    return !_reservas.any((r) =>
        r.data.year == data.year &&
        r.data.month == data.month &&
        r.data.day == data.day);
  }

  @override
  Future<void> cadastrar(Reserva reserva) async {
    _reservas.add(reserva.copyWith(id: _nextId++));
  }

  @override
  Future<void> excluir(int id) async {
    _reservas.removeWhere((r) => r.id == id);
  }
}

// ─── Implementação SQLite (produção) ─────────────────────────────────────────

class ReservaServiceSQLite implements ReservaService {
  final DatabaseReserva _db = DatabaseReserva.instancia;

  @override
  Future<List<Reserva>> listar() async {
    final banco = await _db.banco;
    final resultado = await banco.query(
      'reservas',
      orderBy: 'data ASC',
    );
    return resultado.map((m) => Reserva.fromMap(m)).toList();
  }

  @override
  Future<List<Reserva>> listarPorUsuario(int usuarioId) async {
    final banco = await _db.banco;
    final resultado = await banco.query(
      'reservas',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'data ASC',
    );
    return resultado.map((m) => Reserva.fromMap(m)).toList();
  }

  @override
  Future<bool> dataDisponivel(DateTime data) async {
    final banco = await _db.banco;
    final resultado = await banco.query(
      'reservas',
      where: 'data = ?',
      whereArgs: [data.toIso8601String()],
    );
    return resultado.isEmpty;
  }

  @override
  Future<void> cadastrar(Reserva reserva) async {
    final banco = await _db.banco;
    await banco.insert(
      'reservas',
      reserva.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> excluir(int id) async {
    final banco = await _db.banco;
    await banco.delete(
      'reservas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}