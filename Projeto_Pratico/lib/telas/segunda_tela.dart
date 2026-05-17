import 'package:flutter/material.dart';

class SegundaTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'Segunda Tela',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Texto centralizado vertical e horizontalmente
          Expanded(
            child: Center(
              child: Text(
                'Você acabou de mudar de tela!',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          // Botão no rodapé
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Voltar para a Tela Inicial',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
