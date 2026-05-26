import 'package:flutter/material.dart';
import 'dart:async';

import 'home_page.dart';
import '../services/usuario_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  Timer? _timer;

  final UsuarioServiceSQLite _service =
      UsuarioServiceSQLite();

  @override
  void initState() {
    super.initState();

    _timer = Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              service: _service,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        // 🔵 Fundo degradê azul
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF1B263B),
              Color(0xFF274C77),
              Color(0xFF3A86FF),
            ],
          ),
        ),

        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),

                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      // 🔵 Imagem do condomínio
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(28),

                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.25),

                                blurRadius: 20,

                                offset:
                                    const Offset(0, 10),
                              ),
                            ],
                          ),

                          child: Image.network(
                            'https://i.imgur.com/YgSIHou.jpeg',

                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 210,

                            fit: BoxFit.cover,

                            loadingBuilder:
                                (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                              if (loadingProgress ==
                                  null) {
                                return child;
                              }

                              return Container(
                                width: double.infinity,
                                height: 210,

                                alignment:
                                    Alignment.center,

                                decoration:
                                    BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(
                                          0.08),
                                ),

                                child:
                                    const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },

                            errorBuilder:
                                (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                              return Container(
                                width: double.infinity,
                                height: 210,

                                alignment:
                                    Alignment.center,

                                decoration:
                                    BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(
                                          0.08),
                                ),

                                child: const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,

                                  children: [
                                    Icon(
                                      Icons
                                          .broken_image_outlined,
                                      color:
                                          Colors.white,
                                      size: 46,
                                    ),

                                    SizedBox(
                                        height: 10),

                                    Text(
                                      'Erro ao carregar imagem',
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 🔵 Texto principal
                      const Text(
                        'BEM-VINDO',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 34,
                          fontWeight:
                              FontWeight.bold,

                          color: Colors.white,

                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🔵 Texto secundário
                      Text(
                        'AO CONDOMÍNIO RESIDENCIAL',

                        style: TextStyle(
                          fontSize: 18,

                          color:
                              Colors.blue.shade100,

                          letterSpacing: 3,

                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // 🔵 Nome condomínio
                      Text(
                        'IMPERIAL LUXOR',

                        style: TextStyle(
                          fontSize: 42,

                          fontWeight:
                              FontWeight.bold,

                          color:
                              Colors.blue.shade200,

                          letterSpacing: 5,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // 🔵 Linha decorativa
                      Container(
                        width: 120,
                        height: 4,

                        decoration: BoxDecoration(
                          color:
                              Colors.blue.shade300,

                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🔵 Loading
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
  State<LoadingDots> createState() =>
      _LoadingDotsState();
}

class _LoadingDotsState
    extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(
        milliseconds: 1200,
      ),
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
        final dots =
            (_controller.value * 3).floor() + 1;

        return Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              Icons.apartment_rounded,

              color: Colors.blue.shade200,

              size: 24,
            ),

            const SizedBox(width: 12),

            Text(
              'Iniciando${'.' * dots}',

              style: TextStyle(
                fontSize: 18,

                color: Colors.blue.shade100,

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