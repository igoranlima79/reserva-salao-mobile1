import 'package:flutter/material.dart';
import 'tela_reservas.dart';
import '../services/reserva_service.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _selecionado = -1;

  static const _azulPrincipal = Colors.blueAccent;
  static const _azulClaro = Color(0xFF42A5F5);
  static const _azulEscuro = Color(0xFF0D47A1);
  static const _azulMedio = Colors.lightBlue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      body: Column(
        children: [
          // ── Imagem topo ──
          Stack(
            children: [
              Image.network(
                'https://i.imgur.com/YgSIHou.jpeg',
                width: double.infinity,
                height: 210,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 210,
                  color: _azulMedio,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.white54, size: 48),
                ),
              ),
              Container(
                width: double.infinity,
                height: 210,
                color: Colors.black.withValues(alpha: 0.25),
              ),
              const Positioned(
                left: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Residencial',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      'Imperial Luxor',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Menu superior ──
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: _azulMedio,
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildItem(Icons.calendar_month_outlined, 'Reservas', 0,
                    rota: TelaReservas(
                      usuarioId: 1,
                      service: ReservaServiceSQLite(),
                    )),
                _buildItem(Icons.check_circle_outline_rounded, 'Check in', 1),
                _buildItem(Icons.output_outlined, 'Check out', 2),
                _buildAvaliacao('Avaliações', 3),
              ],
            ),
          ),

          // ── Conteúdo ──
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bem-vindo ao App de Reserva do Salão de Festas do Condomínio Imperial Luxor. '
                      'Organizar seu evento ficou muito mais simples. '
                      'Com o nosso aplicativo, você pode reservar o salão de festas '
                      'do condomínio de forma rápida, transparente e sem burocracia.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 18),

                    // ── Cabeçalho condôminos ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Condôminos',
                          style: TextStyle(
                            fontSize: 18,
                            color: _azulPrincipal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // TODO: implementar filtro
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _azulPrincipal.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.filter_alt,
                                    size: 22, color: _azulPrincipal),
                                SizedBox(height: 4),
                                Text(
                                  'Filtrar',
                                  style: TextStyle(
                                      fontSize: 12, color: _azulPrincipal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    IconData icon,
    String texto,
    int index, {
    Widget? rota,
  }) {
    final ativo = _selecionado == index;

    return InkWell(
      onTap: () {
        setState(() => _selecionado = index);
        if (rota != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => rota),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: ativo ? _azulClaro.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: ativo ? _azulEscuro : _azulClaro),
            const SizedBox(height: 5),
            Text(
              texto,
              style: TextStyle(
                color: ativo ? _azulEscuro : _azulPrincipal,
                fontSize: 12,
                fontWeight: ativo ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvaliacao(String texto, int index) {
    final ativo = _selecionado == index;

    return InkWell(
      onTap: () => setState(() => _selecionado = index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: ativo ? _azulPrincipal.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (_) => Icon(Icons.star, size: 18,
                    color: ativo ? _azulEscuro : _azulClaro),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              texto,
              style: TextStyle(
                color: ativo ? _azulEscuro : _azulPrincipal,
                fontSize: 12,
                fontWeight: ativo ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}