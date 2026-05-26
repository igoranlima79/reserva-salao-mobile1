import 'package:flutter/material.dart';
import 'tela_inicial.dart';
import 'gerenciar_usuarios.dart';
import '../services/usuario_service_interface.dart';

class HomePage extends StatefulWidget {
  final UsuarioService service;

  const HomePage({
    super.key,
    required this.service,
  });

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color _corPrimaria =
      Colors.blueAccent;

  Future<void>
      _abrirGerenciarUsuarios() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GerenciarUsuariosTela(
          service: widget.service,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔵 Barra superior
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,

        backgroundColor: _corPrimaria,

        foregroundColor: Colors.white,

        title: const Text(
          'Reserva de Salão',

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),

      body: const TelaInicial(),

      // 🔵 Botão inferior
      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .centerFloat,

      floatingActionButton: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        child: ElevatedButton.icon(
          onPressed:
              _abrirGerenciarUsuarios,

          icon: const Icon(
            Icons.manage_accounts,
          ),

          label: const Text(
            'Gerenciar Usuários',

            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                Colors.blueAccent,

            foregroundColor:
                Colors.white,

            minimumSize:
                const Size.fromHeight(56),

            elevation: 4,

            shadowColor:
                Colors.black26,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}