import '../models/usuario.dart';

abstract class UsuarioService {
  Future<List<Usuario>> listar();
  Future<void> cadastrar(Usuario usuario);
  Future<void> atualizar(Usuario usuario);
  Future<void> excluir(int id);
  Future<void> alterarBloqueio(int id, bool bloqueado);
}
