import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int selecionado = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.network(
              'https://i.imgur.com/YgSIHou.jpeg',
              width: double.infinity,
              height: 210,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Residencial',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Imperial Luxor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(Icons.calendar_month_outlined, 'Reservas', 0),
              _buildItem(Icons.check_circle_outline_rounded, 'Check in', 1),
              _buildItem(Icons.output_outlined, 'Check out', 2),
              _buildAvaliacao('Avaliações', 3),
            ],
          ),
        ),
        Expanded(
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo ao App de Reserva do Salão de Festas do Condomínio Imperial Luxor. '
                      'Organizar seu evento ficou muito mais simples. Com o nosso aplicativo, você pode reservar o'
                      'salão de festas do condomínio de forma rápida, transparente e sem burocracia',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Condôminos',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('Filtro clicado');
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.filter_alt,
                                size: 22,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Filtrar',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(IconData icon, String texto, int index) {
    final ativo = selecionado == index;

    return InkWell(
      onTap: () => setState(() => selecionado = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ativo ? Colors.blue : Colors.lightBlueAccent),
          SizedBox(height: 4),
          Text(
            texto,
            style: TextStyle(
              color: ativo ? Colors.blue : Colors.lightBlueAccent,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvaliacao(String texto, int index) {
    final ativo = selecionado == index;

    return InkWell(
      onTap: () => setState(() => selecionado = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (i) => Icon(
                Icons.star,
                size: 18,
                color: ativo ? Colors.blue : Colors.lightBlueAccent,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            texto,
            style: TextStyle(
              color: ativo ? Colors.blue : Colors.lightBlueAccent,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
