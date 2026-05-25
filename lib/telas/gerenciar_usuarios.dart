import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service_interface.dart';

class GerenciarUsuariosTela extends StatefulWidget {
  final UsuarioService service;

  const GerenciarUsuariosTela({
    super.key,
    required this.service,
  });

  @override
  State<GerenciarUsuariosTela> createState() => _GerenciarUsuariosTelaState();
}

class _GerenciarUsuariosTelaState extends State<GerenciarUsuariosTela> {
  static const _azulPrincipal = Colors.blueAccent;
  
  List<Usuario> _usuarios = [];
  List<Usuario> _filtrados = [];
  bool _carregando = true;
  final _buscaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregar();
    _buscaCtrl.addListener(_filtrar);
  }

  @override
  void dispose() {
    _buscaCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final lista = await widget.service.listar();
    setState(() {
      _usuarios = lista;
      _filtrar();
      _carregando = false;
    });
  }

  void _filtrar() {
    final q = _buscaCtrl.text.toLowerCase();
    setState(() {
      _filtrados = q.isEmpty
          ? List.from(_usuarios)
          : _usuarios
              .where((u) =>
                  u.nome.toLowerCase().contains(q) ||
                  u.email.toLowerCase().contains(q) ||
                  u.telefone.toLowerCase().contains(q) ||
                  u.apartamento.toLowerCase().contains(q) ||
                  u.perfil.toLowerCase().contains(q))
              .toList();
    });
  }

  Future<void> _abrirFormulario({Usuario? usuario}) async {
    final nomeCtrl = TextEditingController(text: usuario?.nome ?? '');
    final emailCtrl = TextEditingController(text: usuario?.email ?? '');
    final telefoneCtrl = TextEditingController(text: usuario?.telefone ?? '');
    final aptoCtrl = TextEditingController(text: usuario?.apartamento ?? '');
    String perfilSelecionado = usuario?.perfil ?? 'Usuário';
    final perfis = ['Admin', 'Editor', 'Usuário'];
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(
                usuario == null ? Icons.person_add : Icons.edit,
                color: _azulPrincipal,
              ),
              const SizedBox(width: 8),
              Text(
                usuario == null ? 'Novo Usuário' : 'Editar Usuário',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _campo(
                    controller: nomeCtrl,
                    label: 'Nome completo',
                    icon: Icons.person_outline,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 14),
                  _campo(
                    controller: emailCtrl,
                    label: 'E-mail',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
                      if (!v.contains('@')) return 'E-mail inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _campo(
                    controller: telefoneCtrl,
                    label: 'Telefone',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Informe o telefone' : null,
                  ),
                  const SizedBox(height: 14),
                  _campo(
                    controller: aptoCtrl,
                    label: 'Apartamento',
                    icon: Icons.home_outlined,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Informe o apartamento' : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: perfilSelecionado,
                    decoration: InputDecoration(
                      labelText: 'Perfil',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color:_azulPrincipal, width: 2),
                      ),
                    ),
                    items: perfis
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) => setLocal(() => perfilSelecionado = v!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _azulPrincipal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: Icon(usuario == null ? Icons.save : Icons.check),
              label: Text(usuario == null ? 'Cadastrar' : 'Salvar'),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(ctx);

                final novo = Usuario(
                  id: usuario?.id,
                  nome: nomeCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  telefone: telefoneCtrl.text.trim(),
                  apartamento: aptoCtrl.text.trim(),
                  perfil: perfilSelecionado,
                  bloqueado: usuario?.bloqueado ?? false,
                );

                if (usuario == null) {
                  await widget.service.cadastrar(novo);
                } else {
                  await widget.service.atualizar(novo);
                }

                _carregar();
                _mostrarSnack(usuario == null
                    ? 'Usuário cadastrado!'
                    : 'Usuário atualizado!');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarExclusao(Usuario u) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Excluir Usuário'),
          ],
        ),
        content: Text('Deseja excluir "${u.nome}"?\nEssa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.delete_forever),
            label: const Text('Excluir'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (ok == true) {
      await widget.service.excluir(u.id!);
      _carregar();
      _mostrarSnack('Usuário excluído.');
    }
  }

  Future<void> _alterarBloqueio(Usuario u) async {
    await widget.service.alterarBloqueio(u.id!, !u.bloqueado);
    _carregar();
    _mostrarSnack(u.bloqueado ? 'Usuário desbloqueado.' : 'Usuário bloqueado.');
  }

  void _mostrarSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _azulPrincipal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: _azulPrincipal,
        foregroundColor: Colors.white,
        title: const Text(
          'Gerenciar Usuários',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Atualizar lista',
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _azulPrincipal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Novo Usuário'),
        onPressed: () => _abrirFormulario(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _buscaCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar por nome, e-mail, apartamento ou perfil...',
                prefixIcon: const Icon(Icons.search, color: _azulPrincipal),
                suffixIcon: _buscaCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _buscaCtrl.clear();
                          _filtrar();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_filtrados.length} usuário(s) encontrado(s)',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),

          Expanded(
            child: _carregando
                ? const Center(
                    child: CircularProgressIndicator(color: _azulPrincipal),
                  )
                : _filtrados.isEmpty
                    ? _telaVazia()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                        itemCount: _filtrados.length,
                        itemBuilder: (_, i) => _cardUsuario(_filtrados[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _cardUsuario(Usuario u) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: u.bloqueado ? Colors.red[100] : Colors.blue[100],
          child: Text(
            u.nome.isNotEmpty ? u.nome[0].toUpperCase() : '?',
            style: TextStyle(
              color: u.bloqueado ? Colors.red : _azulPrincipal,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                u.nome,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (u.bloqueado)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.block, color: Colors.red[700], size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'Bloqueado',
                      style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    u.email,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  u.telefone,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.home_outlined, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Apto ${u.apartamento}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.badge_outlined, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  u.perfil,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          icon: const Icon(Icons.more_vert),
          onSelected: (acao) {
            switch (acao) {
              case 'editar':
                _abrirFormulario(usuario: u);
                break;
              case 'bloquear':
                _alterarBloqueio(u);
                break;
              case 'excluir':
                _confirmarExclusao(u);
                break;
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'editar',
              child: ListTile(
                leading: Icon(Icons.edit_outlined, color: _azulPrincipal),
                title: Text('Editar'),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            PopupMenuItem(
              value: 'bloquear',
              child: ListTile(
                leading: Icon(
                  u.bloqueado ? Icons.lock_open : Icons.block,
                  color: u.bloqueado ? Colors.green : Colors.orange,
                ),
                title: Text(u.bloqueado ? 'Desbloquear' : 'Bloquear'),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'excluir',
              child: ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Excluir', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _telaVazia() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            _buscaCtrl.text.isNotEmpty
                ? 'Nenhum usuário encontrado'
                : 'Nenhum usuário cadastrado',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          if (_buscaCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.clear),
              label: const Text('Limpar busca'),
              onPressed: () {
                _buscaCtrl.clear();
                _filtrar();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _azulPrincipal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
