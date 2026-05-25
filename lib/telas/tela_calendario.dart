import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TelaCalendario extends StatefulWidget {
  const TelaCalendario({super.key});

  @override
  State<TelaCalendario> createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  DateTime _mesAtual = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _dataSelecionada;

  final DateFormat _formatador = DateFormat('MMMM yyyy', 'pt_BR');

  List<DateTime?> _gerarDiasMes(DateTime mes) {
    final primeiroDia = DateTime(mes.year, mes.month, 1);
    final proximoMes = DateTime(mes.year, mes.month + 1, 1);

    final diasNoMes = proximoMes.difference(primeiroDia).inDays;

    final offset = primeiroDia.weekday % 7; // domingo = 0

    final lista = <DateTime?>[];

    // espaços vazios antes do dia 1
    for (int i = 0; i < offset; i++) {
      lista.add(null);
    }

    // dias do mês
    for (int i = 0; i < diasNoMes; i++) {
      lista.add(DateTime(mes.year, mes.month, i + 1));
    }

    return lista;
  }

  void _voltarMes() {
    setState(() {
      _mesAtual = DateTime(_mesAtual.year, _mesAtual.month - 1);
    });
  }

  void _avancarMes() {
    setState(() {
      _mesAtual = DateTime(_mesAtual.year, _mesAtual.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dias = _gerarDiasMes(_mesAtual);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Calendário de Reservas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          const SizedBox(height: 16),

          // HEADER MÊS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _voltarMes,
                  icon: const Icon(Icons.chevron_left),
                ),

                Text(
                  _formatador.format(_mesAtual),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),

                IconButton(
                  onPressed: _avancarMes,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // DIAS DA SEMANA
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('D'),
                Text('S'),
                Text('T'),
                Text('Q'),
                Text('Q'),
                Text('S'),
                Text('S'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // CALENDÁRIO
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: dias.length,
              itemBuilder: (context, index) {
                final dia = dias[index];

                if (dia == null) {
                  return const SizedBox();
                }

                final selecionado = _dataSelecionada != null &&
                    _dataSelecionada!.year == dia.year &&
                    _dataSelecionada!.month == dia.month &&
                    _dataSelecionada!.day == dia.day;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _dataSelecionada = dia;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: selecionado
                          ? Colors.blueAccent
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${dia.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selecionado
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // BOTÃO FINAL
          if (_dataSelecionada != null)
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.all(14),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Data selecionada: '
                        '${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text('Confirmar data'),
              ),
            ),
        ],
      ),
    );
  }
}