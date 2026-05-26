import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Tempo da Splash
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        // Fundo moderno em degradê verde
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff0B3D2E),
              Color(0xff14532D),
              Color(0xff1B5E20),
              Color(0xff2E7D32),
            ],
          ),
        ),

        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Container moderno da logo
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),

                      child: Image.asset(
                        'imagem/resid.png',
                        width: 180,

                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            'Erro ao carregar imagem',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Texto principal
                    const Text(
                      "BEM-VINDO",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Texto secundário
                    Text(
                      "AO CONDOMÍNIO",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green.shade100,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Nome do condomínio
                    Text(
                      "LUXOR",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade200,
                        letterSpacing: 5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Linha decorativa
                    Container(
                      width: 120,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: LoadingDots(),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {

        int dots =
            (DateTime.now().millisecondsSinceEpoch % 3000) ~/ 1000 + 1;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.apartment_rounded,
              color: Colors.green.shade200,
              size: 24,
            ),

            const SizedBox(width: 12),

            Text(
              "Iniciando" + "." * dots,
              style: TextStyle(
                fontSize: 18,
                color: Colors.green.shade100,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        );
      },
    );
  }
}