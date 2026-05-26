import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database_reserva.dart';
import '../models/usuario.dart';
import '../services/usuario_service_interface.dart';

class UsuarioServiceSQLite implements UsuarioService {
  static const String tabela = 'usuarios';

  final DatabaseReserva _db = DatabaseReserva.instancia;

  Future<Database> get _banco async => await _db.banco;

  @override
  Future<List<Usuario>> listar() async {
    try {
      final banco = await _banco;

      final resultado = await banco.query(
        tabela,
        orderBy: 'nome ASC',
      );

      return resultado.map((m) => Usuario.fromMap(m)).toList();

    } catch (e) {
      debugPrint('Erro ao listar usuários: $e');
      return [];
    }
  }

  @override
  Future<void> cadastrar(Usuario u) async {
    try {
      final banco = await _banco;

      await banco.insert(
        tabela,
        u.toMap()..remove('id'),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

    } catch (e) {
      debugPrint('Erro ao cadastrar usuário: $e');
    }
  }

  @override
  Future<void> atualizar(Usuario u) async {
    if (u.id == null) return;

    try {
      final banco = await _banco;

      await banco.update(
        tabela,
        u.toMap(),
        where: 'id = ?',
        whereArgs: [u.id],
      );

    } catch (e) {
      debugPrint('Erro ao atualizar usuário: $e');
    }
  }

  @override
  Future<void> excluir(int id) async {
    try {
      final banco = await _banco;

      await banco.delete(
        tabela,
        where: 'id = ?',
        whereArgs: [id],
      );

    } catch (e) {
      debugPrint('Erro ao excluir usuário: $e');
    }
  }

  @override
  Future<void> alterarBloqueio(int id, bool bloqueado) async {
    try {
      final banco = await _banco;

      await banco.update(
        tabela,
        {'bloqueado': bloqueado ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );

    } catch (e) {
      debugPrint('Erro ao alterar bloqueio: $e');
    }
  }
}
