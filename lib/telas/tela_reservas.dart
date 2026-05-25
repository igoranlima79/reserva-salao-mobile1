import 'package:flutter/material.dart';
import '../models/reserva.dart';
import '../services/reserva_service.dart';

class TelaReservas extends StatefulWidget {
  final int usuarioId;
  final ReservaService service;

  const TelaReservas({
    super.key,
    required this.usuarioId,
    required this.service,
  });

  @override
  State<TelaReservas> createState() => _TelaReservasState();
}

class _TelaReservasState extends State<TelaReservas> {
  DateTime _dataSelecionada = DateTime.now();
  List<DateTime> _datasIndisponiveis = [];
  bool _carregando = true;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _carregarReservas();
  }

  Future<void> _carregarReservas() async {
    setState(() => _carregando = true);
    final reservas = await widget.service.listar();
    setState(() {
      _datasIndisponiveis = reservas.map((r) => r.data).toList();
      _carregando = false;
    });
  }

  bool _dataBloqueada(DateTime data) {
    return _datasIndisponiveis.any((d) =>
        d.year == data.year &&
        d.month == data.month &&
        d.day == data.day);
  }

  String get _dataFormatada =>
      '${_dataSelecionada.day.toString().padLeft(2, '0')}/'
      '${_dataSelecionada.month.toString().padLeft(2, '0')}/'
      '${_dataSelecionada.year}';

  Future<void> _confirmarReserva() async {
    final disponivel =
        await widget.service.dataDisponivel(_dataSelecionada);

    if (!disponivel) {
      _mostrarSnack('Data indisponível! Escolha outra data.', erro: true);
      return;
    }

    setState(() => _salvando = true);

    await widget.service.cadastrar(Reserva(
      data: _dataSelecionada,
      usuarioId: widget.usuarioId,
    ));

    await _carregarReservas();
    setState(() => _salvando = false);

    _mostrarSnack('Reserva confirmada para $_dataFormatada!');
  }

  void _mostrarSnack(String msg, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: erro ? Colors.red : const Color(0xFF1565C0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade700,
        elevation: 0,
        title: const Text(
          'Reservar Salão',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _carregarReservas,
          ),
        ],
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Calendário ──
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: CalendarDatePicker(
                      initialDate: _dataSelecionada,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2027),
                      selectableDayPredicate: (day) => !_dataBloqueada(day),
                      onDateChanged: (novaData) {
                        setState(() => _dataSelecionada = novaData);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Data selecionada ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.08),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.event_available,
                            color: Color(0xFF1565C0), size: 40),
                        const SizedBox(height: 10),
                        const Text(
                          'Data Selecionada',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _dataFormatada,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ── Botão confirmar ──
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _salvando ? null : _confirmarReserva,
                      icon: _salvando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.calendar_month),
                      label: Text(
                        _salvando ? 'Salvando...' : 'Confirmar Reserva',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}